Read and optionally update docs/STATUS.md — the project's real-time state file.

## Without arguments: DISPLAY current status
1. Read docs/STATUS.md
2. Run `git log --oneline -5`
3. Run `git status`
4. Run `git diff --stat dev..main` (skip if dev branch doesn't exist yet)
5. Summarize: current branch, uncommitted changes, dev/main gap, next steps

## With arguments: UPDATE status (when finishing a task)
1. Read current docs/STATUS.md
2. Update "Last Updated" timestamp to current date/time
3. Update "Current Phase" based on what was just completed
4. Update "Recent Changes" from `git log --oneline -5`
5. Update "Known Issues" — add new issues found, mark resolved ones
6. Update "Next Steps" based on remaining work
7. Write updated docs/STATUS.md
8. `git add docs/STATUS.md && git commit -m "docs: update project status"`

$ARGUMENTS
