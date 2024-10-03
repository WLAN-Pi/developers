# GitHub

## Issues

If something comes up. A problem. A bug. A feature. Even if you're working on something else. Create an issue in the respective repository.

## Pull Requests

### What are Pull Requests?

These were created in the open source world outside of git. For example GitHub and BitBucket do these things.

### Why do we do Pull Requests?

* Enable Code Review prior to merging into main.
* Enable Checking (run CI tests) prior to merging into main which helps catch errors and bugs.

### PRs should close issues

* When you are working on a PR to the default branch (`main` for us), that PR should be working to close open and documented issues.
* The comments should mention "closes #42, fixes #66", etc. Use keywords such as close, closes, closed, fix, fixes, fixed, resolve, resolves, resolved followed by a # to automatically get a pop up with list of open issues.
* [https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue).

if something comes up, it needs to be an issue. even if it's found while working something else. When a PR is submitted, the comments should say "resolves #42, #99" etc.

## Read More

* [About pull requests from GitHub](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)