# Next.js + Prisma + Neon Preset

A production-ready project template for AI-powered development targeting the Japanese market.

This preset is designed for **zero-code founders and product managers** who use AI agents (Claude Code, Cursor, Codex) to build web applications.

## Quick Start

### 1. Copy This Preset to Your Project

```bash
cp -r presets/nextjs-prisma ~/my-new-app
cd ~/my-new-app
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Configure Environment

Create `.env.local` in the project root:

```env
# Database (Neon PostgreSQL)
DATABASE_URL="postgresql://user:password@host/dbname"

# Next.js
NEXT_PUBLIC_APP_URL="http://localhost:3000"
NODE_ENV="development"
```

For production, use Neon's connection string directly.

### 4. Initialize Database

```bash
npm run db:generate
npm run db:push
```

### 5. Start Development

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
.
├── src/
│   ├── app/               # Next.js App Router pages
│   ├── lib/               # Shared utilities (db, env, etc.)
│   └── components/        # Reusable React components
├── prisma/
│   └── schema.prisma      # Database schema
├── __tests__/             # Unit and integration tests
├── vitest.config.ts       # Test configuration
├── playwright.config.ts   # E2E test configuration
└── SPEC-TEMPLATE.md       # Use this to write your feature specs
```

## Available Commands

| Command | Purpose |
|---------|---------|
| `npm run dev` | Start dev server (localhost:3000) |
| `npm run build` | Build for production |
| `npm run start` | Start production server |
| `npm run check` | Type-check with TypeScript |
| `npm run test` | Run unit tests once |
| `npm run test:watch` | Run tests in watch mode |
| `npm run test:e2e` | Run end-to-end tests |
| `npm run db:generate` | Generate Prisma client |
| `npm run db:push` | Push schema changes to database |
| `npm run db:studio` | Open Prisma Studio (visual DB browser) |
| `npm run db:migrate` | Create a migration file |
| `npm run lint` | Check code style |

## Tech Stack

- **Framework**: Next.js 15 (App Router)
- **Database**: PostgreSQL (via Neon)
- **ORM**: Prisma 6
- **Language**: TypeScript
- **Validation**: Zod
- **Testing**: Vitest + Playwright
- **UI**: React 19

## Using AI Agents

This template is optimized for AI-powered development:

1. **Write SPEC-TEMPLATE.md** in product manager language (NOT engineer language)
2. **Show the AI agent the SPEC.md** and let it:
   - Design the database schema
   - Create API endpoints
   - Build React components
   - Test everything automatically
3. **Review and merge** the AI's work to production

See `SPEC-TEMPLATE.md` for how to write specs for AI agents.

## Database (Neon + Prisma)

This template uses **Neon** (serverless PostgreSQL) for production and development:

- Free tier includes 3 projects with 3 GB storage
- Connection pooling included
- Zero setup for development
- Sign up: [neon.tech](https://neon.tech)

**Local development**: You can also use local PostgreSQL:
```bash
# macOS with Homebrew
brew install postgresql@15
brew services start postgresql@15

# Then update DATABASE_URL in .env.local
DATABASE_URL="postgresql://localhost/myapp_dev"
```

## Deployment

### Deploy to Vercel

1. Push to GitHub
2. Connect to [Vercel Dashboard](https://vercel.com)
3. Set `DATABASE_URL` env var in Vercel Settings
4. Deploy

### Deploy to Railway

1. Push to GitHub
2. Connect to [Railway Dashboard](https://railway.app)
3. Add PostgreSQL plugin
4. Railway auto-generates `DATABASE_URL`
5. Deploy

## Common Tasks

### Add a New Feature

1. Create a `SPEC.md` using `SPEC-TEMPLATE.md`
2. Show it to your AI agent
3. AI agent will:
   - Add database tables to `prisma/schema.prisma`
   - Create API routes in `src/app/api/`
   - Build UI in `src/app/` or `src/components/`
   - Write tests
   - Verify everything works

### Debug Database Issues

```bash
# Open visual database browser
npm run db:studio

# See all tables and data in GUI
```

### Run Tests

```bash
# Unit tests
npm run test

# Watch mode (re-run on file change)
npm run test:watch

# End-to-end tests (requires dev server running)
npm run test:e2e
```

## For Japanese Market

This template includes:

- `lang="ja"` in HTML (SEO for Japanese)
- UTF-8 encoding
- PostgreSQL (supports all Unicode characters)
- Ready for Japanese text content

## Support

- **Next.js**: [nextjs.org](https://nextjs.org)
- **Prisma**: [prisma.io](https://prisma.io)
- **Neon**: [neon.tech](https://neon.tech)
- **TypeScript**: [typescriptlang.org](https://typescriptlang.org)

## License

MIT
