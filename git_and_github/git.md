# Git

## Packaging

- All packages should be using Git.

## Workflow

- One change per commit. Do not add multiple changes to a single commit. It eases review.

- Do not commit debian/changelog along with the changes. Use `dch` to update the changelog.

- The commit message should have a short (<=72 characters) summary of the change followed by a blank newline, although per Git recommendations, it's advised to aim for a summary of 50 characters or less. After that, you can elaborate on the change in the body.

## Tagging

Each release version should have a git tag.

Example: `git tag v1.2.3 -m "Release version 1.2.3"`, in which case `v1.2.3` is a tag name and the semantic version is `1.2.3`.

Use `git push origin <tag_name>` to push your local tag to the remote repository (Github).

## Branch Naming Conventions

main

- release branch (regression) for tests in production environment
- goal is to have no direct commits on main, all commits and content should come from merges from dev branch

dev	

- development branch, parent for all other branches
- no direct commits on development, all content comes from pull request merges/rebases

u/<user>/<content>	

- user branches for development
- created from `dev`, then rebased back onto `dev` via pull requests
- short-term branch that is safe to delete after code review and merge to `dev`

feature/<content>

- branch shared by more than one user for longer term feature development

bugfix/<content>	

- branch for tracking lifecycle of a bugfix