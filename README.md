# Developers

A collection of documentation for WLAN Pi developers and contributors.

## Quick Start

**New to WLAN Pi development?** Start here:

1. [Getting Started](GETTING_STARTED.md) - Set up your environment and make your first contribution
2. [Contributing](CONTRIBUTING.md) - Detailed workflow guidelines
3. [Packaging Example](PACKAGING_EXAMPLE.md) - Create your first package

## Documentation

### For Contributors

| Document | Description |
|----------|-------------|
| [Getting Started](GETTING_STARTED.md) | Development environment setup and first contribution guide |
| [Contributing](CONTRIBUTING.md) | Git workflow, branch naming, PR guidelines, and code review |
| [Packaging Example](PACKAGING_EXAMPLE.md) | Complete walkthrough of creating a Debian package from scratch |

### For Core Team

| Document | Description |
|----------|-------------|
| [Release Process](RELEASE_PROCESS.md) | Tagging, versioning, and deployment procedures |

### Architecture

| Document | Description |
|----------|-------------|
| [Filesystem Hierarchy](architecture/FHS.md) | Directory structure standards (`/opt`, `/etc`, `/var`) |
| [Debian Packaging](architecture/PACKAGING.md) | Packaging policy and required files |

### Style Guides

| Document | Description |
|----------|-------------|
| [Contributing Style](style/CONTRIBUTING.md) | Code contribution standards |
| [Python](style/PYTHON.md) | Python coding standards |
| [Packaging Style](style/PACKAGING.md) | Packaging-specific style guide |
| [Anti-patterns](style/ANTIPATTERNS.md) | Common mistakes to avoid |
| [Debchange](style/DCH.md) | Changelog formatting |
| [Developer Workflow](style/WORKFLOW.md) | Development process standards |

### Workflow

| Document | Description |
|----------|-------------|
| [Development Setup](workflow/development-setup.md) | Detailed environment setup |
| [IDE Setup](workflow/ide.md) | IDE configuration |
| [Developing on Windows](workflow/dev-on-windows.md) | Windows/WSL development guide |
| [Update from Dev Branch](workflow/update-from-dev.md) | Testing dev packages |
| [VSC Remote-SSH](workflow/VSC_64bit_kernel_and_32bit_userland.md) | VS Code troubleshooting |

### Licensing

| Document | Description |
|----------|-------------|
| [Licensing](licensing/licensing.md) | Project licensing policy (MIT) |

### Community

| Document | Description |
|----------|-------------|
| [Code of Conduct](https://github.com/WLAN-Pi/.github/blob/main/docs/code_of_conduct.md) | Community standards |

## Install Dependencies

To set up a WLAN Pi device for development (requires `curl` and `sudo`):

```bash
curl -vfSL http://wlanpi.us/install | sudo bash
```

## Feedback

We welcome your feedback. Feel free to [open an issue](../../issues) with suggestions and rationale for any proposed changes.

## Resources

- [WLAN Pi Website](https://wlanpi.com)
- [Packagecloud Archive](https://packagecloud.io/wlanpi/)
- [GitHub Organization](https://github.com/wlan-pi/)
- [WLAN Pi Slack Community](https://wlanpi.slack.com)

## See Also

External resources for learning:

- [GitHub Git Guide](https://docs.github.com/en/get-started/quickstart/git-and-github-learning-resources) - Official GitHub resources
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Practical Git problem solving
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/) - Deep Git internals
- [Debian New Maintainers' Guide](https://www.debian.org/doc/manuals/maint-guide/) - Debian packaging
- [dh-virtualenv Documentation](https://dh-virtualenv.readthedocs.io/) - Python packaging tool
