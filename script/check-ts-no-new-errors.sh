#!/bin/bash
# TypeScript incremental error checker
# Compares current TS errors against a baseline to prevent regression
# Used by PostToolUse hook after file edits

BASELINE_FILE=".ts-error-baseline"

# Run TypeScript check and count errors
CURRENT_ERRORS=$(npx tsc --noEmit 2>&1 | grep -c "error TS" || true)

if [ ! -f "$BASELINE_FILE" ]; then
  # No baseline exists — create one
  echo "$CURRENT_ERRORS" > "$BASELINE_FILE"
  echo "TS baseline created: $CURRENT_ERRORS errors"
  exit 0
fi

BASELINE_ERRORS=$(cat "$BASELINE_FILE")

if [ "$CURRENT_ERRORS" -gt "$BASELINE_ERRORS" ]; then
  NEW_ERRORS=$((CURRENT_ERRORS - BASELINE_ERRORS))
  echo "TS REGRESSION: +$NEW_ERRORS new errors ($BASELINE_ERRORS → $CURRENT_ERRORS)"
  echo "Fix the new TypeScript errors before continuing."
  # Show the new errors
  npx tsc --noEmit 2>&1 | grep "error TS" | tail -5
  exit 1
elif [ "$CURRENT_ERRORS" -lt "$BASELINE_ERRORS" ]; then
  echo "TS IMPROVED: -$((BASELINE_ERRORS - CURRENT_ERRORS)) errors ($BASELINE_ERRORS → $CURRENT_ERRORS)"
  exit 0
else
  echo "TS OK: $CURRENT_ERRORS errors (unchanged from baseline)"
  exit 0
fi
