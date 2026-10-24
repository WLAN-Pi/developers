# Land a Fix and Cut a Release

A fix does not change the package version. The release pull request does.

Do the git steps below now. The dev stamp, and an upload of a final version to `wlanpi/main`, are not in CI yet. Until they are, a `debian/changelog` change on `main` still uploads to [wlanpi/dev](https://packagecloud.io/wlanpi/dev). A maintainer still promotes that package to [wlanpi/main](https://packagecloud.io/wlanpi/main) by hand. [Release Process](RELEASE_PROCESS.md#4-deploy-to-packagecloud) is that current step.

## Land a Fix

1. Branch from `main`.
2. Change the package. Do not edit `debian/changelog`. Do not edit `__version__.py`. Do not run `dch`.
3. In the pull request, write one line that says what changed for the person installing the package.
4. Squash-merge to `main`. Use that line as the merge subject, and keep the pull request number. [Contributing](CONTRIBUTING.md#merging-for-maintainers) says squash merge is the default.

That subject is the release note. A fix branch has no version. If `main` moves, merge `main` into the branch. Do not add a version.

## Where a Dev Build Goes

When the stamp is live, a push to `main` that is not a release builds in the CI workspace and uploads the `.deb` to `wlanpi/dev`. Git stays on the last release. CI does not tag that build.

The deb version is the next patch, then the dev suffix `~dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>`. Strip a Debian revision before adding 1 to the patch, so `2.4.12-1` yields `2.4.13~dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>`.

In that `.deb`, `__version__.py` is `X.Y.Z.dev<YYYYMMDD>` in PEP 440. For the same build the deb version is `X.Y.Z~dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>`.

`dpkg` 1.22.6 sorts `2.4.12-1` below `2.4.13~dev20261024.1+gabcdef1`, below `2.4.13~rc1`, below `2.4.13`.

## Choose the Next Release Version

The stamp uses the next patch. The release pull request can ship that patch, or a higher minor or major.

After `2.4.13` is the committed version, dev builds are `2.4.14~dev...`. A release of `2.5.0` sorts above `2.4.14~dev20261024.1+gabcdef1`. The next push then stamps `2.5.1~dev...`.

To put dev builds on `2.5.0` before that release, commit changelog `2.5.0~rc1` and set `__version__.py` to `2.5.0rc1`. Later pushes stamp `2.5.0~rc1+dev<YYYYMMDD>.<run_id>.<run_attempt>+g<sha>`. That sorts above `2.5.0~rc1` and below `2.5.0`. `dpkg` 1.22.6 also sorts `2.4.14~dev20261024.1+gabcdef1` below `2.5.0~rc1`.

`2.4.12` sorts below `2.4.12-1`. Do not drop a Debian revision from a version that is already published. The first native version is the next upstream version, such as `2.4.13`. The version form is in [Source Format and Version](architecture/PACKAGING.md#source-format-and-version).

## Publish a Release

Skip the release when every subject since the last changelog commit is only docs or only CI.

1. On current `main`, before the release commit exists, list the subjects.

```bash
git log --first-parent --reverse --format='%s' \
  "$(git log -1 --format=%H -- debian/changelog)"..HEAD
```

A fix that edited `debian/changelog` becomes the start of that range. Until those commits stop, start the log at the last release you mean to cover.

2. Branch `release/<version>` from `main`. Write the stanza with no Debian revision.

```bash
dch -v 2.4.13 "Release version 2.4.13"
dch -r ""
```

On a changelog that still says `2.4.12-1`, `dch -i` writes `2.4.12-2`. Do not use `dch -i` for this release. [Debchange](style/DCH.md) covers `DEBFULLNAME` and `DEBEMAIL`.

Drop docs-only subjects and CI-only subjects. Keep one bullet for each remaining package-content subject. Rewrite a bullet when the subject is unclear. Add a reference only when the commit body already has it.

3. Set `__version__.py` to the same `major.minor.patch` in repos that have the file. For changelog `2.4.13~rc1`, set `__version__.py` to `2.4.13rc1`.

4. On the first native release, set `debian/source/format` to `3.0 (native)` in that same commit.

5. Open one pull request and merge it.

When this CI is live, that merge uploads to `wlanpi/main` and tags `v<version>` if the changelog version is final and has no `~`. A version that contains `~` uploads to `wlanpi/dev` and is not tagged. There is no hand copy from `wlanpi/dev` to `wlanpi/main`.

Repos whose deploy workflow does not call `tag-release` still use [Tag the Release](RELEASE_PROCESS.md#5-tag-the-release).
