#!/usr/bin/env bash
# Copy CLAUDE.md files to a temp dir for sub-agent consumption during epic
# implementation.
#
# Usage:
#   epic-prepare-context.sh <epic-number> [project-dir]
#
# Creates namespaced copies to avoid collisions when running multiple epics
# or across different projects:
#   /tmp/epic-<project>-<number>-claude-root.md
#   /tmp/epic-<project>-<number>-claude-frontend.md
#   /tmp/epic-<project>-<number>-claude-backend.md
#
# Outputs the prefix to stdout, and the list of copied sections to stderr.
# Only mention a section in a sub-agent prompt if it was reported as copied:
# a MISSING context file is harmless (the sub-agent reads the repo's CLAUDE.md
# itself), but pointing an agent at a path holding ANOTHER project's doc makes
# it treat foreign architecture as this project's. That is why each destination
# is unlinked before the copy — a section that no longer exists in the project
# must not resolve to an earlier run's file.
#
# Source paths differ per project (backend/CLAUDE.md vs backend/app/CLAUDE.md),
# so each section tries several candidates and takes the first that exists.

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: epic-prepare-context.sh <epic-number> [project-dir]" >&2
  exit 1
fi

EPIC_NUMBER="$1"
PROJECT_DIR="${2:-$PWD}"

# Derive project name from directory basename (lowercase, non-alphanumerics
# folded to '-') so the destination can never collide across projects.
PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]' '-')
PROJECT_NAME="${PROJECT_NAME%-}"
PREFIX="${TMPDIR:-/tmp}/epic-${PROJECT_NAME}-${EPIC_NUMBER}-claude"

# section:candidate[,candidate...] — first existing candidate wins.
SECTIONS=(
  "root:CLAUDE.md"
  "frontend:frontend/CLAUDE.md,src/CLAUDE.md"
  "backend:backend/CLAUDE.md,backend/app/CLAUDE.md"
)

copied=()
for entry in "${SECTIONS[@]}"; do
  section="${entry%%:*}"
  dest="${PREFIX}-${section}.md"

  # Drop any file left by an earlier run before deciding what to copy, so a
  # section the project no longer has cannot resolve to stale content.
  rm -f "$dest"

  IFS=',' read -ra candidates <<< "${entry#*:}"
  for candidate in "${candidates[@]}"; do
    if [[ -f "$PROJECT_DIR/$candidate" ]]; then
      cp "$PROJECT_DIR/$candidate" "$dest"
      copied+=("${section} (${candidate})")
      break
    fi
  done
done

if [[ ${#copied[@]} -eq 0 ]]; then
  echo "⚠️  No CLAUDE.md files found in $PROJECT_DIR" >&2
  exit 1
fi

echo "Context prepared from $PROJECT_DIR:" >&2
printf '  %s\n' "${copied[@]}" >&2

echo "$PREFIX"
