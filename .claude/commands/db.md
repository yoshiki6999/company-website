Query the project database safely.

Steps:
1. Read the schema file (shared/schema.ts, prisma/schema.prisma, or drizzle equivalent)
2. Understand the table structure relevant to the query
3. Construct appropriate SQL or ORM query
4. Execute via environment-safe method: `node --env-file=.env -e "..."`
5. Display results in a readable format

SECURITY RULES:
- SELECT queries only — unless the user explicitly requests modification
- Never log or display DATABASE_URL in output
- Never run DROP, TRUNCATE, or DELETE without WHERE clause
- Always use parameterized queries (no string concatenation)
- If the query might affect production data, confirm with the user first

Query: $ARGUMENTS
