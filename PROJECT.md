# こころナビ — Project Overview

> AI handover document. New AI developers: read this file first to understand the full picture.

## One-Line Description
こころナビ（Kokoro Navi）— 楽悠株式会社のメンタルヘルスサポートサービスのコーポレートサイト。

## User Profile
- Developer: zero-code background, relies on AI for all coding
- Target market: Japan
- Devices: MacBook M4 Air + iPhone 16 Plus

## Tech Stack
| Layer | Technology | Notes |
|-------|-----------|-------|
| Frontend | Static HTML/CSS | Single landing page, will evolve as needed |
| Deployment | Vercel | Auto-deploy from GitHub main branch |
| Domain | raku-yu.com / www.rakuyujp.com | Custom domains on Vercel |

## System Architecture
```
  Browser ──→ Vercel CDN ──→ Static HTML
                               (index.html)
```

## Module Inventory
| Module | Function | Core Files | Status |
|--------|----------|-----------|--------|
| landing | Landing page with brand intro | index.html | completed |

## Environment Info
- Production URL: https://raku-yu.com
- Alt domain: https://www.rakuyujp.com
- Vercel project: rakuyu-site
- GitHub repo: yoshiki6999/company-website

## Key Configuration Files
| File | Purpose |
|------|---------|
| CLAUDE.md | AI development rules (Iron Rules v5.0) |
| docs/STATUS.md | Current development progress |
| vercel.json | Vercel deployment configuration |
| PROJECT.md | This file — project overview |

## Update Rules
- New/removed module → update Module Inventory
- Tech stack change → update Tech Stack table
- Does NOT need updates every session (unlike STATUS.md)
