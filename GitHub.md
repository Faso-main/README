# GitHub Command Line (CMD) Cheat Sheet

This guide covers essential Git commands for managing repositories via the command line (CMD).

## Setup & Configuration

```bash
# Set your username (global)
git config --global user.name "Your Name"

# Set your email (global)
git config --global user.email "your.email@example.com"

# Check your configuration
git config --list

# Clone a remote repository
git clone -b main https://github.com/username/repository.git

# Initialize a new local repository
git init

# Link local repo to a remote GitHub repository
git remote rm origin
git remote add origin https://github.com/username/repository.git

# Check remote connections
git remote -v

# Check repository status
git status

# Stage all changed files
git add .

# Stage a specific file
git add filename.ext

# Reset last commit 
git reset HEAD~   

# Commit changes with a message
git commit -m "Your commit message"

# Push changes to remote (main branch)
git push origin main

# Pull latest changes from remote
git pull origin main

# List all branches
git branch

# Create a new branch
git branch new-branch-name

# Switch to a branch
git checkout branch-name

# Create and switch to a new branch
git checkout -b new-branch-name

# Delete a branch (local)
git branch -d branch-name

# Push a branch to remote
git push origin branch-name


# Merge a branch into current branch
git merge branch-name

# Fetch changes from remote without merging
git fetch

# Rebase current branch onto another
git rebase branch-name

# Undo unstaged changes in a file
git checkout -- filename.ext

# Unstage a file (keep changes)
git reset HEAD filename.ext

# Amend the last commit
git commit --amend -m "New commit message"

# Revert a commit (creates new undo commit)
git revert commit-hash

# View commit history
git log

# View changes between commits/branches
git diff

# Stash changes temporarily
git stash

# Apply stashed changes
git stash pop

# Force push (use with caution!)
git push --force origin branch-name

# Check Git version
git --version

# Get help for any command
git help command