#!/bin/bash
# Safe development server startup
# Checks environment and prevents common mistakes before starting

set -e

echo "Pre-flight checks..."

# 1. Check .env exists
if [ ! -f ".env" ]; then
  echo "ERROR: .env file not found. Run: cp .env.example .env"
  exit 1
fi

# 2. Check we're not on main branch
BRANCH=$(git branch --show-current)
if [ "$BRANCH" = "main" ]; then
  echo "WARNING: You are on the 'main' branch."
  echo "Switch to 'dev' or a feature branch before developing."
  echo "  git checkout dev"
  exit 1
fi

# 3. Check not using production database (basic heuristic)
if [ -f ".env" ]; then
  DB_URL=$(grep -E "^DATABASE_URL=" .env 2>/dev/null | head -1 || true)
  if echo "$DB_URL" | grep -qi "production\|prod\b" 2>/dev/null; then
    echo "WARNING: DATABASE_URL appears to contain a production database."
    echo "Local development should use a development/branch database."
    echo "See: bash script/setup-db-branch.sh"
    exit 1
  fi
fi

# 4. Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Note: You have uncommitted changes."
  git status --short
  echo ""
fi

# 5. Check port availability
PORT="${PORT:-5000}"
if lsof -i ":$PORT" -sTCP:LISTEN > /dev/null 2>&1; then
  echo "WARNING: Port $PORT is already in use."
  echo "Kill the existing process or use a different port."
  lsof -i ":$PORT" -sTCP:LISTEN
  exit 1
fi

echo "All checks passed. Starting dev server on port $PORT..."
echo ""

# Detect package manager and start
if [ -f "pnpm-lock.yaml" ]; then
  pnpm run dev
elif [ -f "bun.lockb" ]; then
  bun run dev
elif [ -f "yarn.lock" ]; then
  yarn dev
else
  npm run dev
fi
