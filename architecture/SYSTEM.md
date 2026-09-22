# WLAN Pi System Architecture

This document describes the runtime architecture of the WLAN Pi platform: how the core services relate to each other, how requests flow through the stack, and how the system uses Linux primitives like systemd, dbus, and network namespaces.

## Overview

```
                        ┌─────────────────────────────────┐
                        │            Browser /            │
                        │         External Client         │
                        └────────────────┬────────────────┘
                                         │ HTTPS (443, 80→443 redirect)
                                         ▼
                        ┌─────────────────────────────────┐
                        │      nginx (wlanpi-webui)       │
                        │  session gate (auth_request)    │
                        └──┬───────┬───────┬───────┬──────┘
                           │       │       │       │
             /             │       │       │       │  /app/cockpit
                           │       │       │       │
                           ▼       ▼       ▼       ▼
              unix:/run/   :8081   :3000   :9090
              wlanpi_webui  librespeed grafana cockpit
              .sock            (UI assets / apps)
                           │
                           │ internal HTTPS
                           ▼
              ┌──────────────────────────┐
              │  nginx (wlanpi-core)     │
              │  listen 31415            │
              └────────────┬─────────────┘
                           │
                           ▼
              unix:/run/wlanpi_core.sock
              ┌──────────────────────────┐
              │        wlanpi-core       │
              │   FastAPI / uvicorn      │
              └────────────┬─────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
     subprocess /      dbus IPC        network
     system calls                    namespaces
```

The front nginx is shipped by the `wlanpi-webui` package and terminates TLS on
443. `wlanpi-core` ships its own nginx instance that listens on 31415 and
forwards to the core application over a unix socket; it is only reached from
the webui process on loopback.


## Components

### nginx

Two nginx instances run on the platform.

The front instance is shipped by the `wlanpi-webui` package and sits at the
edge. It listens on 443 (and redirects 80 to 443) and:

- Serves static assets for wlanpi-webui directly from the filesystem
- Routes `/` to wlanpi-webui over `unix:/run/wlanpi_webui.sock`
- Routes `/app/librespeed/` to `127.0.0.1:8081`
- Routes `/app/grafana/` to `127.0.0.1:3000`
- Routes `/app/cockpit/` to `127.0.0.1:9090`
- Gates requests with `auth_request /auth/check` against wlanpi-webui, except
  the login, password-change, and logout endpoints
- Handles TLS termination and enforces request size limits and timeouts before
  traffic reaches application code

Configuration is installed under `/etc/wlanpi-webui/nginx/`.

The second instance is shipped by the `wlanpi-core` package. It listens on
31415 on loopback and proxies `/` to the core application over
`unix:/run/wlanpi_core.sock`. It is not reachable from outside the device.
Configuration is installed under `/etc/wlanpi-core/nginx/`.

### wlanpi-core

wlanpi-core is the central data and control API for the platform. It is the authoritative source of truth for device state, network information, and hardware data.

- Built with [FastAPI](https://fastapi.tiangolo.com/) and served by [uvicorn](https://www.uvicorn.org/)
- Exposes a REST API and WebSocket endpoints
- Uses SQLAlchemy async for any persistent state
- Authenticates requests via [Authlib](https://docs.authlib.org/)
- Shells out to system tools (iw, iwconfig, ip, ethtool, etc.) for hardware data
- Communicates with other services over dbus where appropriate
- Runs as a systemd service (`wlanpi-core.service`)

Because wlanpi-core is the shared backend for multiple consumers, expensive operations should be cached with a short TTL and concurrent requests for the same resource should be coalesced. See [Anti-patterns: Caching and duplicate requests](../style/ANTIPATTERNS.md#caching-and-duplicate-requests).

### wlanpi-webui

wlanpi-webui is the browser-facing UI for the platform.

- Built with [Flask](https://flask.palletsprojects.com/) and served by [gunicorn](https://gunicorn.org/) over `unix:/run/wlanpi_webui.sock`
- Uses [htmx](https://htmx.org/) for partial page updates without a full JS framework
- Fetches data from wlanpi-core at `https://127.0.0.1:31415/api/v1/...` over loopback
- Terminates user sessions and exposes the `/auth/check` endpoint used by the front nginx `auth_request` gate
- Does not talk directly to hardware; all data comes through wlanpi-core
- Runs as a systemd service (`wlanpi-webui.service`)

wlanpi-webui should be treated as a thin presentation layer. Business logic and data access belong in wlanpi-core.

### wlanpi-fpms

wlanpi-fpms drives the front panel display (OLED screen and buttons).

- Uses [luma.oled](https://luma-oled.readthedocs.io/) for display rendering
- Uses [gpiod](https://libgpiod.readthedocs.io/) / [gpiozero](https://gpiozero.readthedocs.io/) for button input
- Communicates with wlanpi-core over HTTP for device data
- Uses [dbus-python](https://dbus.freedesktop.org/doc/dbus-python/) for IPC with other services
- Uses [textfsm](https://github.com/google/textfsm) for parsing structured CLI output
- Models display state explicitly as a state machine keyed to operating mode

## systemd service relationships

Services are managed by systemd and declare dependencies in their unit files.

```
wlanpi-core.service
    Requires=wlanpi-core.socket var-log-wlanpi_core-debug.mount
    Wants=nginx.service
    After=network-pre.target nginx.service

wlanpi-webui.service
    Requires=wlanpi-webui.socket
    After=network.target

nginx.service
    (managed by the nginx package; both applications expect it present)
```

- Both applications run under gunicorn: wlanpi-core uses `uvicorn.workers.UvicornWorker` for the ASGI app, wlanpi-webui uses the WSGI app.
- Each binds a unix socket in `/run/` (`wlanpi_core.sock`, `wlanpi_webui.sock`) rather than a TCP port.
- Log output goes to the journal and to `/var/log/wlanpi_core/`; use `journalctl -u wlanpi-core` to inspect.

## dbus IPC

Some WLAN Pi services use dbus for lightweight inter-process communication, particularly for signaling state changes (operating mode changes, hardware events) without polling.

- wlanpi-fpms uses dbus to receive mode change events from the platform
- Avoid dbus for large data payloads; use HTTP to wlanpi-core for data queries
- dbus is appropriate for fire-and-forget signals and method calls with no large response body

## Network namespaces

The WLAN Pi uses Linux network namespaces to isolate network interfaces for certain operating modes (e.g. Wi-Fi client mode vs. hotspot mode vs. packet capture mode).

- Each namespace has its own independent network stack (interfaces, routes, iptables rules)
- wlanpi-core is namespace-aware: it queries the correct namespace when fetching interface data
- Subprocess calls that query interface state must target the correct namespace explicitly

References:

- [Linux network namespaces](https://man7.org/linux/man-pages/man8/ip-netns.8.html)
- [Linux namespaces overview](https://man7.org/linux/man-pages/man7/namespaces.7.html)

## Request flow example

A browser request for a Wi-Fi scan result:

1. Browser sends `GET /network/scan` (or another UI route) to the front nginx on 443
2. nginx runs `auth_request /auth/check` against wlanpi-webui, then proxies the request to wlanpi-webui over `unix:/run/wlanpi_webui.sock`
3. wlanpi-webui calls wlanpi-core at `https://127.0.0.1:31415/api/v1/...`
4. The core nginx instance forwards to wlanpi-core over `unix:/run/wlanpi_core.sock`
5. wlanpi-core checks its cache; if fresh, returns the cached result immediately
6. On a cache miss, wlanpi-core runs `iw dev wlan0 scan` in the correct network namespace
7. Result is cached with a short TTL and returned as JSON
8. Concurrent requests that arrive during the scan wait on the same in-flight task and share the result

## See Also

- [Filesystem Hierarchy Structure](FHS.md)
- [Packaging](PACKAGING.md)
- [Anti-patterns](../style/ANTIPATTERNS.md)
- [FastAPI documentation](https://fastapi.tiangolo.com/)
- [uvicorn](https://www.uvicorn.org/)
- [gunicorn](https://gunicorn.org/)
- [htmx](https://htmx.org/)
- [Linux network namespaces](https://man7.org/linux/man-pages/man8/ip-netns.8.html)
