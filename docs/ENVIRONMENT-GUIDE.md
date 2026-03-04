# Environment Configuration Guide

## Three Environments

| Environment | Branch | Database | Config Source |
|-------------|--------|----------|--------------|
| Local Dev | `dev` / `claude/*` | Development DB | `.env` (local file) |
| Preview/Staging | `dev` | Development DB | GitHub Secrets / Platform env vars |
| Production | `main` | Production DB | GitHub Secrets / Platform env vars |

## Environment Variables

All environment differences are controlled through variables. Code must NEVER hardcode environment-specific values.

### .env File (Local Development Only)

```bash
# Copy from .env.example and fill in your values
cp .env.example .env
```

**IMPORTANT**: `.env` is in `.gitignore` and must NEVER be committed.

### Platform Environment Variables

#### Railway
- Dashboard → Project → Variables
- Set separately for each service (production vs preview)
- Railway auto-injects `PORT` and `RAILWAY_*` variables

#### Vercel
- Dashboard → Project → Settings → Environment Variables
- Set per environment: Production / Preview / Development
- Vercel auto-injects deployment-specific variables

#### Cloudflare
- Dashboard → Workers → Settings → Variables
- Supports encrypted secrets

## Database Separation

### Why Separate?
- Prevent dev work from corrupting production data
- Allow destructive testing (drop tables, seed data) without risk
- Enable parallel development without conflicts

### How to Separate

| Provider | Method | Guide |
|----------|--------|-------|
| Neon | Database branching | `bash script/setup-db-branch.sh` |
| Supabase | Separate projects | Create `{project}-dev` project |
| Vercel Postgres | Environment linking | Link dev DB to Preview environment |
| Turso | Database branching | `turso db create {name}-dev --from-db {name}` |
| PlanetScale | Database branching | Create dev branch from main |
| Generic PG | Separate databases | Create `{name}_dev` database |

### Verification

To confirm you're NOT connected to production locally:
```bash
# Check your local DATABASE_URL
grep DATABASE_URL .env

# The URL should contain 'dev', 'branch', or 'staging'
# It should NOT match your production URL
```

## Security Rules

1. Production credentials NEVER in local files
2. `.env` NEVER committed to git
3. API keys NEVER in client-side code
4. Use environment variables for ALL config that differs between environments
5. Review `.env.example` to ensure no real values leaked
