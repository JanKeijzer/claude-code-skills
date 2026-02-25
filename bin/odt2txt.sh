#!/usr/bin/env bash
# Convert ODT file to plain text using pandoc.
# Usage: odt2txt.sh <input.odt> <output.txt>
# Example: odt2txt.sh ~/Documents/offerte.odt /tmp/offerte.txt
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: odt2txt.sh <input.odt> <output.txt>" >&2
    exit 1
fi

pandoc "$1" -t plain --wrap=none -o "$2"
