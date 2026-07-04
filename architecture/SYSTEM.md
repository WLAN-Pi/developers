# WLAN Pi System Architecture

This document describes the runtime architecture of the WLAN Pi platform: how the core services relate to each other, how requests flow through the stack, and how the system uses Linux primitives like systemd, dbus, and network namespaces.

## Overview

```
                        ┌─────────────────────────────────┐
                        │            Browser /            │
                        │         External Client         │
                        └────────────────┬────────────────┘
                                         │ HTTP / WebSocket
                                         ▼
                        ┌─────────────────────────────────┐
                        │             nginx               │
                        │   (reverse proxy, TLS, static)  │
                        └────────┬──────────────┬─────────┘
                                 │              │
                   /api/*        │              │  /* (UI)
                                 ▼              ▼
                   ┌─────────────────┐  ┌──────────────────┐
                   │   wlanpi-core   │  │   wlanpi-webui   │
                   │  FastAPI/uvicorn│  │   Flask/gunicorn │
                   │   :8000         │  │   :5000          │
                   └────────┬────────┘  └────────┬─────────┘
                            │                    │
                            │  internal HTTP     │
                            └────────────────────┘
                                     │
                     ┌───────────────┼───────────────┐
                     │               │               │
                     ▼               ▼               ▼
              subprocess /       dbus IPC       network
              system calls                    namespaces
```

## Components

### nginx

nginx sits at the edge and handles all inbound HTTP/HTTPS traffic.

- Serves static assets for wlanpi-webui directly from the filesystem
- Proxies `/api/*` requests to wlanpi-core (port 8000)
- Proxies all other requests to wlanpi-webui (port 5000)
- Handles TLS termination
- Enforces request size limits and timeouts before traffic reaches application code

Configuration lives in `/etc/nginx/`.

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

- Built with [Flask](https://flask.palletsprojects.com/) and served by [gunicorn](https://gunicorn.org/)
- Uses [htmx](https://htmx.org/) for partial page updates without a full JS framework
- Fetches data from wlanpi-core over HTTP (internal loopback)
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
    After=network-online.target

wlanpi-webui.service
    After=wlanpi-core.service

wlanpi-fpms.service
    After=wlanpi-core.service

nginx.service
    After=wlanpi-core.service wlanpi-webui.service
```

- `wlanpi-core` must be healthy before dependent services start
- Services use `Restart=on-failure` so systemd recovers transient crashes
- Log output goes to the journal; use `journalctl -u wlanpi-core` to inspect

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

1. Browser sends `GET /api/v1/network/scan` to nginx
2. nginx proxies to wlanpi-core on port 8000
3. wlanpi-core checks its cache; if fresh, returns the cached result immediately
4. On a cache miss, wlanpi-core runs `iw dev wlan0 scan` in the correct network namespace
5. Result is cached with a short TTL and returned as JSON
6. Concurrent requests that arrive during the scan wait on the same in-flight task and share the result

## See Also

- [Filesystem Hierarchy Structure](FHS.md)
- [Packaging](PACKAGING.md)
- [Anti-patterns](../style/ANTIPATTERNS.md)
- [FastAPI documentation](https://fastapi.tiangolo.com/)
- [uvicorn](https://www.uvicorn.org/)
- [gunicorn](https://gunicorn.org/)
- [htmx](https://htmx.org/)
- [Linux network namespaces](https://man7.org/linux/man-pages/man8/ip-netns.8.html)
