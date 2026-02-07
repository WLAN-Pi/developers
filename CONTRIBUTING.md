# Contributing to WLAN Pi

This guide covers how to contribute code to WLAN Pi projects. For setting up your development environment, see [Getting Started](GETTING_STARTED.md).

## Prerequisites

- A GitHub account
- Basic familiarity with git (see [Git Basics](#git-basics) below if needed)
- Access to a WLAN Pi device for testing your changes (technically optional but highly recommended)

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

### PR Checklist

Before submitting your PR:

- [ ] **Keep your PR small** - Easier to review and merge. Your PR should only do one thing.
- [ ] **Use descriptive titles** - Start with `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, or `chore:`. Follow with a summary in present tense.
  - Example: `fix: address profiler crash on Rx of certain (re)assoc frames`
- [ ] **Test your changes** - Describe how to test and validate your contribution
- [ ] **Update documentation** - Include any necessary documentation updates (README, man pages, usage guides)

### Breaking changes

If you're adding breaking changes, document them in your PR description:

```
1. Who is affected
2. What needs migrated
3. Why this breaking change
4. Severity
```

### Increasing acceptance likelihood

To increase the likelihood of your PR being accepted:

- Follow standards for style and code quality (see [Style Guide](style/README.md))
- Include documentation updates
- Write tests
- Keep your change as focused as possible
- Write [good commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- Reference the issue your PR closes (e.g., "closes #42")

### Merging

Maintainers will likely squash and then merge your PR when approved. This keeps the git history clean while preserving your contribution.

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

### Good Bug Reports

When filing bug reports, please include:

**1. How to reproduce the issue**
- Provide a small code sample that can be run immediately
- Or describe what you're doing, how often it happens, your environment, etc.

**2. What you expected to happen**
- What does "success" look like for your code?

**3. What actually happens**
- Don't just say "it doesn't work" or "it fails"
- Describe the failure: exception message, how actual result differs from expected

**4. Version and installation info**
- What version you're using
- How you installed it

**5. Location in code (if known)**
- This helps other developers resolve the bug faster

If you don't provide this information, resolution will take longer. If we ask for clarification and you don't respond, we may close the issue without fixing it.

### Issue Templates

When opening a new issue, always fill out the issue template. Not doing so may result in your issue not being managed in a timely fashion.

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
