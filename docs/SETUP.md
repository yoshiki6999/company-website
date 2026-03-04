# Project Setup Guide

## Prerequisites

- Node.js 20+
- npm / pnpm / bun
- Git
- GitHub CLI (`gh`) — optional but recommended
- Claude Code CLI (`claude`)

## Quick Start

```bash
# 1. Create project from template
gh repo create my-project --template yoshiki6999/ai-project-template --clone
cd my-project

# 2. Run setup script
bash script/setup.sh

# 3. Configure environment
cp .env.example .env
# Edit .env with your actual values

# 4. Configure database separation
bash script/setup-db-branch.sh

# 5. Start developing
git checkout dev
claude   # Start Claude Code
```

## GitHub Secrets Configuration

Go to your repo → Settings → Secrets and variables → Actions:

### Required for CI
- None (CI uses npm scripts)

### Required for Railway Deployment
| Secret | Description |
|--------|------------|
| `RAILWAY_TOKEN` | Railway API token |

| Variable | Description |
|----------|------------|
| `RAILWAY_SERVICE_ID` | Production service ID |
| `RAILWAY_PREVIEW_SERVICE_ID` | Preview/staging service ID |

### Required for Vercel Deployment
| Secret | Description |
|--------|------------|
| `VERCEL_TOKEN` | Vercel API token |
| `VERCEL_ORG_ID` | Vercel organization ID |
| `VERCEL_PROJECT_ID` | Vercel project ID |

## GitHub Environments

Set up two environments in Settings → Environments:

### `production`
- Required reviewers: 1+ (for manual approval before production deploy)
- Branch: `main` only

### `preview`
- No required reviewers
- Branch: `dev` only

## Database Setup

See `bash script/setup-db-branch.sh` for guided setup based on your database provider.

Key principle: **Development and production databases must be completely separate.**

## Development Workflow

```
1. Work on dev branch (or claude/* feature branches)
2. Push to dev → auto-deploys to staging
3. Verify on staging
4. Create PR: dev → main
5. Human review + approve
6. Merge → auto-deploys to production
```

## Claude Code Integration

The project includes pre-configured Claude Code tools:

### Custom Commands
| Command | Purpose |
|---------|---------|
| `/verify` | Run full verification pipeline |
| `/devlog` | Generate development log |
| `/status` | View/update project status |
| `/db` | Safe database queries |
| `/deploy-check` | Deployment readiness check |
| `/new-feature` | Start new feature with proper setup |
| `/handover` | Generate AI handover summary |
| `/auto-dev` | Prototype-to-development automation |

### Hooks
- **PostToolUse (Write/Edit)**: Auto TypeScript check after file edits
- **PreToolUse (Bash)**: Block dangerous database operations (DROP, TRUNCATE, etc.)
