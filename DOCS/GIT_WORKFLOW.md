# Git workflow to overwrite your fork while keeping link to upstream

This repo now includes:
- Dockerization in [Dockerfile](Dockerfile:1) and backup [Dockerfile-bak](Dockerfile-bak:1)
- Updated ignores in [.gitignore](.gitignore:1) and backup [.gitignore-bak](.gitignore-bak:1)
- Run instructions in [DOCS/RUN_DOCKER.md](DOCS/RUN_DOCKER.md:1)
- Angular output path confirmed in [angular.json](angular.json:1)
- Nginx config at [nginx.conf](nginx.conf:1)

Goal:
- Keep remote named upstream pointing to the original repository
- Point remote named origin to your fork https://github.com/socramreysa/tiledesk-dashboard
- Force push your current local work to overwrite your fork

## 0) Inspect current remotes and branch

```bash
git status
git remote -v
git rev-parse --abbrev-ref HEAD
```

If you are not on your desired branch, switch or create it:
```bash
# Create new branch from current state (optional)
git checkout -b dockerize-dashboard
```

## 1) Keep original repo as upstream, set your fork as origin

If origin currently points to the original repo, rename it to upstream:
```bash
git remote rename origin upstream
```

Add your fork as the new origin (SSH):
```bash
git remote add origin git@github.com:socramreysa/tiledesk-dashboard.git
```

Or using HTTPS:
```bash
git remote add origin https://github.com/socramreysa/tiledesk-dashboard.git
```

If upstream is not set yet, add it now (replace with the original URL if unknown, you can copy it from your existing remote -v output):
```bash
# Example (adjust if different)
git remote add upstream https://github.com/Tiledesk/tiledesk-dashboard.git
```

Verify:
```bash
git remote -v
# origin   git@github.com:socramreysa/tiledesk-dashboard.git (fetch)
# origin   git@github.com:socramreysa/tiledesk-dashboard.git (push)
# upstream https://github.com/Tiledesk/tiledesk-dashboard.git (fetch)
# upstream https://github.com/Tiledesk/tiledesk-dashboard.git (push)
```

## 2) Stage and commit your local changes

```bash
git add -A
git commit -m "Dockerize dashboard: multi-stage Dockerfile with node:18-alpine + nginx, .gitignore env rules, docs"
```

If you already committed earlier, you can skip this commit step.

## 3) Force-push to overwrite your fork

This will push your current branch to your fork and set upstream tracking. It overwrites the branch on your fork.

```bash
# Push the current branch
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git push -u origin "$BRANCH" --force
```

If your fork&rsquo;s default branch is main or master and you want to overwrite that explicitly:

```bash
# Overwrite main on your fork with your current branch state
git push -u origin HEAD:main --force
# or
git push -u origin HEAD:master --force
```

## 4) Staying in sync with upstream later

To pull future changes from the original repository while keeping your fork:

```bash
# Fetch upstream updates
git fetch upstream

# Rebase your current branch on top of upstream/main (or upstream/master)
git rebase upstream/main
# or
git rebase upstream/master

# Resolve any conflicts, then update your fork
git push origin HEAD --force-with-lease
```

## 5) One-shot script (copy/paste)

This sequence is safe if your current origin points to the original and you want to keep it as upstream, then point origin to your fork, commit, and push force:

```bash
# Rename origin to upstream if it points to the original
git remote -v | grep -q "origin.*github.com.*/tiledesk-dashboard" && git remote rename origin upstream || true

# Ensure origin points to your fork
git remote get-url origin >/dev/null 2>&1 || git remote add origin git@github.com:socramreysa/tiledesk-dashboard.git

# Optional: ensure upstream exists (use your real upstream URL if different)
git remote get-url upstream >/dev/null 2>&1 || git remote add upstream https://github.com/Tiledesk/tiledesk-dashboard.git

# Commit local changes (if any)
git add -A
git commit -m "Dockerize dashboard: multi-stage Dockerfile with node:18-alpine + nginx, .gitignore env rules, docs" || true

# Determine current branch and push force
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git push -u origin "$BRANCH" --force
```

## Notes about sensitive files and backups

- Sensitive env files are ignored by [.gitignore](.gitignore:1) using:
  - `.env`, `.env.*` (but keeps [.env.sample](.env.sample:1) tracked)
- You requested backups for edited files:
  - [Dockerfile-bak](Dockerfile-bak:1) mirrors original [Dockerfile](Dockerfile:1)
  - [.gitignore-bak](.gitignore-bak:1) mirrors original [.gitignore](.gitignore:1)

## What changed technically

- Multi-stage Dockerfile with Node 18 for build, Nginx for static serve. See [Dockerfile](Dockerfile:1)
- SPA-friendly Nginx config at [nginx.conf](nginx.conf:1)
- Build output path is [dist] via [angular.json](angular.json:1)
- Build/run usage in [DOCS/RUN_DOCKER.md](DOCS/RUN_DOCKER.md:1)