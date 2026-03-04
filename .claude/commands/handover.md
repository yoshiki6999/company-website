Generate a comprehensive handover summary for a new AI developer taking over this project.

Steps:
1. Read PROJECT.md — project overview and architecture
2. Read docs/STATUS.md — current development status
3. Read CLAUDE.md — development rules (summarize top 5 key points)
4. Run `git log --oneline -15` — recent commit history
5. Run `git branch -a` — all branches (local + remote)
6. Run `git diff --stat dev..main` — dev/main gap (skip if dev doesn't exist)
7. Run `git status` — check for uncommitted changes
8. Read docs/CONTRACT.md — inter-module interfaces (if exists)
9. Read docs/MODULE-LOCK.md — file ownership (if exists)

Output a structured handover briefing:

```
## Handover Briefing

**Project**: [1 sentence from PROJECT.md]
**Tech Stack**: [key technologies]
**Current Task**: [from STATUS.md]
**Branch**: [current branch] | dev/main gap: [N commits]
**Uncommitted Changes**: [yes/no, what files]
**Known Issues**: [from STATUS.md]
**Next Steps**: [from STATUS.md]

### Key Rules (from CLAUDE.md)
1. [top 5 most important rules for this project]

### Module Status
| Module | Owner | Status |
|--------|-------|--------|
[from MODULE-LOCK.md and PROJECT.md]

### Active Interfaces
[from CONTRACT.md — list key API contracts]
```

$ARGUMENTS
