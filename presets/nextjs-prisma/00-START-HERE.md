# Next.js + Prisma + Neon Preset — START HERE

Welcome! This is a **production-ready skeleton** for building web applications targeting the Japanese market using AI agents (Claude Code, Cursor, Codex).

## What You Have

A complete tech stack ready to go:

- **Next.js 15** - Modern React framework
- **Prisma 6** - Type-safe database ORM
- **PostgreSQL (Neon)** - Serverless database
- **TypeScript** - Strict mode enabled
- **Vitest + Playwright** - Automated testing
- **Zod** - Input validation

All configured for AI-powered development.

## Quick Start (5 minutes)

### 1. Copy This to Your Project

```bash
cp -r . ~/my-awesome-app
cd ~/my-awesome-app
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Set Up Database

Create `.env.local`:

```env
DATABASE_URL="postgresql://user:pass@host/dbname"
NEXT_PUBLIC_APP_URL="http://localhost:3000"
NODE_ENV="development"
```

Get a free PostgreSQL database at [neon.tech](https://neon.tech)

Initialize:

```bash
npm run db:push
```

### 4. Start Development

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) - you should see the home page.

### 5. Write Your Spec

Create a file called `SPEC.md` using the template:

```bash
cp SPEC-TEMPLATE.md SPEC.md
# Edit SPEC.md with your feature ideas (in product manager language, not engineer language)
```

### 6. Show Your Spec to an AI Agent

Paste your `SPEC.md` into Claude Code, Cursor, Codex, or similar AI tool and ask it to build your feature. The AI will:

- Design the database schema
- Create API endpoints
- Build React components
- Write and run tests
- Verify everything works

You just review and merge.

## Which File Should I Read?

| I want to... | Read this |
|---|---|
| Understand what's in this preset | **README.md** |
| Write a product spec for AI | **SPEC-TEMPLATE.md** |
| Guide AI agents during development | **DEVELOPMENT.md** |
| Configure the environment | **.env.example** |
| Check API health | Visit `/api/health` in browser |
| View the database visually | `npm run db:studio` |
| Run tests | `npm run test` |
| Deploy to production | See README.md Deployment section |

## Project Structure

```
presets/nextjs-prisma/
├── 📄 package.json              ← Dependencies
├── 📄 tsconfig.json             ← TypeScript config
├── 📄 next.config.ts            ← Next.js config
├── 📄 SPEC-TEMPLATE.md          ← Write your features here
│
├── prisma/
│   └── schema.prisma            ← Database tables
│
├── src/
│   ├── app/
│   │   ├── layout.tsx           ← Root HTML
│   │   ├── page.tsx             ← Home page
│   │   ├── globals.css          ← Global styles
│   │   └── api/
│   │       └── health/          ← API endpoints
│   │
│   └── lib/
│       ├── db.ts                ← Database client
│       └── env.ts               ← Environment config
│
├── __tests__/
│   └── health.test.ts           ← Sample test
│
├── .env.example                 ← Environment template
├── .gitignore                   ← Git ignore
├── README.md                    ← Full docs
└── DEVELOPMENT.md               ← Guide for AI agents
```

## Available Commands

| Command | What it does |
|---------|------------|
| `npm run dev` | Start dev server (localhost:3000) |
| `npm run build` | Build for production |
| `npm run start` | Start production server |
| `npm run check` | Check TypeScript |
| `npm run test` | Run tests |
| `npm run test:watch` | Tests in watch mode |
| `npm run test:e2e` | End-to-end tests |
| `npm run db:push` | Sync database schema |
| `npm run db:studio` | Visual database browser |
| `npm run db:migrate` | Create migration |
| `npm run lint` | Check code style |

## Key Design Decisions

### 1. AI-First Development

- **You write specs** in product manager language
- **AI agents code** the entire feature
- **You review** and merge

No need to learn to code.

### 2. Type Safety

- TypeScript everywhere (strict mode)
- Zod for runtime validation
- Prisma for database types

Catch bugs before users do.

### 3. Testing Built-In

- Unit tests (Vitest)
- End-to-end tests (Playwright)
- Health check API

Everything is verifiable.

### 4. Japanese Market Ready

- `lang="ja"` for SEO
- UTF-8 by default
- Full Unicode support
- Ready for Japanese users

### 5. Deployment Ready

- Works on Vercel (1-click)
- Works on Railway
- Environment-safe config
- No hardcoded secrets

## Common Questions

**Q: Do I need to code?**

A: No. Write your feature spec in `SPEC-TEMPLATE.md`, show it to Claude Code or Cursor, and it will code everything.

**Q: What about the database?**

A: Free tier on [neon.tech](https://neon.tech) includes 3 GB storage. Perfect for starting.

**Q: How do I deploy?**

A: Connect to [Vercel](https://vercel.com) or [Railway](https://railway.app), set `DATABASE_URL` env var, and deploy. Takes 5 minutes.

**Q: Can AI really build my whole app?**

A: Yes, if you provide a clear SPEC.md. See `SPEC-TEMPLATE.md` for the right format.

**Q: What if something breaks?**

A: Show the error to your AI agent and ask it to fix it. It can debug faster than humans.

**Q: Can I add more features later?**

A: Yes. Just write a new `SPEC.md` for the next feature and repeat. The AI can extend your app incrementally.

## First Feature Example

### Step 1: Write SPEC.md

```markdown
# Blog Feature Specification

## What is this?
A simple blog where users can write and publish posts.

## Who uses it?
Japanese office workers who want to share updates with coworkers.

## User Journey
1. User logs in with email/password
2. User sees list of all blog posts (newest first)
3. User clicks "New Post" and writes a title + content
4. User clicks "Publish" and post appears on feed
5. Other users see the new post and can Like/Comment

## Must-Have Features
- [ ] User login/logout
- [ ] Write and publish posts
- [ ] View all posts in a feed
- [ ] Like posts
- [ ] Comment on posts
```

### Step 2: Show to AI Agent

Copy the SPEC into Claude Code and ask:

> Build this blog feature following the SPEC.md. Include database schema, API endpoints, React components, and tests.

### Step 3: Review the Work

The AI will:
- Create database tables in `prisma/schema.prisma`
- Create API routes in `src/app/api/`
- Create React components in `src/app/` or `src/components/`
- Write tests in `__tests__/`
- Commit everything

### Step 4: Verify

```bash
npm run test          # Run all tests
npm run dev          # Start dev server
```

Visit [http://localhost:3000](http://localhost:3000) and use your new blog.

### Step 5: Deploy

Push to GitHub and Vercel auto-deploys. Your blog is live.

## Next Steps

1. **Read README.md** — Full documentation
2. **Copy .env.example to .env.local** — Configure database
3. **Create SPEC.md** — Write your first feature
4. **Show SPEC.md to AI agent** — Ask it to build
5. **Review and merge** — Verify it works

## Support Resources

- **Next.js**: https://nextjs.org/docs
- **Prisma**: https://prisma.io/docs
- **Neon**: https://neon.tech/docs
- **TypeScript**: https://typescriptlang.org/docs
- **React**: https://react.dev

## You're Ready!

This is a complete, production-grade skeleton. Everything you see here was built with AI agents in mind.

The only thing missing is your ideas. Write your first `SPEC.md` and let's build something great.

---

**Questions?** Read DEVELOPMENT.md (for AI agents) or README.md (for everyone).

**Ready to start?** Run `npm install && npm run dev` and visit http://localhost:3000!
