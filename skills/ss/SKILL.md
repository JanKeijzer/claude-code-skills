---
name: ss
description: Find Recent Screenshots
argument-hint: [number]
user-invocable: true
---

# Find Recent Screenshots

Find and display the last N screenshots from ~/Pictures/Screenshots directory.

## Input

The user provides: `$ARGUMENTS`

- If a number is provided, show that many screenshots
- If empty, default to 5 screenshots

## Usage

```bash
/ss        # Show last 5 screenshots
/ss 10     # Show last 10 screenshots
```

## Implementation

Use the Glob tool to find screenshots:
```
pattern: "*.*"
path: "~/Pictures/Screenshots"
```

Glob returns files sorted by modification time (newest first). Take the first `[n]` results, where `[n]` is the number from `$ARGUMENTS` or 5 if not provided.

## Output

Show for each file:
- File path
- Date modified

**IMPORTANT:** Only search ~/Pictures/Screenshots - do not search other directories like Desktop, Downloads, or Pictures root.
