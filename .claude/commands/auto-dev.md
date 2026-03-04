Prototype-to-Development: fully autonomous development from a prototype.

Trigger: when a module has static JSX/TSX prototype pages + SPEC.md ready.

## Input
The argument should be a module name. The module directory should contain:
- SPEC.md (required) — feature specification with user stories, acceptance criteria
- *.tsx / *.jsx (optional) — static UI prototype pages
- *.png / *.jpg (optional) — design mockups

## Execution Flow

### Phase 1: Analysis
1. Read {module}/SPEC.md — understand all requirements and acceptance criteria
2. Scan {module}/*.tsx for all:
   - Interactive elements (buttons, forms, inputs)
   - Data display areas (lists, tables, cards)
   - Navigation flows (links, tabs, modals)
   - User states (logged in/out, empty/loaded, error/success)
3. Derive from UI analysis:
   - Required API endpoints (method, path, input, output)
   - Required database tables and relationships
   - Required business logic and validation rules
4. Output the development plan and wait for human approval (Prompt level)

### Phase 2: Backend Development (§1 order)
5. Create/update database schema (shared/schema.ts or equivalent)
6. Run schema migration: `npx drizzle-kit push` or equivalent
7. Create API route file: server/{module}.ts
8. Implement each endpoint with validation + error handling
9. L1 snapshot after each endpoint
10. Verify ALL endpoints: normal + abnormal inputs (§3 Check 2)

### Phase 3: Frontend Development
11. Transform static prototype into dynamic components:
    - Replace hardcoded data with API calls
    - Add loading states, error states, empty states
    - Wire up forms to API endpoints
    - Add client-side validation (server-side is the authority)
12. L1 snapshot after each component transformation

### Phase 4: End-to-End Verification
13. Full user journey simulation (§3 Check 4):
    - Happy path: complete flow from start to finish
    - Error paths: empty input, invalid data, network errors
    - Edge cases from SPEC.md acceptance criteria
14. Visual confirmation: screenshot every key state
15. Console check: zero errors

### Phase 5: Completion
16. L2 feature snapshot: `git commit -m "feat({module}): [description from SPEC.md]"`
17. L3 status update: `/status update`
18. Update PROJECT.md: add new API endpoints and module entry
19. Update docs/CONTRACT.md: document new external interfaces
20. Output DEV-LOG

## Rules
- SPEC.md is the source of truth — prototype is reference only
- If SPEC.md and prototype conflict → follow SPEC.md, flag the difference
- Each sub-feature gets an L1 snapshot immediately after passing tests
- If any verification fails → self-healing loop (§4) before continuing
- If a step requires human decision → pause and ask (Prompt level)

Module name: $ARGUMENTS
