#!/bin/bash
# PreToolUse hook: Block dangerous database operations
# Triggered by: Bash tool — intercepts DROP, TRUNCATE, DELETE without WHERE

# Read the command from the tool input (passed via $CLAUDE_TOOL_INPUT)
INPUT="$CLAUDE_TOOL_INPUT"

# Check for dangerous patterns (case-insensitive)
if echo "$INPUT" | grep -iE '(DROP\s+(TABLE|DATABASE|INDEX|SCHEMA))|(TRUNCATE\s+TABLE?)|(DELETE\s+FROM\s+\w+\s*;)|(DELETE\s+FROM\s+\w+\s*$)' > /dev/null 2>&1; then
  echo "BLOCKED: Dangerous database operation detected."
  echo "Operations like DROP, TRUNCATE, and DELETE without WHERE clause require human approval."
  echo "If this is intentional, ask the user for explicit permission first."
  exit 2
fi

exit 0
