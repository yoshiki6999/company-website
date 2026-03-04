Generate DEV-LOG per CLAUDE.md §10.

Steps:
1. `git diff --stat` → changed files and line counts
2. `git log --oneline -5` → recent commits
3. Fill EVERY row of the self-check table HONESTLY
4. Include actual command outputs as evidence
5. List remaining issues
6. After outputting DEV-LOG, run `/status update` to update docs/STATUS.md

IMPORTANT:
- Every rule in the self-check table must be filled (use NA with reason if not applicable)
- Do NOT mark all as compliant if checks weren't actually performed
- Verify script results must be actual output, not fabricated

$ARGUMENTS
