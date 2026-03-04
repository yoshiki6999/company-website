#!/bin/bash
# PostToolUse hook: Track consecutive failures for circuit breaker (§4)
# Triggered by: Bash tool failures

COUNTER_FILE="/tmp/.claude-failure-counter-$$"

# Get exit status from the tool result
EXIT_STATUS="${CLAUDE_TOOL_EXIT_STATUS:-0}"

if [ "$EXIT_STATUS" != "0" ]; then
  # Increment counter
  COUNT=0
  if [ -f "$COUNTER_FILE" ]; then
    COUNT=$(cat "$COUNTER_FILE")
  fi
  COUNT=$((COUNT + 1))
  echo "$COUNT" > "$COUNTER_FILE"

  if [ "$COUNT" -ge 8 ]; then
    echo "CIRCUIT BREAKER: 8 consecutive failures reached (CLAUDE.md §4)."
    echo "Stop and generate a FAILURE-REPORT. Escalate to human."
    echo "Reset counter with: rm $COUNTER_FILE"
  elif [ "$COUNT" -ge 3 ]; then
    echo "WARNING: $COUNT consecutive failures. Per §4: add detailed logging + consider switching approach."
  fi
else
  # Reset counter on success
  rm -f "$COUNTER_FILE" 2>/dev/null
fi

exit 0
