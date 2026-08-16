#!/usr/bin/env bash
#
# Custom update script invoked by .github/workflows/daily-update.yml
#
# Contract with the workflow:
#   - Exit 0 on success, non-zero to fail the run.
#   - Just modify files in the working tree; the workflow handles
#     git add/commit/push/PR/merge.
#   - Producing no changes is a valid outcome (the workflow will no-op).
#
set -euo pipefail

# ---- Replace the body below with your real update logic ------------------
# Examples:
#   npm update --save && npm audit fix
#   pip-compile --upgrade requirements.in
#   curl -sSfL https://api.example.com/data.json -o data/data.json

TARGET="data/last-update.txt"
mkdir -p "$(dirname "$TARGET")"
date -u +'%Y-%m-%dT%H:%M:%SZ' > "$TARGET"
echo "Wrote $TARGET"
# --------------------------------------------------------------------------
 
