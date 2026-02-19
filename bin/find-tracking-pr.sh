#!/bin/bash
# Find the tracking PR for a parent issue.
# Usage: find-tracking-pr.sh <repo> <issue-number>
#
# Searches by branch name first (issue-<number>), then falls back to
# scanning PR bodies for "Closes #<number>". Outputs JSON of the first
# matching open PR, or exits 1 if none found.

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: find-tracking-pr.sh <repo> <issue-number>" >&2
    echo "Example: find-tracking-pr.sh owner/repo 723" >&2
    exit 1
fi

REPO="$1"
ISSUE="$2"

# Try by branch name first
result=$(gh pr list --repo "$REPO" --search "head:issue-$ISSUE" --state open --json number,title,body --limit 1)

if [ "$result" != "[]" ] && [ -n "$result" ]; then
    echo "$result"
    exit 0
fi

# Fallback: search PR bodies for "Closes #<issue>"
result=$(gh pr list --repo "$REPO" --search "Closes #$ISSUE in:body" --state open --json number,title,body --limit 1)

if [ "$result" != "[]" ] && [ -n "$result" ]; then
    echo "$result"
    exit 0
fi

echo "No open tracking PR found for issue #$ISSUE" >&2
exit 1
