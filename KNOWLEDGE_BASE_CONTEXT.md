# Knowledge Base Context

Your AI Brain Assistant loads comprehensive context about you from the knowledge base on every conversation.

## What Context Is Loaded (Current)

### ✅ Loaded Every Time

**1. Profile** (`context/profile.md` - 115 lines, 4.1KB)
- Your role and title
- Responsibilities and expertise
- Team structure
- Working style and preferences

**2. Current Initiatives** (`context/work/current-initiatives.md` - 228 lines, 7.6KB)
- All 7 active projects:
  - Tenant DR (Disaster Recovery)
  - FD Split (Functional Domain Split)
  - GCP Migration
  - AWS Cost Optimization
  - OOR-DD/OOR-DR Planning
  - MC Account Separation
  - Private Connect
- Project status, priorities, timelines
- Key stakeholders per project
- Current phase and next steps

**3. Stakeholder Map** (`context/communication/stakeholder-map.md` - 378 lines, 11KB)
- Key people you work with
- High-priority Slack channels
- Teams and reporting structure
- Communication patterns

**4. Tone of Voice** (`context/tone-of-voice.md` - 287 lines) ✨ NEW!
- Your communication style and preferences
- How you write emails, Slack messages, docs
- Tone and formality levels
- Examples of your writing

**5. Technical Domains** (`context/work/technical-domains.md` - 319 lines) ✨ NEW!
- Technologies you work with (AWS, GCP, Kubernetes, etc.)
- Systems and platforms (Data Cloud, Hyperforce, etc.)
- Architecture patterns you use
- Tools and frameworks you're familiar with

**6. Today's Summary** (`summaries/daily/start-day-2026-05-23.md` - 2.8KB)
- 🔥 Most urgent items for today
- 📅 Today's calendar with meeting context
- 💬 Overnight Slack activity
- ✅ Follow-ups from yesterday
- 📊 Active projects status
- 🎯 Today's focus areas

**Total Context: ~1,327 lines, ~40KB of your work context loaded per conversation**

## What the Assistant Knows About You

From this context, the assistant knows:

### Your Role
- Senior Staff Software Engineer / Principal Architect
- Data Cloud Functional Domain
- Architecture governance and review
- Cross-team coordination

### Your Current Work
- All 7 active projects (status, priority, stakeholders)
- Today's urgent items (WASL Restoration, OOR-DD Planning)
- Your calendar for today (meetings, attendees, context)
- Recent Slack activity in your high-priority channels

### Your Network
- Direct reports and managers
- Key collaborators (Alexey, Fangchao, Moe, etc.)
- Important Slack channels you monitor
- Team structure (CTS, Platform Eng, Data Cloud)

### Your Priorities
- What's urgent vs. important
- Project deadlines
- Follow-up items
- Technical focus areas (DR, cost optimization, architecture)

## What's NOT Loaded Yet (Phase 1 TODO)

⏳ **Not implemented yet:**
- Technical domains (specific technologies, patterns)
- Decision history (past ADRs)
- Weekly/quarterly summaries (historical context)
- Meeting notes (detailed past discussions)
- Conversation history across app restarts

## How Context is Used

When you ask a question, the assistant:

1. **Loads all 4 context files** (profile, initiatives, stakeholders, today's summary)
2. **Builds a system prompt** with your full context
3. **Sends your question + context** to Claude API
4. **Claude responds** using your specific work context

### Example Queries

**You ask:** "What should I focus on today?"

**Assistant knows:**
- Your role (architect, not IC)
- Today's urgent items (WASL Restoration at 7:30 AM, OOR-DD Planning overdue)
- Your active projects (7 projects, their priorities)
- Your calendar (meetings today with attendees)
- Your stakeholders (who to coordinate with)

**Response will be:** Prioritized list based on YOUR specific work, not generic advice.

---

**You ask:** "Who should I talk to about MC2 architecture?"

**Assistant knows:**
- Your stakeholder map (Alexey is your main contact)
- Recent meetings (MC2 discussion on May 22)
- Your role (you lead architecture discussions)

**Response will be:** Specific person with context from your recent interactions.

## Enhancing Context (Future)

Want the assistant to know more? Add to your knowledge base:

### Phase 2 Enhancements
- **Load technical-domains.md** - Technologies, patterns you work with
- **Load decision-frameworks.md** - How you make decisions
- **Load end-day summaries** - Yesterday's follow-ups
- **Load weekly summaries** - Week-over-week trends

### Phase 3 Enhancements
- **Conversation persistence** - Remember past chats across restarts
- **Historical lookback** - "What did I work on last week?"
- **Cross-reference** - "Show me all OOR-DR discussions"
- **Learning** - Adapt to your communication style over time

## Verifying Context Loading

To see if context is loading correctly:

```bash
# Check files exist
ls -lh ~/knowledge-base/context/profile.md
ls -lh ~/knowledge-base/context/work/current-initiatives.md
ls -lh ~/knowledge-base/context/communication/stakeholder-map.md
ls -lh ~/knowledge-base/summaries/daily/start-day-$(date +%Y-%m-%d).md

# Read a file to see what's there
cat ~/knowledge-base/context/profile.md
```

## Current Context Size

**Approximate token usage:**
- Profile: ~1,000 tokens
- Current Initiatives: ~2,000 tokens
- Stakeholder Map: ~3,000 tokens
- Today's Summary: ~800 tokens
- **Total: ~6,800 tokens of context per conversation**

This is sent with EVERY message to Claude, so the assistant always has your full work context.

---

**TL;DR:** Your AI Brain knows:
- ✅ Who you are (role, responsibilities, expertise)
- ✅ What you're working on (7 projects, status, priorities)
- ✅ Who you work with (stakeholders, teams, channels)
- ✅ What's urgent today (calendar, follow-ups, priorities)

**Total: ~25KB of your work context loaded on every conversation.**
