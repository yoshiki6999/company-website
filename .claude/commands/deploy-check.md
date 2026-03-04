Deployment readiness check — run before creating a PR to main.

Checks:
1. `npm run build` — must succeed
2. Check deployment config exists (railway.json or vercel.json or equivalent)
3. Check .env.example — all required vars documented
4. `npm run check` — TypeScript baseline, no new errors
5. Grep for hardcoded localhost/staging URLs in non-test source files
6. `git status` — must be clean (no uncommitted changes)
7. Check current branch — should be `dev` for staging, or PR to `main` for production
8. Check /api/health endpoint returns 200 (if local server is running)
9. Verify docs/STATUS.md is up to date (last updated within current session)
10. Verify no secrets in committed files: grep for patterns like API_KEY=, SECRET=, PASSWORD=

Report: READY or NOT READY with specific blockers listed.

$ARGUMENTS
