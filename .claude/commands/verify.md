Run the full verification pipeline per CLAUDE.md §3.

1. `npm install` — confirm dependencies intact
2. `npm run check` — TypeScript baseline (no new errors)
3. `npm run build` — build succeeds
4. `npm run test` — unit tests pass (if configured)
5. Start dev server → confirm it starts → check /api/health (if exists)
6. Use Claude Preview to screenshot main page → confirm no console errors
7. `git diff --stat` — confirm changes are reasonable (< 50 lines per §2)

Report: list each check as PASS/FAIL with actual command output as evidence.

If any check FAILS, attempt to fix and re-run. After 3 failed attempts on the same check, report the issue and stop.

$ARGUMENTS
