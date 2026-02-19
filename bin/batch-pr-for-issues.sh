#!/bin/bash
# Find merged and open PRs linked to multiple issues, as a JSON array.
# Usage: batch-pr-for-issues.sh <repo> <issue-numbers...>
#
# For each issue, searches for PRs with "closes #<issue>" in both merged
# and open state. Outputs a JSON array of objects with issue number,
# merged PRs, and open PRs.

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: batch-pr-for-issues.sh <repo> <issue-numbers...>" >&2
    echo "Example: batch-pr-for-issues.sh owner/repo 15 16 17 18" >&2
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
    merged=$(gh pr list --repo "$REPO" --search "closes #$issue" --state merged --json number,title 2>/dev/null || echo "[]")
    open=$(gh pr list --repo "$REPO" --search "closes #$issue" --state open --json number,title,isDraft 2>/dev/null || echo "[]")
    echo "{\"issue\":$issue,\"merged\":$merged,\"open\":$open}"
done
echo "]"
