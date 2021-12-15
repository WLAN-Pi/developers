# Manpage Creation and Generation for your WLAN Pi Application

If you're reading this, you are likely ambitious! It is not mandatory to create a manpage for your application, but you should because it can be a nice touch and to have.

You will likely want to write your manpage using Markdown and then convert it to the appropriate format. We can do that with [pandoc](https://pandoc.org/).

Otherwise, feel free to write it directly in _groff_.

## Write your manpage in Markdown

Here is a short fictional sample you could reference:

```text
% wlanpi-lodge(1) Wi-Fi lodge

# NAME

WLANPI-LODGE

# DESCRIPTION

wlanpi-lodge is a suite of applications for the lodge.

# SYNOPSIS

**lodge** [ _OPTIONS_ ]

_OPTIONS_ := { --read | --version | --debug }

# FILES

/etc/wlanpi-peaks

/opt/wlanpi-lodge

# AUTHORS

wlanpi-lodge is developed and maintained by Laura Palmer, with the assistance
from a list of wonderful folks from the Twin Peaks.

# REPORTING BUGS

Bugs and issues can be reported on GitHub:

https://github.com/wlan-pi/twinpeakslodge

# COPYRIGHT

Copyright © 2022 Laura Palmer. License BSD-3-Clause.
```

Otherwise, reference the Markdown manpage for [wlanpi-profiler/debian/wlanpi-profiler.1.md](https://github.com/WLAN-Pi/wlanpi-profiler/blob/main/debian/wlanpi-profiler.1.md).

## Install Dependencies

Please note that there is no armhf package for pandoc, but there is an arm64 package.

If your host is arm64:

```bash
cd ~
wget https://github.com/jgm/pandoc/releases/download/2.16.2/pandoc-2.16.2-1-arm64.deb
sudo apt install ~/pandoc-2.16.2-1-arm64.deb
```

Otherwise, find the package for your host on the [pandoc releases](https://github.com/jgm/pandoc/releases/) page.

## Generating the Man Page

In the same directory as your manpage create a new script with the following contents:

Name: `manpage.sh`

```bash
#!/bin/sh
echo >&2 "Generating man page using pandoc"
pandoc -s -f markdown-smart -t man wlanpi-lodge.1.md -o wlanpi-lodge.1 || exit
echo >&2 "Done. You can read it with:   man ./wlanpi-lodge.1"
```

Feel free to improve the script on your own.

Make sure `manpage.sh` is executable.

```bash
chmod +x manpage.sh
```

Ok, let's generate our manpage by running `manpage.sh`:

```bash
./manpage.sh
```

You should see something like this:

```bash
wlanpi@rbpi4b-8gb:[~/dev/profiler/debian]: ./manpage.sh
Generating man page using pandoc
Done. You can read it with:   man ./wlanpi-profiler.1
```

## Viewing the newly created Man Page

You should definitely check over your man page before committing it.

```bash
man ./wlanpi-lodge.1
```
