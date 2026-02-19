#!/bin/bash
# Extract the issue number from the current git branch name.
# Usage: extract-issue-from-branch.sh
#
# Expects branch names like "issue-123-description". Outputs just the
# number (e.g. "123"), or exits 1 if the branch doesn't match.

set -euo pipefail

BRANCH=$(git branch --show-current)

if [[ "$BRANCH" =~ ^issue-([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
else
    echo "Cannot extract issue number from branch '$BRANCH'" >&2
    exit 1
fi
