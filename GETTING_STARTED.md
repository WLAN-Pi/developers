# Getting Started with WLAN Pi Development

Welcome! This guide will help you set up your development environment and make your first contribution to WLAN Pi.

## What is WLAN Pi?

WLAN Pi is a specialized platform for Wi-Fi professionals. It combines custom hardware with a Debian-based OS and Python applications to provide tools for:

- Wi-Fi analysis and troubleshooting
- Packet capture
- Network diagnostics
- Performance testing

This repository contains the documentation for developers who want to contribute to WLAN Pi projects.

## Quick start 

### 1. Install dependencies

```bash
curl -fSL https://raw.githubusercontent.com/WLAN-Pi/developers/main/install.sh | sudo bash
curl -fSL http://wlanpi.us/install | sudo bash
```

That URL is `install.sh` in this repository, fetched over HTTPS.
`http://wlanpi.us/install` is a short alias: a GET redirects to the same
script. The first hop is plain HTTP, because Hover's forwarder is HTTP-only.
The one-liner can move to `https://wlanpi.us/install` once that domain
serves HTTPS, for example with Cloudflare redirect rules or GitHub Pages.

### 2. Set up git

```bash
# Configure your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Enable rebase by default for cleaner history
git config --global pull.rebase true
```

### 3. Fork and clone

Note: You will need to setup SSH keys.

1. Go to the repository you want to contribute to on GitHub
2. Click the "Fork" button
3. Clone your fork and add the upstream remote:
   ```bash
   git clone https://github.com/USERNAME/REPO_NAME.git
   cd REPO_NAME
   git remote add upstream https://github.com/WLAN-Pi/REPO_NAME.git
   ```

### 4. Create a branch

Create your branch from `main`. The exception is `wlanpi-kernel`, which keeps
one branch per kernel version; see [Repository Reference](REPOS.md).

```bash
# Sync your fork from upstream
git checkout main
git pull upstream main

# Create your feature branch from there
git checkout -b feature/<my-first-contribution>
```

You should replace `<my-first-contribution>` with something concise and descriptive.

### 5. Make changes and commit

```bash
# Edit files...

# Stage and commit
git add .
git commit -m "Fix: description of your change"
```

### 6. Push and create PR

```bash
git push origin <my-first-contribution>
```

Then open a Pull Request (PR) on GitHub against the target branch.

## Development environment options

### Option 1: Physical WLAN Pi device

Best for: Testing hardware-specific features, Wi-Fi operations

Requirements:

- WLAN Pi hardware
- Network access to the device

Setup:

1. Connect to your WLAN Pi via SSH
2. Follow the Quick Start above
3. Edit files directly on the device or use Remote-SSH in VS Code

### Option 2: Virtual Machine / Container

Best for: Application development, testing without hardware

You can develop on any Linux system with:

- Python 3.13+
- Git
- Standard build tools (`build-essential`, `debhelper`)

### Option 3: Windows with WSL

See [Developing on Windows](workflow/dev-on-windows.md) for detailed instructions.

## Project structure

WLAN Pi consists of multiple repositories such as (but not limited to):

| Repository | Purpose |
|------------|---------|
| `wlanpi-common` | Core utilities and shared code |
| `wlanpi-profiler` | Wi-Fi client profiler tool |
| `wlanpi-fpms` | Front panel menu system driving the OLED display |
| `wlanpi-misc-firmware` | Miscellaneous firmware packages (e.g. MediaTek) |
| `pi-gen` | OS image generation |

Most application repositories aim for this structure:

```
REPO_NAME/
├── debian/              # Debian packaging files
│   ├── control          # Package metadata and dependencies
│   ├── changelog        # Version history (managed via dch)
│   ├── copyright        # DEP-5 copyright
│   ├── rules            # Build instructions
│   ├── source/format    # 3.0 (native) for first-party packages
│   └── ...
├── wlanpi_yourapp/      # Python package source
├── tests/               # Test files
├── pyproject.toml       # Project metadata and tool config
├── requirements.in      # Direct dependencies (managed via pip-tools)
├── requirements.txt     # Pinned runtime dependencies (generated, do not edit by hand)
├── tox.ini              # Tox environments for lint, format, test
├── README.md            # Project documentation
└── LICENSE              # BSD-3-Clause License
```

This is the target, not a guarantee. Some older repos still use `setup.py`
instead of `pyproject.toml`, or omit `requirements.in`/`tox.ini`.

`requirements.txt` is the runtime set that `dh_virtualenv` installs into the
`.deb`. Test tools stay in a `pyproject.toml` extra. See
[Debian Packaging](architecture/PACKAGING.md#runtime-and-test-dependencies).

## Your first contribution

Not sure where to start? Look for issues labeled:

- `good first issue` - Beginner-friendly tasks
- `help wanted` - Community contributions welcome
- `documentation` - Documentation improvements

### Example first contribution

1. Find a typo or documentation improvement
2. Fork the repository
3. Create a branch: `fix-typo-readme`
4. Fix the typo
5. Commit with a clear message: `Fix typo in README`
6. Push and create PR

## Next steps

- Read [Contributing](CONTRIBUTING.md) for detailed workflow guidelines
- Check out [Packaging Example](PACKAGING_EXAMPLE.md) if you want to create a new package
- Join our dev [Slack community](https://wlanpi.slack.com) (contact a team member for access)
- Explore the [Architecture](architecture/README.md) documentation

## Common tasks

### Update from Main

```bash
# Add the upstream remote (one time)
git remote add upstream https://github.com/WLAN-Pi/REPO_NAME.git

# Update your local main branch
git checkout main
git pull upstream main

# Merge main into your feature branch to stay current
git checkout your-branch
git merge main --no-ff -m "Merge main to stay current"
```

### Install a development package

To test your changes on a WLAN Pi:

```bash
# Build the package
dpkg-buildpackage -us -uc -b

# Install it
sudo dpkg -i ../wlanpi-package_*.deb
```

### View package logs

```bash
sudo journalctl -u wlanpi-service -f
```

## Getting help

- **WLAN Pros Slack**: [wi-fipros.slack.com](https://wi-fipros.slack.com)
- **Dev Slack**: [wlanpi.slack.com](https://wlanpi.slack.com) 
- **GitHub issues**: Open an issue in the relevant repository
- **Core member**: Contact a team member listed on [GitHub](https://github.com/orgs/WLAN-Pi/people)

## Documentation index

| Document | Purpose |
|----------|---------|
| [Contributing](CONTRIBUTING.md) | How to contribute code |
| [Repository Reference](REPOS.md) | What each repo should be: role, package, and the build standard |
| [Release Process](RELEASE_PROCESS.md) | Core team release procedures |
| [Packaging Example](PACKAGING_EXAMPLE.md) | Complete packaging tutorial |
| [Architecture](architecture/README.md) | System design and standards |
| [Style Guide](style/README.md) | Code and packaging style |
| [Workflow](workflow/README.md) | Development environment guides |
