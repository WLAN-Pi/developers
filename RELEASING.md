# Land a Fix and Cut a Release

A fix does not change the package version. The release pull request does.

## What Is Live

Live now:

- The fix steps and the release steps on this page.
- A `debian/changelog` push to `main` uploads to [wlanpi/dev](https://packagecloud.io/wlanpi/dev).
- Promotion to [wlanpi/main](https://packagecloud.io/wlanpi/main) is done by hand. [Release Process](RELEASE_PROCESS.md#4-deploy-to-packagecloud) is that step.

Planned, and not live yet:

- The dev stamp.
- An upload to `wlanpi/main` when the release pull request merges.
- An automatic tag.

## Scope

This page covers first-party packages that use `debian/changelog`. See [Source Format and Version](architecture/PACKAGING.md#source-format-and-version).

A forked upstream project versions as `<upstream>+wlanpi<N>`, for example `2.3.0+wlanpi1`. The suffix marks our rebuild of that upstream version, so we do not take the number upstream will publish next.

**pi-gen** and the **kernel** follow their own rules. They are out of scope.

WLAN Pi OS image versions are `YY.MM[.point][-type.sequence]-CODENAME`. The git tag is that string with no `v` prefix, for example `26.08-Cortado`. A dispatched build publishes a GitHub pre-release, and a maintainer promotes a final build to the latest stable release by hand. See [Release a WLAN Pi OS image](https://github.com/WLAN-Pi/pi-gen/blob/trixie64/docs/RELEASING.md).

The kernel has no `debian/changelog`. The next 2712 kernel is `7.3.1` or later. Planned CI maps an upstream `-rcN` to `~rcN`, and it refuses an upload that does not sort above the top version on both `wlanpi/dev` and `wlanpi/main`.

The first native version of a package that is still published with a Debian revision is the next upstream version. Do not reuse the `-1` version. Those first native versions are core `2.4.13`, webui `1.21.19`, fpms `1.4.26`, profiler `2.1.9`, and mcp `0.7.1`.

## Land a Fix

1. Branch from `main`.
2. Change the package. Do not edit `debian/changelog`. Do not edit `__version__.py`. Do not run `dch`.
3. In the pull request, write one line that says what changed for the person installing the package.
4. Squash-merge to `main`. Use that line as the merge subject, and keep the pull request number. [Contributing](CONTRIBUTING.md#merging-for-maintainers) says squash merge is the default.

That subject is the release note. A fix branch has no version. If `main` moves, merge `main` into the branch. Do not add a version.

## Where a Dev Build Goes

When the stamp is live, a push to `main` that is not a release builds in the CI workspace and uploads the `.deb` to `wlanpi/dev`. Git stays on the last release. CI does not tag that build.

The deb version is the next patch, then `~dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>`. Strip a Debian revision before adding 1 to the patch, so `2.4.12-1` yields `2.4.13~dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>`.

In that `.deb`, `__version__.py` is `X.Y.Z.dev<YYYYMMDD>` in PEP 440. For the same build the deb version is `X.Y.Z~dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>`.

`dpkg` 1.22.6 sorts `2.4.12-1` below `2.4.13~dev20261024.1842.1+gabcdef1`, below `2.4.13~rc1`, below `2.4.13`.

## Choose the Next Release Version

The stamp uses the next patch (once the stamp is live). The release pull request can ship that patch, or a higher minor or major.

After `2.4.13` is the committed version, dev builds are `2.4.14~dev...` (once the stamp is live). A release of `2.5.0` sorts above `2.4.14~dev20261024.1842.1+gabcdef1`. The next push then stamps `2.5.1~dev...` (once the stamp is live).

To put dev builds on `2.5.0` before that release, commit changelog `2.5.0~rc1` and set `__version__.py` to `2.5.0rc1`. Later pushes stamp `2.5.0~rc1+dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>` (once the stamp is live). That sorts above `2.5.0~rc1` and below `2.5.0`. `dpkg` 1.22.6 also sorts `2.4.14~dev20261024.1842.1+gabcdef1` below `2.5.0~rc1`.

`2.4.12` sorts below `2.4.12-1`. Do not drop a Debian revision from a version that is already published. The version form is in [Source Format and Version](architecture/PACKAGING.md#source-format-and-version).

## Publish a Release

Skip the release when every subject since the last final release is docs-only or CI-only.

1. On current `main`, before the release commit exists, list the subjects since the last final release. Use its `v<last>` tag when that tag exists.

```bash
git log --first-parent --reverse --format='%s' v2.4.12..HEAD
```

Core's last final tag is `v2.4.12`. After `2.4.13` is released, start at `v2.4.13`. When the last final release has no tag, use that release's commit in place of the tag. An rc commit is not a valid start. A fix that edited `debian/changelog` is not a valid start.

Check [wlanpi/dev](https://packagecloud.io/wlanpi/dev) and [wlanpi/main](https://packagecloud.io/wlanpi/main). Pick a version that sorts above every version of this package on both repos. Treat a version on either repo as already used. Packagecloud rejects a duplicate filename, so after `2.5.0~rc1` is uploaded the next candidate is `2.5.0~rc2`.

2. Branch `release/<version>` from `main`. Drop docs-only subjects and CI-only subjects. Write the stanza with no Debian revision. `dch -v` adds one placeholder bullet. Delete that bullet, or keep it on purpose. Run `dch -a` once for each remaining subject.

```bash
dch -v 2.4.13 "Release version 2.4.13"
dch -a "Fix the capture timeout (#431)"
dch -r ""
```

On a changelog that still says `2.4.12-1`, `dch -i` writes `2.4.12-2`. Do not use `dch -i` for this release. On the first native cut, `dch` warns `New package version is Debian native whilst previous version was not`. That warning is expected. [Debchange](style/DCH.md) covers `DEBFULLNAME` and `DEBEMAIL`.

Rewrite a bullet when the subject is unclear. Add a reference only when the commit body already has it.

3. Set `__version__.py` to the same `major.minor.patch` in repos that have the file. For changelog `2.4.13~rc1`, set `__version__.py` to `2.4.13rc1`.

4. On the first native release, set `debian/source/format` to `3.0 (native)` in that same commit.

5. Open one pull request and merge it.

When the planned CI is live, that merge uploads a final version with no `~` to `wlanpi/main` and tags `v<version>`. A version that contains `~` uploads to `wlanpi/dev` and is not tagged. Repos whose deploy workflow does not call `tag-release` still use [Tag the Release](RELEASE_PROCESS.md#5-tag-the-release).

6. After the deploy, check both `wlanpi/dev` and `wlanpi/main` before you call it released. While promotion is by hand, call it released only once that version is on both, which is after the copy.
