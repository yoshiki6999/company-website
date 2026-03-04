# Project Status

## Last Updated
2026-03-04 12:15

## Current Phase
- **Current Task**: Connecting Vercel project to GitHub repo for auto-deployment
- **Branch**: main
- **Deploy Status**: staging N/A | production raku-yu.com (active)

## Recent Changes (Last 5 Commits)
- 15cdea7 Initial commit (template scaffold)
- (next) Add landing page HTML + Vercel static config

## Known Issues
- [ ] Vercel project not yet connected to this GitHub repo (manual step needed)
- [ ] presets/ directory contains unused Next.js template (can be cleaned up later)

## Next Steps
1. Connect Vercel rakuyu-site project to yoshiki6999/company-website repo
2. Verify auto-deployment works
3. Plan next features (additional pages, services, etc.)

## Architecture Notes
- Current site: single static HTML landing page
- Vercel serves as CDN + hosting
- presets/nextjs-prisma/ available for future upgrade to Next.js when dynamic features needed
