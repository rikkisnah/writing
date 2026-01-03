#!/bin/bash
# saveall - Save writing repo changes and sync repository

set -euo pipefail

echo "Saving writing changes..."
git add -A
git commit -m "Session update: $(date '+%Y-%m-%d %H:%M') from $(hostname)" || echo "Nothing to commit"
git pull --rebase
git push

echo "✓ Writing repo saved and synced"
