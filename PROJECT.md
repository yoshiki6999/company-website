# [Project Name] — Project Overview

> AI handover document. New AI developers: read this file first to understand the full picture.

## One-Line Description
<!-- [What this project does, who it's for, what problem it solves] -->

## User Profile
- Developer: <!-- [zero-code background / full-stack engineer / etc.] -->
- Target market: <!-- [Japan / Global / etc.] -->
- Devices: <!-- [MacBook / Windows / etc.] -->

## Tech Stack
| Layer | Technology | Notes |
|-------|-----------|-------|
| Frontend | <!-- [React / Next.js / etc.] --> | <!-- [additional notes] --> |
| Backend | <!-- [Express / Hono / etc.] --> | <!-- [additional notes] --> |
| Database | <!-- [Neon / Supabase / etc.] --> | <!-- [additional notes] --> |
| ORM | <!-- [Drizzle / Prisma / etc.] --> | <!-- [additional notes] --> |
| AI | <!-- [Gemini / Claude / etc.] --> | <!-- [usage notes] --> |
| Deployment | <!-- [Railway / Vercel / etc.] --> | <!-- [additional notes] --> |
| Testing | <!-- [Vitest / Playwright / etc.] --> | <!-- [additional notes] --> |

## System Architecture
```
<!-- ASCII diagram or text description of system architecture -->
<!-- Example:
  Browser ──→ CDN ──→ Frontend (React SPA)
                          │
                          ▼
                     API Server (Express)
                      │         │
                      ▼         ▼
                  Database    AI Services
                  (Neon PG)   (Gemini API)
-->
```

## Module Inventory
| Module | Function | Core Files | Status |
|--------|----------|-----------|--------|
| <!-- [module-name] --> | <!-- [description] --> | <!-- [key file paths] --> | <!-- completed / in-dev / planned --> |

## API Endpoint Overview
| Method | Path | Function | Auth |
|--------|------|----------|------|
| <!-- [GET/POST] --> | <!-- [/api/xxx] --> | <!-- [description] --> | <!-- [yes/no] --> |

## Database Overview
- Total tables: <!-- N -->
- Schema file: <!-- [path] -->
- Key relationships: <!-- [brief description] -->

## Environment Info
- Local dev port: `${PORT}`
- Production URL: <!-- [url] -->
- Staging URL: <!-- [url] -->
- Database platform: <!-- [Neon/Supabase] @ [region] -->

## Key Configuration Files
| File | Purpose |
|------|---------|
| CLAUDE.md | AI development rules (Iron Rules v5.0) |
| docs/STATUS.md | Current development progress |
| docs/CONTRACT.md | Inter-module API contracts |
| docs/MODULE-LOCK.md | File ownership for multi-agent dev |
| .env.example | Environment variable template |

## Update Rules
- New/removed module → update Module Inventory
- New API endpoint → update API Endpoint Overview
- Tech stack change → update Tech Stack table
- Does NOT need updates every session (unlike STATUS.md)
