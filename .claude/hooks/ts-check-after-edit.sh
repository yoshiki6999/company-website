#!/bin/bash
# PostToolUse hook: Run TypeScript incremental check after file edits
# Triggered by: Write | Edit tools on .ts/.tsx files

# Only run if the check script exists
if [ -f "script/check-ts-no-new-errors.sh" ]; then
  bash script/check-ts-no-new-errors.sh 2>&1 | tail -5
fi
