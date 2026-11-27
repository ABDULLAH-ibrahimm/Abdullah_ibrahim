#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# CDS 2413 - CLO4 Data Versioning: Git / GitHub workflow (runs inside Docker)
#
# Usage (inside the container):
#   bash scripts/git_workflow.sh configure   # 1. configure Git with GitHub identity
#   bash scripts/git_workflow.sh upload      # 2. upload project files to GitHub
#   bash scripts/git_workflow.sh clone       # 3. clone the GitHub repo
#   bash scripts/git_workflow.sh pull        # 4. pull changes made on GitHub
#   bash scripts/git_workflow.sh push        # 5. modify the pulled file & push
#
# Settings (override with environment variables):
#   REPO_URL, BRANCH, GIT_USER_NAME, GIT_USER_EMAIL, PULL_FILE
# -----------------------------------------------------------------------------
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/ABDULLAH-ibrahimm/Abdullah_ibrahim.git}"
BRANCH="${BRANCH:-main}"
GIT_USER_NAME="${GIT_USER_NAME:-Abdullah Ibrahim}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-student@example.com}"
PULL_FILE="${PULL_FILE:-docs/CHANGELOG.md}"
PROJECT_DIR="/workspace/project"
CLONE_DIR="/workspace/clone"

export GIT_PAGER=cat

# Print a shell-like prompt + command, then execute it
run() {
  printf '\033[1;32mstudent@cds2413\033[0m:\033[1;34m%s\033[0m$ \033[1m%s\033[0m\n' "${PWD/#$HOME/~}" "$*"
  eval "$@"
}
banner() { printf '\033[1;36m# ===== %s =====\033[0m\n' "$*"; }

step_configure() {
  banner "Configuration: configure Git with GitHub"
  run git --version
  run "git config --global user.name  \"$GIT_USER_NAME\""
  run "git config --global user.email \"$GIT_USER_EMAIL\""
  run git config --global init.defaultBranch main
  run git config --global pull.rebase false
  run git config --global color.ui always
  run git config --global --list
  run git ls-remote --heads "$REPO_URL"
}

step_upload() {
  banner "Uploading: upload CLO1-CLO3 project files to GitHub"
  cd "$PROJECT_DIR"
  run git init -q
  run git remote add origin "$REPO_URL"
  run git fetch -q origin main
  run git reset -q origin/main          # attach to the existing GitHub history
  run git checkout -q -b "$BRANCH"
  run git add .
  run git status --short
  run "git commit -q -m 'Add CDS2413 data science project files (CLO1-CLO3) + Docker setup'"
  run git push -u origin "$BRANCH"
}

step_clone() {
  banner "Cloning: clone the GitHub repo to local Git"
  cd /workspace
  run rm -rf "$CLONE_DIR"
  run git clone --branch "$BRANCH" "$REPO_URL" "$CLONE_DIR"
  cd "$CLONE_DIR"
  run git remote -v
  run git log --oneline -5
  run ls
}

step_pull() {
  banner "Pull: pull a file that was added on GitHub"
  cd "$CLONE_DIR"
  run "ls $PULL_FILE 2>&1 || true"
  run git pull origin "$BRANCH"
  run git log --oneline -3
  run cat "$PULL_FILE"
}

step_push() {
  banner "Push: modify the pulled file and push it to GitHub"
  cd "$CLONE_DIR"
  run "cat >> $PULL_FILE <<'EOF'

## v1.2 - Modified locally inside the Docker container
- Updated this file after pulling it from GitHub (CLO4 - Push).
- Verified the pipeline runs: \`docker compose run --rm pipeline\`.
EOF"
  run git status --short
  run git diff --stat
  run git add "$PULL_FILE"
  run "git commit -q -m 'Update CHANGELOG after pull (CLO4 push demo)'"
  run git push origin "$BRANCH"
  run git log --oneline -4
  run git status -sb
}

case "${1:-}" in
  configure) step_configure ;;
  upload)    step_upload ;;
  clone)     step_clone ;;
  pull)      step_pull ;;
  push)      step_push ;;
  *) echo "usage: $0 {configure|upload|clone|pull|push}"; exit 1 ;;
esac
