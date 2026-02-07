# Contributing to WLAN Pi

This guide covers how to contribute code to WLAN Pi projects. For setting up your development environment, see [Getting Started](GETTING_STARTED.md).

## Prerequisites

- A GitHub account
- Basic familiarity with git (see [Git Basics](#git-basics) below if needed)
- Access to a WLAN Pi device for testing (optional but recommended)

## Git basics

If you're new to Git, we recommend these resources:

- [GitHub Git Guide](https://docs.github.com/en/get-started/quickstart/git-and-github-learning-resources) - Official GitHub learning resources
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Practical solutions to common Git problems
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/) - Deep technical understanding

## Workflow overview

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
3. **Create a branch** from `dev`
4. **Make your changes** with clear, focused commits
5. **Push** to your fork
6. **Open a Pull Request** to the `dev` branch

## Branch naming

When creating branches for your work, use one of these patterns:

```
u/<username>/<description>       # Personal work
feature/<description>            # Shared feature work
bugfix/<description>             # Bug fixes
```

Examples:
- `u/john/add-wifi-scan`
- `feature/metrics-dashboard`
- `bugfix/memory-leak-profiler`

## Commit guidelines

- **One change per commit** - Don't bundle unrelated changes

- **Clear commit messages** - Start with a verb, keep summary around 72 characters
  
  Good: `Add support for 802.11ax packet capture`
  
  Bad: `updates`

- **Don't manually edit `debian/changelog`** - This is updated separately using `dch`

## Pull requests

### Opening a PR

1. Ensure your branch is up to date with `dev`:
   ```bash
   git checkout dev
   git pull origin dev
   git checkout your-branch
   git rebase dev
   ```

2. Push your branch and open a PR against the `dev` branch (not `main`)

3. In the PR description, reference any related issues:
   - Use keywords like `closes #42`, `fixes #66`, or `resolves #99`
   - This automatically links the PR to the issue

### PR best practices

- Keep changes focused and reviewable
- Respond to review feedback promptly
- Ensure CI checks pass before requesting review
- Link to related issues

### Merging

Maintainers will likely squash and then merge your PR when approved. This keeps the git history clean while preserving your contribution, but depends on if the maintainer wants the option to cherry-pick certain commits in your content..

## Code Review

All code needs to go through review before merging. This helps:

- Catch bugs early
- Ensure consistency with project standards
- Share knowledge across the team
- Maintain code quality

## Issues

Found a bug? Have a feature idea? Create an issue first:

1. Check if an issue already exists
2. Use clear, descriptive titles
3. Include steps to reproduce for bugs
4. Explain the use case for features

Even if you're already working on a fix, create an issue to document it.

## Security guidelines

### Running as root

Avoid running as root absolutely necessary:

- Use specific user accounts for services (e.g., `wlanpi` user)
- Drop privileges after initialization when possible
- Document why root is required if it must be used

### Systemd hardening

If your application runs as a systemd service, apply security options:

```ini
[Service]
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/log/your-app
```

Learn more:
- [Systemd Analyze](https://www.freedesktop.org/software/systemd/man/systemd-analyze.html)
- [Systemd Service Hardening](https://github.com/alegrey91/systemd-service-hardening)

## Questions?

- Dev [Slack](https://wlanpi.slack.com) (contact a team member for access)
- Open a discussion issue
- Reach out to maintainers

## See Also

- [Getting Started](GETTING_STARTED.md) - Development environment setup
- [Release Process](RELEASE_PROCESS.md) - For core team release procedures
- [Style Guide](style/README.md) - Code style and packaging standards
