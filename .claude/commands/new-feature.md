Start a new feature/module/upgrade with proper session setup.

## Step 1: Determine scope
Analyze the feature description to classify:
- type: feat / fix / upgrade / refactor / test
- module: identify which module this affects
- estimated lines: rough estimate of code changes

## Step 2: Session decision
If estimated lines > 100 OR this is a new module OR a different module from current work:
  → RECOMMEND: "Recommend opening new Session (worktree) to isolate context."
  → Generate the worktree name: claude/{type}/{module}-{description}

If estimated lines < 30 AND same module as current work:
  → Continue in current session

## Step 3: Setup
1. Create branch from dev: `git checkout -b claude/{type}/{module}-{description} dev`
2. Read docs/STATUS.md for current state
3. Read CLAUDE.md to refresh rules
4. If complex (new module / cross-module):
   - Read docs/AI-AUTOPILOT-MASTER.md (if exists)
   - Read docs/CONTRACT.md (if exists)
   - Read docs/MODULE-LOCK.md (if exists)
5. Create initial snapshot: `git add -A && git commit -m "chore: start {type}/{module}-{description}" --allow-empty`
6. Update docs/STATUS.md with new task

## Step 4: Output
Report:
- Branch created: claude/{type}/{module}-{description}
- Starting from: dev @ {commit-hash}
- Task: [{type}] {module} — {description}
- Estimated scope: ~{n} lines
- Session recommendation: new session / continue current

Feature description: $ARGUMENTS
