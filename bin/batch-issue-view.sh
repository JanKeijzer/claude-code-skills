#!/bin/bash
# Fetch multiple GitHub issues as a JSON array.
# Usage: batch-issue-view.sh <repo> <issue-numbers...>
#
# This script exists because Claude Code permissions match on the first
# word of a command. Inline `for` loops that call `gh issue` get blocked
# because the first word is `for`, not `gh`. Wrapping the loop in a script
# lets permissions match on the script path instead.

set -euo pipefail

if [ $# -lt 2 ]; then
    echo "Usage: batch-issue-view.sh <repo> <issue-numbers...>" >&2
    echo "Example: batch-issue-view.sh owner/repo 15 16 17 18" >&2
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
    gh issue view "$issue" --repo "$REPO" --json number,title,body,state,closed,labels
done
echo "]"
