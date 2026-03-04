# [Product Name] — What I Want to Build

> This is a template for writing product specifications in a way that AI agents (Claude Code, Cursor, Codex) can understand.
>
> **Important**: Write this in **product manager language**, NOT engineer language. Describe WHAT you want, not HOW to build it.
>
> Replace all bracketed sections [like this] with your own content, then delete this instruction.

## What is this?

[One sentence: what does this product do? Who does it serve?]

**Example**: "A Japanese blog platform where office workers can publish daily thoughts and get feedback from coworkers."

---

## Who uses it?

[Describe your target user in 2-3 sentences]

**Example**:
- Japanese office workers aged 25-40
- Busy schedules, write during lunch breaks
- Want to share life updates with work friends
- Value privacy (not public internet)

---

## How do they use it? (User Journey)

[Walk through the step-by-step journey. Use simple language.]

**Example**:
1. User opens the home page and sees a login box
2. User enters email and password to log in
3. User sees a list of blog posts by their coworkers
4. User clicks "New Post" button
5. User writes title + text + clicks "Publish"
6. Post appears on the feed instantly
7. Other users see it and click "Like" or "Comment"
8. Original author gets a notification

---

## Reference Products

[List 2-3 products that have features you like. Paste the URL.]

**Example**:
- [Substack](https://substack.com) — I like how simple the editor is
- [Twitter](https://twitter.com) — I like the notifications system
- [Notion](https://notion.so) — I like the rich text formatting options

---

## Must-Have Features (Version 1)

[Checklist of core features you absolutely need. Be specific.]

**Example**:
- [ ] User registration with email + password
- [ ] User login/logout
- [ ] Write and publish blog posts (title + text)
- [ ] View all posts in a feed (newest first)
- [ ] Like/unlike posts
- [ ] Comment on posts
- [ ] See comment notifications
- [ ] Delete my own posts
- [ ] Edit my own posts

---

## Nice-to-Have (Version 2 or Later)

[Features that would be cool but not required for launch]

**Example**:
- [ ] Follow specific users
- [ ] Hashtags
- [ ] Post scheduling (publish at specific time)
- [ ] Dark mode
- [ ] Mobile app
- [ ] Email digests of popular posts
- [ ] User profile page with bio

---

## Things I Do NOT Want

[Be explicit about what to exclude. This helps the AI avoid unnecessary features.]

**Example**:
- No public access (must be logged in to view)
- No ads or sponsored content
- No video uploads (text + links only)
- No groups or communities (just individual users for now)
- No payment system

---

## Design Preferences

### Style

[Pick one or describe your preference]

- Modern and clean (minimal colors, whitespace)
- Minimal (dark mode, professional)
- Cute (colorful, friendly, emoji-friendly)
- Professional (corporate, formal)
- Japanese aesthetic (understanding of Japanese design principles)

**Example**: "Modern and clean. Think of Apple or Stripe design. Lots of whitespace. Friendly but not cutesy."

### Colors

[Any color preference?]

**Example**: "Blue and white. Avoid red/orange."

### Mobile First?

[Yes / No]

**Example**: "Yes, designed for smartphone first, then desktop."

---

## Data Validation Rules

[Any specific rules about what users can enter?]

**Example**:
- Post title: max 100 characters
- Post text: max 5000 characters
- Comments: max 500 characters
- Email must be valid format
- Passwords must be at least 8 characters

---

## Estimated Timeline

[How soon do you want this? This helps the AI prioritize.]

- Urgently (next 1-2 days)
- Soon (next 1-2 weeks)
- Flexible (whenever)

**Example**: "I need a working version in 1 week to show investors."

---

## Deployment & Hosting

[Where should this run?]

- Free (Vercel or Railway free tier)
- Paid (doesn't matter)
- Specific requirement?

**Example**: "Free tier is fine for MVP. Can upgrade later."

---

## Additional Notes

[Anything else the AI should know?]

**Example**:
- "The company email domain is @company.jp, but not everyone has it yet"
- "The database might have user data from another system, so be careful with migrations"
- "Japanese text must be fully supported (no mojibake)"
- "Loading time matters a lot to us"

---

## Approval Checklist (For You)

Before you share this with an AI agent, make sure:

- [ ] I've filled in all sections (or marked as N/A)
- [ ] This describes WHAT I want, not HOW to build it
- [ ] The user journey is clear and specific
- [ ] Must-have features are realistic for 1-2 weeks of work
- [ ] I don't have conflicting requirements (e.g., "free" but "high uptime SLA")

---

## How to Use This

1. Copy this template into a new file called `SPEC.md`
2. Fill in each section with your own content
3. Delete the examples and instructions
4. Share `SPEC.md` with your AI agent (Claude Code, Cursor, Codex)
5. The AI agent will:
   - Ask clarifying questions if needed
   - Design the database (Prisma schema)
   - Build the API endpoints
   - Create the React UI
   - Write tests
   - Verify everything works

**The AI will NOT ask you to do any technical work.** Your job is to write the spec and review the results.

---

## Example Completed Spec

See `/presets/nextjs-prisma/examples/SPEC-COMPLETED.md` for a real example.
