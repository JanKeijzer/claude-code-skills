#!/bin/bash
# Fetch number, state, and closed status for multiple GitHub issues as a JSON array.
# Usage: batch-issue-status.sh <repo> <issue-numbers...>
#
# Lightweight variant of batch-issue-view.sh that only fetches status fields.
# See batch-issue-view.sh for the permissions rationale.

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: batch-issue-status.sh <repo> <issue-numbers...>" >&2
    echo "Example: batch-issue-status.sh owner/repo 15 16 17 18" >&2
    exit 1
fi

REPO="$1"
shift

echo "["
first=true
for issue in "$@"; do
    if [ "$first" = true ]; then
        first=false
    else
        echo ","
    fi
    gh issue view "$issue" --repo "$REPO" --json number,title,state,closed
done
echo "]"
