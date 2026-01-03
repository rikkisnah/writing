#!/usr/bin/env bash
# saveall - Save writing repo changes and sync repository

set -euo pipefail

remote="${1:-origin}"

echo "Saving writing changes..."

current_branch="$(git branch --show-current)"
if [[ -z "${current_branch}" ]]; then
  echo "Error: cannot sync from a detached HEAD."
  exit 1
fi

git add -A
git commit -m "Session update: $(date '+%Y-%m-%d %H:%M') from $(hostname)" || echo "Nothing to commit"

echo "Fetching latest from ${remote}..."
if ! git fetch --prune "${remote}"; then
  echo "Error: fetch failed (check network/VPN/SSH credentials)."
  exit 1
fi

if git show-ref --verify --quiet "refs/remotes/${remote}/${current_branch}"; then
  git pull --rebase "${remote}" "${current_branch}"
  git push "${remote}" "${current_branch}"
else
  remote_head="$(git symbolic-ref -q --short "refs/remotes/${remote}/HEAD" 2>/dev/null || true)"
  if [[ -n "${remote_head}" && "${remote_head}" != "${remote}/${current_branch}" ]]; then
    echo "Note: ${remote}/${current_branch} does not exist; ${remote} default appears to be ${remote_head}."
    echo "Publishing ${current_branch} to ${remote} (creates a new remote branch)."
  fi
  git push -u "${remote}" "${current_branch}"
fi

echo "✓ Writing repo saved and synced"
