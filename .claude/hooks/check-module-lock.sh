#!/bin/bash
# check-module-lock.sh — PreToolUse hook for Write/Edit operations
# Enforces file ownership rules from docs/MODULE-LOCK.md
#
# Exit codes:
#   0 = allow operation
#   2 = block operation
#
# Environment:
#   $CLAUDE_FILE_PATH = path to file being modified (set by Claude Code hook protocol)

set -e

# Get file path from hook protocol
FILE_PATH="${CLAUDE_FILE_PATH}"

# If FILE_PATH not set, this hook was called incorrectly
if [[ -z "$FILE_PATH" ]]; then
    exit 0  # Allow if we can't determine file (should not happen in normal use)
fi

# Normalize file path (remove leading ./)
FILE_PATH="${FILE_PATH#./}"

# Helper function to extract agent from git branch
get_current_agent() {
    local branch
    branch=$(git branch --show-current 2>/dev/null || echo "")

    # Extract prefix: claude/, cursor/, codex/, or other patterns
    if [[ "$branch" =~ ^(claude|cursor|codex) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "unknown"
    fi
}

# Helper function to check if file is in protected list
is_protected_file() {
    local file="$1"
    local module_lock="docs/MODULE-LOCK.md"

    if [[ ! -f "$module_lock" ]]; then
        return 1  # File not found, so nothing is protected
    fi

    # Extract Protected Files table (between "## Protected Files" and next "##")
    local protected_section
    protected_section=$(awk '/^## Protected Files/,/^## [^P]|^$/' "$module_lock" | grep "^|" | grep -v "^| File |")

    # Check if file appears in protected list
    if echo "$protected_section" | grep -q "| $file |" || echo "$protected_section" | grep -q "| $file\s"; then
        return 0
    fi

    return 1
}

# Helper function to check if file is shared
is_shared_file() {
    local file="$1"
    local module_lock="docs/MODULE-LOCK.md"

    if [[ ! -f "$module_lock" ]]; then
        return 1
    fi

    # Extract Shared Files table (between "## Shared Files" and next "##")
    local shared_section
    shared_section=$(awk '/^## Shared Files/,/^## [^S]|^$/' "$module_lock" | grep "^|" | grep -v "^| File |")

    # Check if file appears in shared list
    if echo "$shared_section" | grep -q "| $file |" || echo "$shared_section" | grep -q "| $file\s"; then
        return 0
    fi

    return 1
}

# Helper function to find which agent owns an exclusive file
get_exclusive_owner() {
    local file="$1"
    local module_lock="docs/MODULE-LOCK.md"

    if [[ ! -f "$module_lock" ]]; then
        echo ""
        return
    fi

    # Extract Current Assignment table and look for the file
    local assignment_section
    assignment_section=$(awk '/^## Current Assignment/,/^## [^C]|^$/' "$module_lock" | grep "^|" | grep -v "^| Module |")

    # Search for file in exclusive files column (last column)
    # Uses awk instead of grep -oP for macOS compatibility
    local owner
    owner=$(echo "$assignment_section" | grep "$file" | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $3); print $3}' | head -1)

    echo "$owner"
}

# ============================================================================
# Main Logic
# ============================================================================

MODULE_LOCK="docs/MODULE-LOCK.md"

# If MODULE-LOCK.md doesn't exist or has no assignments, allow everything
if [[ ! -f "$MODULE_LOCK" ]]; then
    exit 0
fi

# Check if MODULE-LOCK has any actual assignments (not template placeholders)
# Use grep without -q so output flows to second grep; if no real assignments, allow all
if ! grep '^\| [^<]' "$MODULE_LOCK" 2>/dev/null | grep -q -v "^|.*<!--"; then
    # Only template placeholders, allow everything
    exit 0
fi

CURRENT_AGENT=$(get_current_agent)

# Check 1: Is this a protected file?
if is_protected_file "$FILE_PATH"; then
    echo "BLOCKED: $FILE_PATH is protected. Requires human approval." >&2
    exit 2
fi

# Check 2: Is this a shared file?
if is_shared_file "$FILE_PATH"; then
    echo "WARNING: $FILE_PATH is shared. Append only — do NOT modify existing content." >&2
    exit 0
fi

# Check 3: Is this exclusively owned by another agent?
OWNER=$(get_exclusive_owner "$FILE_PATH")
if [[ -n "$OWNER" && "$OWNER" != "$CURRENT_AGENT" ]]; then
    echo "BLOCKED: $FILE_PATH is exclusively owned by $OWNER. You cannot modify it." >&2
    exit 2
fi

# Default: allow the operation
exit 0
