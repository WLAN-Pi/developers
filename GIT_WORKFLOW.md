# Git Workflow Guide for WLAN Pi

This guide covers the Git fundamentals and basic workflow patterns used in WLAN Pi development. If you're already familiar with Git, see [Contributing](CONTRIBUTING.md) for project-specific conventions. This is not meant to be exhaustive, but just a quick primer.

## What is Git?

Git is a version control system that tracks changes to files and coordinates work among multiple people. Git allows you to:

- Track changes to your code over time
- Collaborate with other developers
- Experiment safely with new features in isolation
- Revert to previous versions when needed

## Essential Git concepts

### Repository (repo)

A Git repository is a folder that Git tracks. It contains:
- **Working directory**: Your actual files
- **Staging area (index)**: Changes you've marked to commit
- **History**: All previous versions of your files

### Branch

A branch is an independent line of development. The default branch is typically called `main` or `master`. Our default branch is `main`. Some WLAN Pi repositories have two permanent branches `main` and `dev`.

WLAN Pi uses:
- `main`: Stable, production-ready code
- `dev`: Integration branch for upcoming releases
- Feature branches: For specific changes

### Commit

A commit is a snapshot of your changes with:
- A unique ID (hash)
- A message describing what changed
- The author and timestamp

## Essential Git commands

### Getting started

```bash
# Clone a repository (download it to your computer)
git clone https://github.com/<ORG>/REPO_NAME.git
cd REPO_NAME

# Check the status of your repository
git status

# Configure your identity (do this once per machine)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Basic workflow

```bash
# See what files have changed
git status

# Add a file to the staging area
git add filename.py

# Commit your changes with a message
git commit -m "Add feature or fix X"

# Push your changes to the remote repository
git push origin main
```

### Branching and merging

```bash
# See all branches
git branch -a

# Create and switch to a new branch
git checkout -b feature/my-new-feature

# Switch to an existing branch
git checkout dev

# See what branch you're on
git branch

# Update your local branch with remote changes
git pull origin dev

# Merge another branch into your current branch
git merge feature/my-new-feature
```

### Understanding your Git history

```bash
# See commit history
git log

# See history in a compact format
git log --oneline --graph

# See what changed in a specific commit
git show COMMIT_HASH

# See what files changed in the last commit
git diff HEAD~1
```

## Basic conflict resolution

Conflicts happen when the same part of a file was modified in both branches.

```bash
# When a merge conflict occurs, Git marks the conflicts in the file:
# <<<<<<< HEAD
# Your changes
# =======
# Their changes
# >>>>>>> branch-name

# Edit the file to resolve the conflict, then:
git add filename.py
git commit -m "Resolve merge conflict"
```

## Essential workflow pattern

The basic development workflow:

1. **Start from the right branch**:
   ```bash
   git checkout dev
   git pull origin dev
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/descriptive-name
   ```

3. **Make changes and commit**:
   ```bash
   # Edit files...
   git add .
   git commit -m "Add: description of change"
   ```

4. **Keep your branch updated**:
   ```bash
   git checkout dev
   git pull origin dev
   git checkout feature/descriptive-name
   git merge dev
   ```

5. **Push and create a Pull Request (PR)**:
   ```bash
   git push origin feature/descriptive-name
   # Then open a PR on GitHub
   ```

## Common mistakes to avoid

- **Don't commit to main or dev directly** - Always use feature branches
- **Don't push to remote and then rebase** - Only rebase local, unpushed changes
- **Don't use `git add .` without checking** - Review what you're staging first with `git status`
- **Don't write vague commit messages** - "Fixes" or "Updates" is not descriptive enough for PRs

## Learning More

- [GitHub Git Guide](https://docs.github.com/en/get-started/quickstart/git-and-github-learning-resources) - Official GitHub resources
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Practical solutions to common Git problems
- [Git from the Bottom Up](https://jwiegley.github.io/git-from-the-bottom-up/) - Deep technical understanding

## Next Steps

Once you're comfortable with these basics, check out our [Contributing Guide](CONTRIBUTING.md) for WLAN Pi-specific workflow, branch naming conventions, and PR guidelines.
