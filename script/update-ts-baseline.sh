#!/bin/bash
# Update TypeScript error baseline
# Run this after intentionally accepting existing TS errors
# (e.g., after a major upgrade or dependency change)

BASELINE_FILE=".ts-error-baseline"

CURRENT_ERRORS=$(npx tsc --noEmit 2>&1 | grep -c "error TS" || true)

echo "$CURRENT_ERRORS" > "$BASELINE_FILE"
echo "TS baseline updated: $CURRENT_ERRORS errors"

if [ "$CURRENT_ERRORS" -gt 0 ]; then
  echo ""
  echo "Current errors:"
  npx tsc --noEmit 2>&1 | grep "error TS" | head -10
  if [ "$CURRENT_ERRORS" -gt 10 ]; then
    echo "... and $((CURRENT_ERRORS - 10)) more"
  fi
fi
