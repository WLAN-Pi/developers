# Tips for Working with debchange

## requires

`debchange` or `dch` is available in the `devscripts` package: `sudo apt install devscripts` 

## debchange - a tool for maintaining the source package changelog file

While you could edit the changelog directly, it is recommended to use `debchange` or its alias `dch` to assist in the modification of the changelog.

If you are regularly using debchange, it is also a good idea to set environment variables on your development machine. 

If you do not, when `debchange` is invoked, it will automatically author the change with `<user@systemname>` when you should use the `Dale Cooper <special_agent@twinpeaks.com>` format.

## debchange - usage tips

### Create a new version entry

You can run debchange from the root of the repository as debchange will climb the directory tree until it finds a `debian/changelog` file.

```bash
(venv) wlanpi@wlanpi:[~/dev/wlanpi-app]: debchange
```

### Update an existing version entry

You should minially use `dch -i` when adding a new changelog because `-i` increases the release number and adds a changelog entry.

If you want to edit the changelog without changing the version or adding a new entry, use `-e` instead of `-i`.

## debchange - versions

On version numbers, from the Debian maintainers guide:

> One tricky case can occur when you make a local package, to experiment with the packaging before uploading the normal version to the official archive, e.g., 1.0.1-1. For smoother upgrades, it is a good idea to create a changelog entry with a version string such as 1.0.1-1~rc1. You may unclutter changelog by consolidating such local change entries into a single entry for the official package.

## debchange - environment variables

You will likely want to set the `DEBFULLNAME` and `DEBEMAIL` environment variables on your development system. Two options demonstrated:

Set per session:

```bash
(venv) wlanpi@rwlanpi:[~/dev/wlanpi-app]: export DEBFULLNAME="Josh Schmelzle"
(venv) wlanpi@wlanpi:[~/dev/wlanpi-app]: export DEBEMAIL="Josh Schmelzle <josh@joshschmelzle.com>"
```

Set to take effect at shell login via `~/.profile`


```bash
# vim ~/.profile
# append the following:
export DEBFULLNAME="Josh Schmelzle"
export DEBEMAIL="Josh Schmelzle <josh@joshschmelzle.com>"
```

## debchange - additional reading

For more information on debchange review the manpages by running `man debchange` from your terminal.

Additionally review the [Debian maintainers guide Chapter 8](https://www.debian.org/doc/manuals/maint-guide/update.en.html).
