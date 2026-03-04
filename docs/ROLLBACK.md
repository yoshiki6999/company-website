# Rollback Guide

> When deployments go wrong, follow this guide to restore service quickly.

---

## Quick Rollback Procedures

### 1. Vercel Rollback

**Via Vercel Dashboard:**
1. Go to https://vercel.com/dashboard
2. Select your project
3. Navigate to **Deployments** tab
4. Find the previous stable deployment in the list
5. Click the three-dot menu → **Promote to Production**
6. Confirm — deployment will be instant

**Via Vercel CLI:**
```bash
# List recent deployments
vercel deployments

# Rollback to a specific deployment
vercel rollback <deployment-url>

# Example:
vercel rollback myapp.vercel.app
```

**Notes:**
- Vercel keeps full history of all deployments
- Rollback is instant (no rebuild needed)
- Original code is preserved on the previous deployment
- New deployment URL not needed for rollback

---

### 2. Railway Rollback

**Via Railway Dashboard:**
1. Go to https://railway.app/dashboard
2. Open your project
3. Navigate to **Deployments** section
4. Find the stable previous deployment
5. Click **Redeploy** on that deployment
6. Confirm — new deployment will start from previous code/config

**Notes:**
- Railway rebuilds from the previous deployment's code
- Takes a few minutes (depends on build time)
- Previous environment variables and config preserved

---

### 3. Git-Based Rollback (Universal Method)

**Find the last good commit:**
```bash
git log --oneline -10 main
# Output:
# a1b2c3d (HEAD -> main) [BAD] Deploy config change
# e4f5g6h (origin/main) [GOOD] Previous stable state
# i7j8k9l Feature X complete
```

**Preferred method — Create a revert commit:**
```bash
# This is reversible and preserves full history
git revert HEAD

# Resolve any conflicts if they exist
git add .
git commit -m "Revert: rollback to previous stable state"

# Push to trigger redeploy
git push origin main
```

**Emergency method — Hard reset (use only in critical situations):**
```bash
# ⚠️ WARNING: This rewrites history. Use only when revert fails.
# Notify team immediately before using this.

git reset --hard <commit-hash>
git push --force-with-lease origin main

# Example:
git reset --hard e4f5g6h
git push --force-with-lease origin main
```

**Never use naked `git push --force`** — always use `--force-with-lease` (safer, prevents overwriting concurrent pushes).

---

## Database Rollback

### Neon (PostgreSQL)

**Create recovery branch from past state:**
1. Go to https://console.neon.tech
2. Open your project
3. Navigate to **Branches** section
4. Click **Create Branch** → select **From past**
5. Choose the desired point in time
6. New branch created with recovered data
7. Update `.env.local` to point to recovery branch for testing

**Restore production by swapping branch:**
```bash
# If recovery branch looks good, you can:
# 1. Delete the bad branch
# 2. Rename recovery branch to "main"
# 3. Or update app's DATABASE_URL to recovery branch
```

**Manual backup before risky migrations:**
```bash
# Dump entire database
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d_%H%M%S).sql

# If needed, restore:
psql $DATABASE_URL < backup_YYYYMMDD_HHMMSS.sql
```

---

### Supabase

**Dashboard recovery:**
1. Go to https://supabase.com/dashboard
2. Open your project
3. Navigate to **Backups** section (Pro plan)
4. Select desired backup timestamp
5. Click **Restore** — Supabase will restore the entire database to that point

**Notes:**
- Free tier: limited backup history (limited days)
- Pro tier: point-in-time recovery available
- Restoration takes a few minutes

---

### Turso (SQLite)

**Create manual backup before migrations:**
```bash
# Dump database to file
turso db shell mydb .dump > backup_$(date +%Y%m%d).sql

# Verify backup
turso db shell mydb < backup_YYYYMMDD.sql  # Test restore on copy first
```

**Restore from backup:**
```bash
# If production is corrupted, restore from backup file
# Create new database and restore into it, then swap connection string

turso db create mydb_restored
turso db shell mydb_restored < backup_YYYYMMDD.sql

# Update .env.local DATABASE_URL to point to mydb_restored
```

---

### Generic PostgreSQL (Self-Hosted)

**Create manual backup before risky operations:**
```bash
# Full database dump
pg_dump "$DATABASE_URL" > backup_$(date +%Y%m%d_%H%M%S).sql

# Compressed backup (saves space)
pg_dump "$DATABASE_URL" | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz

# Verify backup is valid
gunzip -t backup_YYYYMMDD_HHMMSS.sql.gz
```

**Restore from backup:**
```bash
# Restore from uncompressed backup
psql "$DATABASE_URL" < backup_YYYYMMDD_HHMMSS.sql

# Restore from compressed backup
gunzip -c backup_YYYYMMDD_HHMMSS.sql.gz | psql "$DATABASE_URL"

# Restore to specific schema (for testing)
psql "$DATABASE_URL" -c "CREATE SCHEMA restored_$(date +%s);" < backup_YYYYMMDD.sql
```

---

## Rollback Decision Tree

```
Production issue detected
    ↓
Is it a UI/frontend-only issue?
    → YES: Rollback deployment (Vercel/Railway, Section 1–2)
    → NO: Continue ↓

Is it a database schema issue (migration error)?
    → YES: Database rollback needed (see "Database Rollback" section)
    → NO: Continue ↓

Is it a backend API logic issue?
    → YES: Git revert + redeploy (Section 3, "Preferred method")
    → NO: Continue ↓

Is it a third-party API/service integration issue?
    → YES: Check API status + contact provider support
    → NO: Investigate application logs further before rolling back
```

---

## Prevention Checklist

- [ ] Run `/deploy-check` before every production deployment
- [ ] Keep all database migrations reversible — always write `down()` migrations
- [ ] Never run destructive database operations without automated backup
- [ ] Tag releases: `git tag -a v{x.y.z} -m "Release description"`
- [ ] Test rollback procedure in staging before production incident
- [ ] Monitor `/api/health` endpoint immediately after deployment (for 5–10 minutes)
- [ ] Set up alerts for error rates, latency spikes, database connection pool exhaustion
- [ ] Keep deployment changelogs in git (use conventional commits)
- [ ] Document new API changes in `docs/CONTRACT.md` before deployment

---

## Health Check After Rollback

After rolling back, verify the system is healthy:

```bash
# Check API health
curl -X GET http://your-api.com/api/health
# Expected: { "status": "ok", "timestamp": "..." }

# Check database connection
curl -X GET http://your-api.com/api/health/db
# Expected: { "status": "connected" }

# Check error logs
# (Check your log aggregation service — Sentry, Datadog, LogRocket, etc.)

# Monitor dashboard
# (Check uptime, response times, error rates for 10–15 minutes)
```

---

## Emergency Contacts & Resources

| Resource | URL | Purpose |
|----------|-----|---------|
| Vercel Dashboard | https://vercel.com/dashboard | Manage deployments, rollback |
| Railway Dashboard | https://railway.app/dashboard | Manage deployments, config |
| Neon Console | https://console.neon.tech | Database backups & recovery |
| Supabase Dashboard | https://supabase.com/dashboard | Database management (if used) |
| GitHub Actions | https://github.com/{owner}/{repo}/actions | Check deployment workflows |
| Git Documentation | https://git-scm.com/docs | Git revert / reset reference |

---

## Common Rollback Scenarios

### Scenario 1: Frontend UI broken after deployment
**Action:** Use Vercel rollback (Section 1, Dashboard method)
**Time to restore:** ~30 seconds

### Scenario 2: API endpoint returning 500 errors
**Action:** Check error logs → determine cause → git revert (Section 3, Preferred method) → redeploy
**Time to restore:** 2–5 minutes

### Scenario 3: Database migration failed / data corrupted
**Action:** Stop application → database rollback (Section "Database Rollback") → verify data integrity → restart application
**Time to restore:** 10–30 minutes (depends on backup size)

### Scenario 4: Environment variable misconfiguration
**Action:** Fix variable → redeploy (does not need full rollback)
**Time to restore:** 1–2 minutes

### Scenario 5: Third-party API integration broken
**Action:** Check API provider status → verify credentials/tokens are correct → if API is down, implement fallback/degraded mode
**Time to restore:** Varies (external dependency)

---

## Rollback Record (Incident Tracking)

After any rollback incident, document it:

```markdown
## Incident: [Date] [Description]

- **Detection time**: [HH:MM UTC]
- **Impact**: [What was broken]
- **Root cause**: [Why it happened]
- **Rollback method used**: [Vercel/Railway/Git/DB]
- **Time to resolve**: [minutes]
- **Recovery commit/version**: [git hash or deployment ID]

### Post-mortem
- [ ] Root cause identified
- [ ] Preventive measure implemented
- [ ] Monitoring improved to catch earlier
- [ ] Team aware of incident

```

Keep these records in a shared location (GitHub wiki, Notion, or docs/INCIDENTS.md) for future reference.
