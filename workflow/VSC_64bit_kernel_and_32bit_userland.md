# Visual Studio Code (VSC) Remote-SSH Installation Troubleshooting

## Seeing `node not found` or VSC not launching in the Remote-SSH session?

Something like this during install:

```bash
> /home/wlanpi/.vscode-server/bin/f4af3cbf5a99787542e2a30fe1fd37cd644cc31f/server.sh: 
12: /home/wlanpi/.vscode-server/bin/f4af3cbf5a99787542e2a30fe1fd37cd644cc31f/server.sh: 
/home/wlanpi/.vscode-server/bin/f4af3cbf5a99787542e2a30fe1fd37cd644cc31f/node: not found
```

Or perhaps you're seeing `Waiting for server log...` and the install just times out with no useful information.

This can occur if the device is using an arm64 kernel with an armhf (32bit) userland.

Here’s a different workaround while we wait for a better fix (which would be for VSC to check `getconf LONG_BIT` or `file /usr/bin/ls` instead of `uname -a`):

Example:

```bash
wlanpi@wlanpi-cm4-emmc-waves:[~]: file /usr/bin/ls
/usr/bin/ls: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, for GNU/Linux 3.2.0, BuildID[sha1]=67a394390830ea3ab4e83b5811c66fea9784ee69, stripped
wlanpi@wlanpi-cm4-emmc-waves:[~]: getconf LONG_BIT
32
wlanpi@wlanpi-cm4-emmc-waves:[~]: uname -a
Linux wlanpi-cm4-emmc-waves 5.15.0-v8-WLAN_Pi+ #2 SMP PREEMPT Fri Nov 5 11:55:13 CDT 2021 aarch64 GNU/Linux
```

## Problem

Currently, VSC is checking `uname -a`, so let’s trick VSC server install, since we’ve got 32 bit userland.

## Workaround

First validate where uname is on the $PATH:

```bash
wlanpi@wlanpi-cm4-emmc-waves:[/usr/local/bin]: which uname
/usr/bin/uname
wlanpi@wlanpi-cm4-emmc-waves:[/usr/local/bin]: $PATH
-bash: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/wlanpi/pipx/bin: No such file or directory
```

Put a file with the following contents somewhere in your $PATH before /usr/bin (for example into /usr/local/bin/uname).

Example:

```bash
sudo vim /usr/local/bin/uname
```

Add:

```bash
#!/bin/sh
exec /bin/uname “$@” | sed ‘s/aarch64/armv7l/’
```

Make sure it is executable:

```bash
chmod +x /usr/local/bin/uname
```

Verify before trying to install VSC again:

```bash
wlanpi@wlanpi-cm4-emmc-waves:[~]: /usr/local/bin/uname -a
Linux wlanpi-cm4-emmc-waves 5.15.0-v8-WLAN_Pi+ #2 SMP PREEMPT Fri Nov 5 11:55:13 CDT 2021 armv7l GNU/Linux
wlanpi@wlanpi-cm4-emmc-waves:[~]: /usr/bin/uname -a
Linux wlanpi-cm4-emmc-waves 5.15.0-v8-WLAN_Pi+ #2 SMP PREEMPT Fri Nov 5 11:55:13 CDT 2021 aarch64 GNU/Linux
```

OK, now we need to remove the old install files.

```bash
rm -rf ~/.vscode-server
```

Now you should be able to create a new Remote-SSH session from your host to the WLAN Pi.

VSC should install with no problems your host running an arm64 kernel with armhf userland.
