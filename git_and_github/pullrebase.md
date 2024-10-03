# `git pull --rebase`

When working with code locally, you can use `git pull rebase` to update your local code.

## How to git pull rebase

Rebasing with `git pull` can be done by appending `--rebase` to the CLI command.

```bash
git pull --rebase
```

It is recommended to set your global git config like so:

```bash
git config --global pull.rebase true
```

If you use the global setting, `git pull` will always run with `git pull --rebase` and git rebase whenever `git pull` is run.

## Rationale

* git pull without rebase will create merge. Most of the time we don't want that.
* Merges are better kept at the PR merge at GitHub. Locally we shouldn't need to merge.
* Less polluted commits with git pull rebase.
* At PR we have to merge anyways.

Hence, without git rebase, you may get merge. So, as much as possible, try to use git rebase with pull locally.

## Should we use rebase?

Feel free to rebase on your own commits locally that are not shared.

Rule of thumb is rebase locally, but never rebase on remote.

We don't want to re-write git history on shared commits.

## More reading

* https://gitolite.com/git-pull--rebase
* https://coderwall.com/p/7aymfa/please-oh-please-use-git-pull-rebase
* https://stackoverflow.com/questions/2472254/when-should-i-use-git-pull-rebase
