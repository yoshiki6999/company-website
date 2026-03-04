import Link from "next/link";

export default async function HomePage() {
  return (
    <main style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h1>Welcome to My App</h1>
      <p>Built with Next.js, Prisma, and Neon PostgreSQL</p>

      <div style={{ marginTop: "2rem", padding: "1rem", backgroundColor: "#f0f0f0", borderRadius: "4px" }}>
        <h2>Quick Links</h2>
        <ul>
          <li>
            <Link href="/api/health">Check API Health</Link>
          </li>
          <li>
            <a href="https://nextjs.org/docs" target="_blank" rel="noopener noreferrer">
              Next.js Documentation
            </a>
          </li>
          <li>
            <a href="https://prisma.io/docs" target="_blank" rel="noopener noreferrer">
              Prisma Documentation
            </a>
          </li>
        </ul>
      </div>

      <div style={{ marginTop: "2rem" }}>
        <h2>Next Steps</h2>
        <ol>
          <li>Write your feature spec in SPEC-TEMPLATE.md</li>
          <li>Show the spec to your AI agent (Claude Code, Cursor, Codex)</li>
          <li>AI agent will build the database schema, API, and UI</li>
          <li>Review and merge to production</li>
        </ol>
      </div>
    </main>
  );
}
