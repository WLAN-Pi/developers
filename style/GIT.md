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
