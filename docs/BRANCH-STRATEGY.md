# Branch Strategy

## Branch Model

```
main ← (PR + human approval) ← dev ← (free push) ← claude/* feature branches
 │                               │
 │                               └── Auto-deploy → Preview/Staging
 └── Auto-deploy → Production
```

## Branch Rules

| Branch | Who Pushes | Auto-Deploys To | Database |
|--------|-----------|----------------|----------|
| `main` | PR merge only | Production | Production DB |
| `dev` | CC direct push | Preview/Staging | Development DB |
| `claude/*` | CC worktree branches | Not deployed | Local / Development DB |

## Branch Protection (main)

Configured via `script/setup.sh` or manually:

- Require pull request before merging
- Required approvals: 1
- Require status checks: `build` (CI)
- Dismiss stale reviews on new push
- Restrict direct pushes

## Naming Conventions

### Feature Branches
```
claude/{type}/{module}-{description}

Types: feat | fix | upgrade | refactor | test | docs
Examples:
  claude/feat/voice-chat-realtime-audio
  claude/fix/receipts-upload-timeout
  claude/upgrade/auth-webauthn-support
```

### Commits
```
{type}: {description}

Examples:
  feat: add WebSocket support to voice chat
  fix: resolve mobile Safari audio playback
  upgrade: migrate auth from session to JWT
```

## Workflow

### Normal Development
```
1. git checkout dev
2. Develop + test + commit on dev
3. Push dev → auto-deploy to staging
4. Verify on staging
5. Create PR: dev → main
6. Human review + approve
7. Merge → auto-deploy to production
```

### Feature Branch (for larger features)
```
1. git checkout -b claude/feat/module-description dev
2. Develop + test + commit on feature branch
3. git checkout dev && git merge claude/feat/module-description
4. Push dev → verify on staging
5. Create PR: dev → main
```

### Multi-Agent Parallel Development
```
1. Each Agent creates: claude/feat/{their-module}-description
2. Each Agent works in isolation (worktree)
3. Agent completes → PR to dev → human merges
4. Other Agents rebase on latest dev
5. After all modules merged → PR: dev → main
```
