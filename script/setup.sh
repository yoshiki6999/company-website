#!/bin/bash
# Project initialization script
# Run after creating a new project from this template:
#   bash script/setup.sh

set -e

echo "=========================================="
echo "  AI Project Template — Initial Setup"
echo "=========================================="
echo ""

# 1. Check prerequisites
echo "Step 1: Checking prerequisites..."
command -v git >/dev/null 2>&1 || { echo "ERROR: git is required"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "ERROR: node is required"; exit 1; }
command -v gh >/dev/null 2>&1 || echo "WARNING: gh CLI not found — branch protection setup will be skipped"
echo "  Prerequisites OK"
echo ""

# 2. Detect package manager
echo "Step 2: Detecting package manager..."
if [ -f "pnpm-lock.yaml" ]; then
  PKG="pnpm"
elif [ -f "bun.lockb" ]; then
  PKG="bun"
elif [ -f "yarn.lock" ]; then
  PKG="yarn"
else
  PKG="npm"
fi
echo "  Using: $PKG"
echo ""

# 3. Create dev branch
echo "Step 3: Setting up branches..."
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "  WARNING: Current branch is '$CURRENT_BRANCH', not 'main'"
  echo "  Proceeding anyway..."
fi

if git show-ref --verify --quiet refs/heads/dev 2>/dev/null; then
  echo "  Branch 'dev' already exists"
else
  git checkout -b dev
  git push -u origin dev 2>/dev/null || echo "  Note: Could not push to remote (will push later)"
  git checkout main 2>/dev/null || true
  echo "  Branch 'dev' created"
fi
echo ""

# 4. Set up branch protection (if gh CLI available)
echo "Step 4: Branch protection..."
if command -v gh >/dev/null 2>&1; then
  REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
  if [ -n "$REPO" ]; then
    echo "  Setting up branch protection for 'main' on $REPO..."
    gh api repos/$REPO/branches/main/protection \
      -X PUT \
      -H "Accept: application/vnd.github+json" \
      --input - <<EOF 2>/dev/null || echo "  Note: Branch protection setup requires admin access"
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["build"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null
}
EOF
    echo "  Branch protection configured"
  else
    echo "  Skipped: not connected to a GitHub repository"
  fi
else
  echo "  Skipped: gh CLI not installed"
fi
echo ""

# 5. Environment setup
echo "Step 5: Environment configuration..."
if [ ! -f ".env" ]; then
  if [ -f ".env.example" ]; then
    cp .env.example .env
    echo "  Created .env from .env.example"
    echo "  IMPORTANT: Edit .env with your actual values before running the project"
  fi
else
  echo "  .env already exists"
fi
echo ""

# 6. Install dependencies
echo "Step 6: Installing dependencies..."
if [ -f "package.json" ]; then
  $PKG install
  echo "  Dependencies installed"
else
  echo "  No package.json found — skipping"
fi
echo ""

# 7. Verify setup
echo "Step 7: Verification..."
PASS=0
FAIL=0

if [ -f "package.json" ]; then
  if $PKG run check 2>/dev/null; then
    echo "  TypeScript check: PASS"
    PASS=$((PASS + 1))
  else
    echo "  TypeScript check: SKIP (no 'check' script)"
  fi

  if $PKG run build 2>/dev/null; then
    echo "  Build: PASS"
    PASS=$((PASS + 1))
  else
    echo "  Build: SKIP (no 'build' script or build failed)"
  fi
fi

echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Edit .env with your actual environment variables"
echo "  2. Configure database (see script/setup-db-branch.sh)"
echo "  3. Configure deployment platform secrets in GitHub"
echo "  4. Start developing on 'dev' branch: git checkout dev"
echo "  5. Run: claude  (to start Claude Code)"
echo ""
