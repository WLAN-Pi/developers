# Packaging Guide for the WLAN Pi

## Newcomers

Newcomers should refer to the existing packages on the [WLAN Pi GitHub page](https://github.com/wlan-pi/) and refer to the links at the bottom of this article for references and rationale.

## Intent to Package

If the package you would like to work on is new to WLAN Pi, you should announce your intention to create the package.
You do this by contacting a [team member](https://github.com/orgs/WLAN-Pi/people).

## Team Policy

It will be expected that you have read the architecture documentation and references.

To harmonize the packages with-in the WLAN Pi maintainers team, adhere to the additional following  policy:

### `debian/control`

Consider the following when creating or modifying the package's control file.

| | |
|--------------|-----------|
| Section | Use `contrib/python` or `embedded` |
| Priority      | Use `optional` as the priority  |
| Maintainer | List the primary maintainer of the package |
| Standards-Version | Use the latest unless you have a reason not to |
| Homepage | This should always be included and link to the website hosting the source code |
| Package | This should match the debhelper-build-stamp |
| Description | Include a succinct description of what the package is for |

### `debian/copyright`

Use a machine-readable format for the `debian/copyright` file.

### `debian/changelog`

Maintain release notes for each version of your package here.

### `debian/compat`

Debhelper uses compatibility levels to control the behavior of its commands. Currently, the recommendation is to use a compatibility level of `13` which is available in both stable (bullseye) and as a backport in oldstable (buster).

Note, there is no need to touch packages only because it has an older Debhelper compat version.

In some cases, a lower compatibility is desired like `11` where `dh_dwz` is not run by default as it is in `12`.

### `debian/debhelper-build-stamp`

This should include the name of your package with a `wlanpi-` prefix.

### `debian/rules`

This is absolutely required for packages using dh_virtualenv. Refer to their documentation for what to place here.

### OSS Attribution

Give attribution where it is due. If you rely on another package, refer to it in `OSS.md` in the base of your repo.

## Read More

- [Spotify's dh_virtualenv documentation](https://dh-virtualenv.readthedocs.io/)
- [Debian New Maintainers' Guide](https://www.debian.org/doc/manuals/maint-guide/)
- [Debian Policy](https://www.debian.org/doc/debian-policy/)
- [Debian Developer's Reference](https://www.debian.org/doc/manuals/developers-reference/)