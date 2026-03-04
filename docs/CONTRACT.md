# Module Interface Contracts

> Any Agent calling another module MUST follow this contract.
> Modifying this file = Prompt-level permission (requires human approval).

## Contract Metadata

| Field | Value |
|-------|-------|
| Version | 1.0.0 |
| Last Modified | 2026-03-01 |
| Modified By | — (template initial) |

## Change Log

| Version | Date | Agent | Change Description |
|---------|------|-------|--------------------|
| 1.0.0 | 2026-03-01 | — | Initial template |

> **Version Rules**:
> - Adding new interface → patch bump (1.0.x)
> - Modifying existing interface → minor bump (1.x.0) + Prompt-level approval
> - Removing interface or breaking change → major bump (x.0.0) + Prompt-level approval
> - Every Agent MUST check Contract Version at session start. If version changed since last session, re-read full CONTRACT.

---

## Contract Format

```
## [module-name]

### External Interfaces (what this module exposes)
METHOD /api/path
  Input: { field: type }
  Output: { field: type }
  Auth: required / optional / none
  Errors: [list of error codes and meanings]

### Dependencies (what this module needs from others)
- [other-module] — [what it needs and why]
```

## Active Contracts

<!-- Add module contracts below as development progresses -->

<!--
Example:

## auth

### External Interfaces
POST /api/auth/login
  Input: { email: string, password: string }
  Output: { user: User, token: string }
  Auth: none
  Errors: 401 invalid credentials, 429 rate limited

GET /api/auth/me
  Input: none (uses session cookie)
  Output: { user: User }
  Auth: required
  Errors: 401 not authenticated

### Dependencies
- None (base module)

---

## voice-chat

### External Interfaces
POST /api/voice-chat/analyze
  Input: FormData { audio: File, templateId?: string, sessionId?: string }
  Output: { transcript: string, analysis: object, audioUrl: string }
  Auth: required
  Errors: 400 invalid audio, 413 file too large, 500 AI service error

GET /api/voice-chat/sessions
  Input: query { page?: number, limit?: number }
  Output: { sessions: Session[], total: number }
  Auth: required
  Errors: 401 not authenticated

### Dependencies
- auth (requires login session)
- storage (file upload for audio)
-->

## Contract Change Rules

1. Adding a new interface → append to this file (Auto-Allow)
2. Modifying an existing interface signature → Prompt-level permission
3. Removing an interface → Prompt-level permission
4. All Agents must read this file at session start (CLAUDE.md §16)
5. Every modification MUST update the Version, Last Modified, Modified By, and Change Log fields
6. Agents must record Contract Version in their DEV-LOG
