# /init — Interactive Project Initialization

Guide the user through project setup with the following steps. Ask questions conversationally and execute automatically.

## Step 1: Understand the Product

Ask the user:
1. **What are you building?** (one sentence description)
2. **Who are the target users?** (e.g., "Japanese office workers", "global consumers")
3. **Product type?**
   - Web application (full-stack with database)
   - Landing page / marketing site (static, no database)
   - API service (backend only, no UI)
   - Mobile-first web app (PWA)

## Step 2: Choose Tech Stack

Based on the product type, recommend the simplest viable option:

### Web Application → Next.js + Prisma + Neon
- Copy from `presets/nextjs-prisma/`
- Best for: full-stack apps with database, user auth, CRUD operations

### Landing Page → Next.js (static export)
- Minimal Next.js with `output: 'export'` in next.config
- No database needed, deploy to Vercel for free
- Best for: marketing sites, portfolios, product landing pages

### API Service → Hono on Cloudflare Workers
- Lightweight, fast, cost-effective
- Best for: webhook handlers, microservices, API-only backends

### Mobile-first Web App → Next.js + PWA
- Same as Web Application + PWA manifest + service worker
- Best for: apps that feel native on mobile

## Step 3: Choose Deployment Platform

Ask: "Where should this be deployed?"
- **Vercel** (recommended for Next.js — free tier, automatic previews)
- **Railway** (better for long-running processes, WebSocket, cron jobs)
- **Cloudflare** (best for API-only, edge computing, cheapest at scale)

## Step 4: Choose Database (if applicable)

Ask: "Which database?"
- **Neon** (recommended — free tier, branch support for dev/prod, PostgreSQL)
- **Supabase** (good if you also need auth/storage/realtime built-in)
- **Turso** (best for edge deployments, SQLite-based, very fast reads)
- **None** (for static sites)

## Step 5: Execute Setup

After collecting answers, execute automatically:

1. Copy the appropriate preset to project root
2. Update `package.json` name field with the project name
3. Update `PROJECT.md` with product description, target users, tech stack
4. Configure `vercel.json` or `railway.json` as appropriate
5. Update `.env.example` — uncomment the chosen database section only
6. Run `npm install`
7. Run `npm run check` to verify TypeScript
8. Run `npm run build` to verify build
9. Create initial git commit: `feat: initialize {project-name} with {tech-stack}`
10. Update `docs/STATUS.md` with initial project state

## Step 6: Report

Output a summary:
```
✅ Project initialized!

Tech Stack: {choices}
Deployment: {platform}
Database: {database}

Next Steps:
1. Configure your .env file with real credentials
2. Write your first SPEC.md in the module folder
3. Run: claude /auto-dev {module-name}
```

## Rules
- Always choose the SIMPLEST option that meets the user's needs
- Default to the Japanese market context (lang="ja", timezone Asia/Tokyo)
- If the user seems unsure, recommend the default: Next.js + Neon + Vercel
- Do NOT ask unnecessary technical questions — make sensible defaults
- The Minimum Viable Approach: if a static site can solve it, don't suggest a full-stack app
