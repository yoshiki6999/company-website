#!/bin/bash
# Database branch setup helper
# Detects database type and guides dev/prod separation

set -e

echo "=========================================="
echo "  Database Branch Setup"
echo "=========================================="
echo ""

# Load .env if exists
if [ -f ".env" ]; then
  source .env 2>/dev/null || true
fi

# Detect database type
if [[ "${DATABASE_URL:-}" == *"neon"* ]]; then
  echo "Detected: Neon PostgreSQL"
  echo ""
  echo "Neon supports database branching natively:"
  echo "  1. Go to Neon Console → your project → Branches"
  echo "  2. Click 'Create Branch' from your main branch"
  echo "  3. Copy the new branch's connection string"
  echo "  4. Set it as DATABASE_URL in your .env for local development"
  echo ""
  echo "Environment variable setup:"
  echo "  - Local .env: DATABASE_URL=<dev-branch-connection-string>"
  echo "  - GitHub Secrets (preview): DATABASE_URL=<dev-branch-connection-string>"
  echo "  - GitHub Secrets (production): DATABASE_URL=<main-branch-connection-string>"

elif [[ "${SUPABASE_URL:-}" != "" ]]; then
  echo "Detected: Supabase"
  echo ""
  echo "Recommended: Create a separate Supabase project for development:"
  echo "  1. Go to supabase.com → New Project (name it '{project}-dev')"
  echo "  2. Copy the new project's URL and keys"
  echo "  3. Set them in your .env for local development"
  echo ""
  echo "Environment variable setup:"
  echo "  - Local .env: SUPABASE_URL=<dev-project-url>"
  echo "  - GitHub Secrets (preview): SUPABASE_URL=<dev-project-url>"
  echo "  - GitHub Secrets (production): SUPABASE_URL=<prod-project-url>"

elif [[ "${DATABASE_URL:-}" == *"vercel"* ]] || [[ "${POSTGRES_URL:-}" != "" ]]; then
  echo "Detected: Vercel Postgres"
  echo ""
  echo "Vercel Postgres uses environment-based separation:"
  echo "  1. In Vercel Dashboard → Storage → your database"
  echo "  2. Create a development database"
  echo "  3. Link it to your Preview environment"
  echo ""
  echo "Vercel auto-injects the correct DATABASE_URL per environment."

elif [[ "${DATABASE_URL:-}" == *"turso"* ]] || [[ "${TURSO_DATABASE_URL:-}" != "" ]]; then
  echo "Detected: Turso (LibSQL)"
  echo ""
  echo "Turso supports database branching:"
  echo "  turso db create {project}-dev --from-db {project}"
  echo ""
  echo "Set the dev database URL in your .env for local development."

else
  echo "Database type: Generic / Not detected"
  echo ""
  echo "General recommendations for database dev/prod separation:"
  echo "  1. Create a separate database for development"
  echo "  2. Use different DATABASE_URL in .env (local) vs GitHub Secrets (production)"
  echo "  3. NEVER use production credentials in local development"
  echo ""
  echo "Supported databases:"
  echo "  - Neon PostgreSQL (recommended — native branching)"
  echo "  - Supabase (separate projects for dev/prod)"
  echo "  - Vercel Postgres (environment-based)"
  echo "  - Turso / LibSQL (database branching)"
  echo "  - PlanetScale (database branching)"
fi

echo ""
echo "=========================================="
echo "  Important Reminders"
echo "=========================================="
echo ""
echo "- NEVER commit .env files (they're in .gitignore)"
echo "- Production credentials go in GitHub Secrets or platform env vars"
echo "- Local .env should ONLY contain development database credentials"
echo "- Run schema migrations on both dev and prod databases separately"
echo ""
