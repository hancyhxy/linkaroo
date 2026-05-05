# Checkpoint 3 · Semi-Functional Prototype — content draft

> **How to use this file**
> Copy each section into the corresponding cell of `Checkpoint3Template_Updated.docx`. Field labels match the template verbatim. Screenshots / video links are placeholders — replace with your own captures before submitting.

---

## Value Branch — Context-First

**Student Name** Xinyi Han
**Student ID** _[fill in]_

---

## 1. Overview

AussieBridge is a Sydney-newcomer support platform that combines **community Q&A** (categorised, credibility-tagged) with **1-on-1 volunteer matching**. The team's shared concept is to give recently-arrived migrants a faster, friendlier path through housing, visa, healthcare, and the dozen other services that hit them in the first six months.

My personal value branch is **Context-First** — instead of treating user identity / location / urgency as profile *features*, I treat them as a *filter* that the same content flows through. So a Bahasa-speaking student renting in Sydney sees the *same* Q&A post differently from a Hindi-speaking working professional in Melbourne: matched volunteers come pre-tagged with "why she's a match," visa posts hide outdated NSW-only rulings, the chat handoff carries the originating Q&A as a visible card so the volunteer doesn't ask "what's your question again?". The variation matters because the user research insight that drove this — *"language is a meta-barrier"* — is not solved by translation alone; it's solved by **gating that is visible, not algorithmic**. Context-First makes the filter legible at every screen so the user can trust why they're seeing what they're seeing.

---

## 2. Iterations

### 2.1. First Iteration — Concept & Visual

**Tools Used** Google Stitch (auto-generated 9 page designs + design spec) · Pen & paper concepting · Claude Code

**What was Made** A first-pass visual + 9-page click-flow generated through Google Stitch from the team-defined Context-First concept brief. Stitch produced both screen mockups and an auto-generated design specification (typography, colour, spacing) that we copy-pasted verbatim into `docs/design.md`. I converted each Stitch screenshot into a static HTML mockup (kept in `docs/mockups/personalization.html`, `homepage.html`, `community.html`, `qa.html`, `qa_scroll.html`, `volunteer.html`, `message.html`, `chat.html`, `profile.html`) so the visual contract was reproducible outside Stitch.

**How the previous iteration shaped this** Carried forward: the team-level "context as filter" mechanism statement from Checkpoint 1 (`docs/product-context.md` — the 5 Context-First mechanisms). Discarded: any direction that treated language as a feature toggle rather than a meta-barrier — the user-research quote "language is a meta-barrier" became the test for every visual decision (typography line-height, tag credibility hierarchy, visible match-reasons).

**What/Who Influenced this Decision** Checkpoint 1 user-research interview transcript (the *meta-barrier* quote, captured verbatim). Google Stitch's design system output gave the visual grammar but not the structural hierarchy — that I had to author.

**Screenshot / Video Demo Link / Prototype Link**
_[paste Stitch HTML screenshot here — recommend `docs/mockups/personalization.html` rendered in browser]_

---

### 2.2. Second Iteration — Spec & Component Definition

**Tools Used** Claude Code · Markdown · SwiftUI Canvas

**What was Made** Three written specs (`docs/design.md` calibrated, `docs/struct.md` 22-entity data model, `docs/spec.md` per-page 4-block template covering §1–§9) + a 32-component SwiftUI library (`ABDesignSystem/Sources/Components/AB*.swift`) so spec.md regions resolve to real Swift types rather than free-form decisions. The 4-block template for each page (Overview / Parameters / Actions / Layout) sets a wireframe-precision contract before any code lands.

**How the previous iteration shaped this** Carried forward: the Stitch visual grammar (kept as fidelity reference). Discarded: relying on Stitch's auto-generated text — every copy string was re-authored against the user-research vocabulary (e.g., "Match a volunteer," not Stitch's generic "Get help"). Added: a Components/ layer that didn't exist in Stitch, because Stitch produces page artefacts but not reusable building blocks.

**What/Who Influenced this Decision** The realisation that Stitch's output, while visually competent, didn't *bind* the data model — `docs/struct.md` had to be authored separately and then traced back into the design.md vocabulary.

**Screenshot / Video Demo Link / Prototype Link**
_[paste Xcode Canvas screenshot of any AB* Component preview — recommend ABSelectionCard or ABQAPostCard]_

---

### 2.3. Third Iteration — Spec-Driven Prototypes (V1→V4)

**Tools Used** Claude Code · SwiftUI Canvas (`#Preview` mode) · Markdown SPEC GAP markers

**What was Made** 14 spec-driven prototypes living in `ABDesignSystem/Sources/Prototypes/`. Onboarding (§1) and Home (§2) each got 4 versions (V1→V4); §3 Community / §4 Q&A List / §5 Q&A Detail / §6 Volunteer Match / §7 Message List / §8 Chat got a single V4 each since the workflow had stabilised. §9 Profile graduated directly to `Pages/` without a prototype ladder — by the time it was implemented the workflow itself had been validated, so the V1→V4 ladder no longer added information for that page. Each prototype was re-implemented *strictly from `docs/spec.md`* without reading the corresponding `Pages/*View.swift`. Every place the spec was insufficient got a `// SPEC GAP` marker, which fed back into spec.md and the component library — most visibly: the split of `ABBackBar` + `ABPageHero` out of the early monolithic `ABHeader`, because V3 of Onboarding exposed that "back chevron" and "page hero headline" had been forced into one component when the mockup clearly separated them.

**How the previous iteration shaped this** Carried forward: spec.md's 4-block template (the prototypes were the test of whether it was sufficient). Discarded: any attempt to "freeze" components early — V1→V4 deliberately surfaced gaps that closed by amending spec.md and Components/, then iterating again.

**What/Who Influenced this Decision** The methodological commitment that spec-driven means *the spec must be sufficient* — if a prototype implementer needs to self-pick a token, that's a spec bug, not a coding bug. The two pages with full V1→V4 ladders are evidence of where the workflow was being invented.

**Screenshot / Video Demo Link / Prototype Link**
_[paste Xcode Canvas side-by-side of `OnboardingPrototypeV1View` vs `OnboardingPrototypeV4View` — recommend showing the back-bar + page-hero split that V3 forced]_

---

### 2.4. Fourth Iteration — Functional iOS App

**Tools Used** Claude Code · Xcode · XcodeGen (declarative `project.yml` → `.xcodeproj` generation) · iOS 17 Simulator (iPhone 16 Pro) · Apple SwiftUI standard libs (NavigationStack, `@Observable`, `.environment`)

**What was Made** A standalone iOS App Target (`AussieBridgeApp/`) that consumes the `ABDesignSystem` Swift Package as a local dependency. The transformation lands in two phases.

*Phase A — App shell & routing.* Four commits stand up the runnable app: (1) `chore(api): expose ABDesignSystem types as public` — 47 files upgraded so the App Target can reference Models/Tokens/Components/Pages by name; (2) `feat(app): scaffold iOS App Target` — `@main App`, `AppState` (@Observable), `Route` enum, `RootView` onboarding-gate, `MainTabView` 4-tab shell; (3) `feat(pages): parameterize navigation hooks via closures` — every Page replaces its 27 previous "[open §12]" placeholder closures with explicit closure parameters on its public init, so pages stay self-contained; (4) `feat(app): wire 4 tabs with NavigationStack routing` — each tab gets its own NavigationStack(path:) backed by AppState, with `navigationDestination(for: Route.self)` for value-driven routing. Cross-tab handoff implemented (VolunteerMatch → Chat hops Home tab → Messages tab; Chat's shared-context card hops back). The `#Preview` blocks still work — Pages remain renderable in isolation.

*Phase B — §9 Profile + §3 Community alignment.* Three commits close the loop on identity surfaces: (5) `feat(profile): add §9 Profile page and Edit profile loop` — `ProfileView` is the read-back surface for the captured ABUser (centered identity hero + 4-field card + compact "Why we ask" provenance row + Edit profile button), and `OnboardingView` gains an optional `prefilledUser` parameter so the Edit profile button re-enters the same form with current values prefilled (single-source identity capture, see `docs/spec.md` §11.4); (6) `refactor(community): simplify §3 to a single hub` — the earlier Discussions / People-to-help segmented control was a layered duplication of what the bottom tab bar already provides, so CommunityView is now one body (people-you-can-help carousel above questions-you-can-answer list) and Messages remains a separate bottom tab; (7) `docs(readme): align to 9 pages and document Stage 4` — README updated with a Pages index table, AussieBridgeApp/ tree, and a new Stage 4 row in the workflow diagram.

**How the previous iteration shaped this** Carried forward: every visual / typography / copy decision from V4 prototypes, untouched. Carried forward: the 27 `[open §12]` markers that V4 graduation had inherited — they pointed at exactly which closures needed real bindings. Discarded: nothing — the 4-layer architecture (tokens → components → models → pages) survived intact, the App Target only adds the orchestration layer above Pages.

**What/Who Influenced this Decision** The Checkpoint 3 rubric requirement to demonstrate *"essential core features that effectively demonstrate intended functionality for user stories."* The Context-First mechanism in `docs/product-context.md` §10.3 — "shared-context handoff" — only makes sense when state crosses pages, which only happens with an `AppState` and routing. So the App Target wasn't decoration; it was the only level at which the Context-First story is actually testable. The §1 ↔ §9 round-trip (Onboarding writes ABUser, Profile reads it back, Edit profile re-enters Onboarding to update it) is the runtime evidence that mechanism 1 (identity awareness) is end-to-end wired, not just claimed in a spec.

**Screenshot / Video Demo Link / Prototype Link**
_[paste 1–3 iOS Simulator screenshots — recommend: Onboarding → Home → QA Detail → Volunteer Match (with originating-post subtitle visible) ]_

---

## 3. Final Prototype

### 3.1. Final Prototype

**GitHub Repository** https://github.com/hancyhxy/aussiebridge

**What was Made** The final prototype is an iOS 17 SwiftUI app split into two parallel pieces in one repo:

- `ABDesignSystem/` — a Swift Package providing 4 design-token files, 32 reusable `AB*` components, the 22-entity data model with mock data, and 9 graduated Pages. Every Component has a `#Preview` block; the Package builds standalone via `swift build`.
- `AussieBridgeApp/` — a host iOS App Target generated declaratively via [XcodeGen](https://github.com/yonaskolb/XcodeGen) from `project.yml`. It depends on `ABDesignSystem` as a local SwiftPM package and adds the orchestration layer: `@main` entry, `@Observable` `AppState`, a `Route` enum, an onboarding gate, and 4 `NavigationStack`-backed tabs (Home / Community / Messages / Profile).

The project layers are: design tokens → components → models → pages → routing/tabs → app entry. No third-party UI libraries; only Apple's SwiftUI / SwiftPM standard surface. AI tooling: **Claude Code** (Anthropic) used end-to-end for spec authoring, prototype generation, gap-driven refactor, access-control upgrade, routing wire-up, and the §1 ↔ §9 single-source identity capture refactor — every commit message names what changed and why.

**How the iterations led here** Iteration 1 produced the visual hypothesis; Iteration 2 produced the structural contracts (design.md / struct.md / spec.md / Components); Iteration 3 pressure-tested the contracts by asking "can a fresh implementer build the page from the spec alone?" — the answer was *not yet*, and the V1→V4 ladder is the record of how that gap closed (most visibly via the ABBackBar + ABPageHero split). Iteration 4 added the only thing the spec couldn't supply: state that crosses pages — without which the Context-First mechanism is just words on a screen. If I were to do it again, I would start the App Target shell at Iteration 2, not Iteration 4 — because two of the three SPEC GAP categories (cross-page state / navigation / shared context) only surface when pages talk to each other, and waiting until Iteration 4 to discover them cost a full revision pass on Pages/.

**Screenshot / Video Demo Link**
_[paste your YouTube unlisted link here — record a 60–90s screen capture of the iPhone 16 Pro simulator running through: Onboarding (pick language + status + location + duration) → Finish → Home → tap a service tile → Q&A list → tap a post → Q&A Detail → "Match a volunteer" → Volunteer Match (originating post visible in subtitle) → "Start chat" → auto-switch to Messages tab → Chat screen with shared-context card → tap shared-context to round-trip back. Then switch to Community tab to show the People-you-can-help carousel + Questions-you-can-answer list (single-hub, no segmented control). Finally switch to Profile tab to show the captured ABUser fields, tap "Edit profile" → re-enters the same Onboarding form with values prefilled → change one field (e.g., Status: Immigrant Student → Working) → "Save changes" → return to Profile and confirm the new value displays.]_
