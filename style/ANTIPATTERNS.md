# Anti-patterns

An [anti-pattern](http://en.wikipedia.org/wiki/Anti-pattern) is a common response to a recurring problem that is usually ineffective and risks being highly counterproductive.

We should generally aim against creating anti-patterns in our codebase.

## Global variables

In general, do not use `global foobar` in Python. Instead use the Global Object Pattern.

* [The Global Object Pattern](https://python-patterns.guide/python/module-globals/)
* [How do I share global variables across modules?](https://docs.python.org/3/faq/programming.html#how-do-i-share-global-variables-across-modules)
* [How to avoid using global variables?](https://stackoverflow.com/a/59330720)

## Subprocess usage

Shelling out with `subprocess` is sometimes necessary, but it carries real risks.

**Avoid `shell=True`.** It exposes you to shell injection if any part of the command is user-controlled or dynamically constructed. Pass a list of arguments instead.

**Always set a timeout.** A hung subprocess will hang your service. Use `timeout=` and catch `subprocess.TimeoutExpired`.

**Check return codes.** Use `check=True` or inspect `returncode` explicitly. Silent failures from non-zero exits are hard to debug.

**Prefer libraries over shelling out.** If a Python library wraps the same functionality (e.g. `pyroute2` instead of shelling to `ip`), prefer the library. It is more portable and testable.

## Async pitfalls

WLAN Pi services increasingly use async Python (FastAPI, asyncio). A few patterns to avoid:

**Do not call blocking code from an async context.** Blocking a coroutine blocks the entire event loop. Run blocking work in a thread pool executor instead.

**Do not use `time.sleep` in async code.** Use `await asyncio.sleep()` instead.

**Do not create tasks without tracking them.** Fire-and-forget tasks that raise exceptions are silently dropped. Keep a reference or use a task group.

**Do not mix sync and async database sessions.** SQLAlchemy async sessions are not interchangeable with sync sessions. Pick one per service boundary and stay consistent.

## State machines

When a component has more than two or three mutually exclusive operating modes, model it explicitly as a state machine rather than a tangle of boolean flags.

**Avoid flag soup.** A collection of booleans like `is_running`, `is_paused`, `is_error` quickly becomes inconsistent. Use an `Enum` to represent states instead.

**Make transitions explicit.** Define which states can transition to which other states. Reject invalid transitions rather than silently ignoring them.

**Emit events on transition.** If other components need to react to state changes, publish an event or update a shared resource rather than having consumers poll a flag.

wlanpi-fpms is a good reference for a service that uses explicit state to drive display output based on operating mode.

## Caching and duplicate requests

wlanpi-core acts as the central data provider for the platform. Multiple consumers (wlanpi-webui, wlanpi-fpms, third-party clients) may request the same data concurrently. Without caching, each request triggers a separate underlying operation; a scan, a subprocess call, a file read; multiplying load unnecessarily.

**Cache expensive operations at the service layer, not the consumer layer.** The cache belongs in wlanpi-core, not in each consumer that calls it.

**Use a short TTL for volatile data.** Scan results, link state, and neighbor tables change frequently. A TTL of a few seconds prevents stale reads while still collapsing burst requests.

**Coalesce concurrent requests for the same resource.** If multiple clients request a Wi-Fi scan at the same time, only one scan should run. The others should wait and share the same result if a scan is in progress. In pseudocode:

```
if cached and not expired: return cached result
if request already in flight: await that task
otherwise: run the operation, cache the result, return it
```

**Do not cache authentication-sensitive data across users.** Per-user or per-session data must not be shared via a shared cache.

## File extensions

### Use an extension that matches the contents

Here is an example where the extension and filename misleads the reader to assume the file contents follow a packet capture format, however, the contents are instead an ASCII dump and the file is not readable by Wireshark.

```bash
wlanpi@wlanpi:/tmp $ file lldpneightcpdump.cap
lldpneightcpdump.cap: ASCII text
```

The file extension is misleading. The better file extension in this example would be `.txt` or similar rather than `.cap`. It better represents the contents.

A file with extension `.cap` should have contents similar to this:

```bash
wlanpi@wlanpi:~ $ file test.cap
test.cap: pcap capture file, microsecond ts (little-endian) - version 2.4 (Ethernet, capture length 262144)
```

## More anti-patterns

- [Bash: Why is testing "$?" to see if a command succeeded or not, an anti-pattern?](https://stackoverflow.com/questions/36313216/why-is-testing-to-see-if-a-command-succeeded-or-not-an-anti-pattern)
- [Python Anti-Patterns](https://docs.quantifiedcode.com/python-anti-patterns/)
