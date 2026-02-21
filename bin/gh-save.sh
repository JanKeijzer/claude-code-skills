#!/usr/bin/env bash
# Save gh command output to a file.
# Usage: gh-save.sh <output-file> <gh-args...>
# Example: gh-save.sh /tmp/issue-795.json issue view 795 --json title,body,labels
set -euo pipefail

outfile="$1"; shift
gh "$@" > "$outfile"
