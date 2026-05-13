# Context-First — Product Mechanism Summary

## North star
Linkaroo does not add features for migrants — it filters what's already there based on *who* is reading. The same Q&A thread reads differently to a Sydney student who landed last week vs. a five-year resident with a working visa, because each carries a different *context* (identity, urgency, language, location).

This document captures the five places that filter shows up in the iOS prototype.

---

## 1. Identity awareness — onboarding as the first context capture

**Where**: `Pages/OnboardingView.swift` (write) + `Pages/ProfileView.swift` (read-back + edit)

**What it captures**: preferred language → current status (immigrant student / working / job-seeker / business owner) → location (city + state) → time-in-Australia bucket (not yet arrived / just landed / 1–6 months / 6–12 months / 1 year+).

**Why it matters**: every downstream feed (Home recommendations, Q&A relevance ranking, volunteer matches) reads from this profile. The onboarding form is short and warm rather than long and exhaustive — language as a meta-barrier means the entry-gate itself can't feel like an interrogation.

**Read-back symmetry**: the captured identity is silently consumed everywhere except the **Profile tab**, which is the one surface that makes the identity visible to the user. Editing the profile re-enters `OnboardingView` with the current ABUser prefilled — the same form that wrote the identity is the form that updates it, so identity capture stays single-sourced and any new field automatically appears on both surfaces.

---

## 2. Contextual home hub — push, not pull

**Where**: `Pages/HomeView.swift`

**What changes**: the "Recommended for you" feed and "Featured Guide" card are pre-filtered against the onboarding profile. A student in their first 30 days sees the *First 7 Days Checklist*; a working migrant sees workplace-rights material first.

**Why it matters**: the discovery gap surfaced in user research ("I only knew about that service because a friend mentioned it") is a *pull* failure. Context-First reverses it — the app pushes what likely matches.

---

## 3. Granular metadata tags — credibility made visible

**Where**: `Components/ABTag.swift` + `Pages/QADetailView.swift` + `Pages/QAListView.swift`

**Tag taxonomy** (ABContentTagType in `Models/ABModels.swift`):
- **STUDENT MATCH / SENIOR MATCH** — context match (light blue) — content fits your identity.
- **GOVERNMENT VERIFIED** — verified (solid green) — institutional source confirmed.
- **TOP ANSWER / TOP ADVICE** — community endorsement (gold / amber).
- **UNVERIFIED / SOURCE: TIKTOK** — warning (amber) — anecdotal origin.
- **OLD LAW** — error/outdated (red, strikethrough) — formerly correct, now wrong.
- **NEW / NEWCOMER** — recency (light green).

**Why it matters**: language as a meta-barrier means non-native readers can't always parse credibility cues from prose alone. Visual tags make the *who-said-this* and *when* layers parseable at a glance, without forcing the reader to evaluate sentence-by-sentence.

---

## 4. Reason-based volunteer matching — algorithms, made legible

**Where**: `Pages/VolunteerMatchView.swift`

**What it shows**: every match displays a `matchPercentage` *plus* a list of explicit `matchReasons` (e.g. "Same university background", "Housing expertise matches your need"). The hero card uses these to scaffold a "Why she's a match for you" block.

**Why it matters**: volunteers are humans — being matched without explanation feels random or paternalistic. Surfacing reasons turns the match into an introduction, not an algorithm output. This also lets users *correct* a bad match by recognising which reason doesn't apply.

---

## 5. Context-aware chat — handoff that doesn't reset

**Where**: `Pages/ChatView.swift` + `Components/ABSharedContextCard.swift`

**What it does**: when a user escalates from a Q&A thread to a 1-on-1 chat, the originating Q&A post is auto-mounted at the top of the conversation as a "Shared Context" card. Action pills (`Components/ABActionPill.swift`) offer one-tap shortcuts: *Share My Profile Tags* / *Ask about the Q&A post* / *Suggest a 5-min call*.

**Why it matters**: the original research surfaced a recurring pattern — every new conversation requires the migrant to *re-explain who they are and what they're asking*. That re-introduction is where give-up happens. Mounting context preserves the work the user already did during onboarding.

---

## How the five mechanisms relate

```
                 ┌─────────────────────────────┐
                 │   Onboarding (mechanism 1)  │◄────────┐
                 └─────────────┬───────────────┘         │
                               │  identity profile       │
                               ▼                          │
            ┌────────────────────────────────────────┐    │
            │  Filtered home + Q&A feeds (m. 2 + 3)  │    │
            └────────────────────┬───────────────────┘    │
                                 │  selected Q&A post     │
                                 ▼                         │
            ┌────────────────────────────────────────┐    │
            │ Volunteer match w/ visible reasons (m. 4) │  │
            └────────────────────┬───────────────────┘    │
                                 │  matched volunteer +   │
                                 │  originating post      │
                                 ▼                         │
            ┌────────────────────────────────────────┐    │
            │  Chat with auto-mounted context (m. 5) │    │
            └────────────────────────────────────────┘    │
                                                          │
                 ┌─────────────────────────────┐          │
                 │   Profile  (m. 1 read-back) │──────────┘
                 │   reads ABUser ← AppState   │  edit re-enters
                 │   "Edit profile" → §1       │  Onboarding (prefilled)
                 └─────────────────────────────┘
```

The user's identity flows through the system as data, not as something they must re-state at each step. That is the thesis: **context is plumbing, not a re-explanation tax.** The Profile tab is the one place the plumbing surfaces — making the captured identity visible *and* edit-able through the same form that captured it.
