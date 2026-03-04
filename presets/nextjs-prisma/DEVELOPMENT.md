# Development Guide for AI Agents

This guide is for Claude Code, Cursor, Codex, and other AI agents developing on this project.

## Project Structure

```
.
├── src/
│   ├── app/                  # Next.js App Router (pages, API routes)
│   │   ├── api/              # API endpoints (REST)
│   │   ├── layout.tsx        # Root layout
│   │   └── page.tsx          # Home page
│   ├── lib/                  # Shared utilities
│   │   ├── db.ts             # Prisma client singleton
│   │   └── env.ts            # Environment validation
│   └── components/           # Reusable React components
├── prisma/
│   ├── schema.prisma         # Database schema (Prisma)
│   └── migrations/           # Database migrations
├── __tests__/
│   ├── unit/                 # Unit tests (Vitest)
│   └── e2e/                  # End-to-end tests (Playwright)
├── .env.example              # Environment template
├── .env.local                # Local environment (git-ignored)
├── SPEC-TEMPLATE.md          # For product specs
└── DEVELOPMENT.md            # This file
```

## Development Workflow

### 1. Read the Current Spec

Before starting work:

```bash
cat SPEC.md
```

If `SPEC.md` doesn't exist, ask the human to create one using `SPEC-TEMPLATE.md`.

### 2. Implement in Order

Follow this order strictly:

1. **Database Schema** → Add tables to `prisma/schema.prisma`
2. **API Endpoints** → Create routes in `src/app/api/`
3. **React Components** → Build UI in `src/components/` or `src/app/`
4. **Tests** → Write tests for your code
5. **Verify** → Run the full verification suite

### 3. Database Schema Rules

**Schema location**: `prisma/schema.prisma`

**Adding a new table**:

```prisma
model Product {
  id        String   @id @default(cuid())
  name      String
  price     Int      // in cents (use Int for precision)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@map("products")
}
```

**Migration**:

```bash
npm run db:push
```

**No migration files needed** for development (Neon free tier doesn't require formal migrations).

### 4. API Endpoints

**Location**: `src/app/api/{feature}/route.ts`

**Pattern**:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { db } from "@/lib/db";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    // Validate input
    if (!body.name) {
      return NextResponse.json({ error: "Name is required" }, { status: 400 });
    }

    // Create in database
    const product = await db.product.create({
      data: { name: body.name, price: body.price },
    });

    return NextResponse.json(product, { status: 201 });
  } catch (error) {
    console.error("Error creating product:", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

export async function GET() {
  try {
    const products = await db.product.findMany();
    return NextResponse.json(products);
  } catch (error) {
    console.error("Error fetching products:", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
```

**Testing endpoint**:

```bash
# Normal case
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Apple","price":100}'

# Error case
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{}'
```

### 5. React Components

**Location**: `src/components/` or directly in `src/app/`

**Pattern** (functional component with data fetching):

```typescript
"use client";

import { useEffect, useState } from "react";

interface Product {
  id: string;
  name: string;
  price: number;
}

export default function ProductList() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch("/api/products")
      .then((res) => res.json())
      .then((data) => {
        setProducts(data);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  if (loading) return <div>読み込み中...</div>;
  if (error) return <div>エラー: {error}</div>;

  return (
    <ul>
      {products.map((p) => (
        <li key={p.id}>
          {p.name} - ¥{(p.price / 100).toFixed(2)}
        </li>
      ))}
    </ul>
  );
}
```

### 6. Testing

**Unit tests** (Vitest):

```bash
npm run test
```

**E2E tests** (Playwright):

```bash
npm run test:e2e
```

**Example unit test**:

```typescript
// __tests__/utils.test.ts
import { describe, it, expect } from "vitest";

describe("utility functions", () => {
  it("should format price correctly", () => {
    expect((100).toFixed(2)).toBe("100.00");
  });
});
```

**Example E2E test**:

```typescript
// __tests__/e2e/products.e2e.ts
import { test, expect } from "@playwright/test";

test("user can view products", async ({ page }) => {
  await page.goto("/");
  const heading = await page.locator("h1");
  await expect(heading).toContainText("Products");
});
```

### 7. Verification Checklist

Before declaring done:

```bash
# 1. Type check
npm run check

# 2. Tests pass
npm run test
npm run test:e2e

# 3. Dev server starts
npm run dev

# 4. No console errors
# (open browser, check DevTools)

# 5. Commit with semantic message
git add -A
git commit -m "feat: add product listing"
```

## Common Tasks

### Add a new API endpoint

1. Create `src/app/api/feature/route.ts`
2. Implement GET/POST/PUT/DELETE handlers
3. Test with curl
4. Add to `__tests__/e2e/` if user-facing
5. Commit

### Add a new React component

1. Create `src/components/FeatureName.tsx`
2. Export from `src/components/index.ts` (if shared)
3. Test in page or other component
4. Add E2E test if user-facing
5. Commit

### Update database schema

1. Modify `prisma/schema.prisma`
2. Run `npm run db:push`
3. Run `npm run db:generate` (usually automatic)
4. Restart dev server
5. Commit

### Debugging

**View database**:

```bash
npm run db:studio
```

This opens a visual database browser at http://localhost:5555

**Check logs**:

```bash
# Terminal output shows all API calls in development
npm run dev
```

**Browser console**:

- Open DevTools (F12)
- Check Console for errors
- Check Network for failed requests

## Code Standards

### Imports

Use path aliases:

```typescript
// ✅ Good
import { db } from "@/lib/db";
import ProductList from "@/components/ProductList";

// ❌ Avoid
import { db } from "../../../lib/db";
```

### Error Handling

```typescript
// ✅ Good
try {
  const user = await db.user.findUnique({ where: { id } });
  if (!user) return NextResponse.json({ error: "Not found" }, { status: 404 });
} catch (error) {
  console.error("Error fetching user:", error);
  return NextResponse.json({ error: "Internal server error" }, { status: 500 });
}

// ❌ Avoid
const user = await db.user.findUnique({ where: { id } });
```

### TypeScript

Enable strict mode (already configured):

```typescript
// ✅ Good - explicit types
const products: Product[] = [];
const handleClick = (e: React.MouseEvent) => {};

// ⚠️ Avoid - implicit any
const products = [];
const handleClick = (e) => {};
```

### Japanese Text

UTF-8 is fully supported:

```typescript
// ✅ Good
const message = "商品が見つかりません";
return <p>読み込み中...</p>;

// ✅ Also good (use English for code, Japanese for UI)
const productNotFound = "Product not found";
return <p>商品が見つかりません</p>;
```

## Environment Variables

**Development**:

- Create `.env.local` (git-ignored)
- Copy from `.env.example`
- Update with your Neon credentials

**Production**:

- Set env vars in Vercel/Railway dashboard
- Never commit `.env.local`
- Never hardcode secrets

## Deployment

### Preview (on PR)

- Automatically deployed to Vercel Preview
- URL provided in PR

### Production (merge to main)

- Manually promoted from `dev` to `main`
- Vercel auto-deploys
- Database migrations applied automatically

## Getting Help

- **TypeScript**: https://www.typescriptlang.org/docs/
- **Next.js**: https://nextjs.org/docs
- **Prisma**: https://prisma.io/docs
- **React**: https://react.dev
- **Vitest**: https://vitest.dev
- **Playwright**: https://playwright.dev

## Key Reminders

1. **Always read SPEC.md first** — it's the source of truth
2. **Test before committing** — run all tests and verify in browser
3. **Use semantic commits** — `feat:`, `fix:`, `test:`, `docs:`, etc.
4. **No hardcoded values** — use `.env` for all config
5. **Validate user input** — never trust frontend data
6. **Log errors properly** — `console.error()` for debugging
7. **Use path aliases** — `@/` for all imports
8. **Keep it simple** — YAGNI (You Aren't Gonna Need It)
