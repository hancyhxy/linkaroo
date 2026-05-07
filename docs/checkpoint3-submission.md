# Checkpoint 3 — Linkaroo · Context-First

> **How to use this file**
> This is the per-student submission master for Checkpoint 3. Field labels match `Checkpoint3Template_Updated.docx` verbatim so the python-docx pipeline can map them mechanically. Replace `[VIDEO_LINK_TBD]` with the YouTube URL after recording.

---

## Cover

| Field | Value |
|---|---|
| Value Branch | **Linkaroo** |
| `<Your Value>` | **Context-First** |
| Student Name | Xinyi Han |
| Student ID | 25751470 |

> **Note on naming.** The team product is now called **Linkaroo**. The repository name (`aussiebridge`), Swift namespaces (`ABDesignSystem`, `AussieBridgeApp`), and historical commit messages still use the earlier working name; product-facing prose uses Linkaroo.

---

## 1. Overview

**Team concept.** Linkaroo is a Sydney-newcomer support platform that pairs **community Q&A** (categorised, credibility-tagged) with **1-on-1 volunteer matching**. The team's shared problem statement: recently-arrived migrants face a dozen high-stakes services in their first six months — visa, housing, healthcare, transport, banking — and they currently stitch together answers across Reddit, Xiaohongshu / RedNote, government PDFs, and group chats, with no single place that knows where they are in that journey. Linkaroo is that place.

**My individual value branch — Context-First.** I treat user identity, location, and urgency not as profile *features* but as a **filter** that all content flows through, made visible at every screen. This commits to a stronger claim than "personalisation": the user must be able to see *why* a post, a volunteer, or a tag is being surfaced to them. Five mechanisms realise this:

1. **Identity Awareness** — Onboarding captures language / visa status / location / arrival duration once; this becomes a persistent filter, not a profile field.
2. **Contextual Home Hub** — A 2×5 service grid plus a "Recommended for You" module whose items carry visible tags (`STUDENT MATCH`, `TOP ANSWER`).
3. **Granular Metadata Tags** — Four orthogonal tag dimensions on every Q&A post: Authority (`SENIOR MATCH`), Reliability (`SOURCE: TIKTOK`, `UNVERIFIED`), Timeliness (`OLD LAW`, `NEW`), Urgency (`NEEDS ANSWER`).
4. **Reason-Based Volunteer Matching** — Match scores are always paired with human-readable reasons (same university, same language, recent arrival).
5. **Context-Aware Chat** — The originating Q&A post auto-attaches as a card; one tap shares profile tags with the volunteer.

**Why this branch matters.** The user-research insight that drove me to this — *"language is a meta-barrier"* (Checkpoint 1, Participant 1) — is not solved by translation alone. It is solved by **gating that is visible, not algorithmic**. The design philosophy I authored for the system, *The Anchored Horizon*, sits on this commitment: the deep, stable surfaces (identity, location) anchor the user; everything else (recommendations, matches, tags) drifts in front of them, but always legibly.

---

## 2. Iterations

### 2.1. First Iteration — Written Brief → Visual Hypothesis

**Tools Used** Markdown (written design brief) · Google Stitch (AI design tool, brief-to-visual generation) · Claude Code (Anthropic CLI, brief authoring assist)

**What was Made** Before opening any visual tool, I authored a **written Context-First design brief** (`docs/product-context.md`) that fixed the five mechanisms (identity awareness, contextual home, granular metadata tags, reason-based volunteer matching, context-aware chat) and the app background. That MD became the *input* to **Google Stitch** — Stitch did not generate the concept, it translated my brief into a 9-page visual hypothesis (Personalization / Onboarding, Home, Q&A, Q&A Scroll, Volunteer, Community, Message, Chat). I then re-rendered each page as a static HTML mockup in `docs/mockups/*.html` so the visual contract was reproducible outside Stitch and could be opened in any browser. Stitch's auto-generated design tokens (typography, colour, spacing) were copied verbatim into `docs/design.md` as a starting point.

The intentional sequence here matters: **brief first, then visual**. Stitch is fast at producing competent screens, but the screens it produces only carry whatever structure the brief specifies. The five Context-First mechanisms had to be defined as written design constraints before Stitch could express them visually — visible credibility tags on every Q&A row, "Why she's a match for you" reasons on volunteer cards, originating-post auto-attach in chat. Each appears in the 2.1 mockups *because* they were already in `product-context.md`.

**How the previous iteration shaped this** Carried forward from Checkpoint 1: the team-level Context-First mechanism statement and the *meta-barrier* user-research quote, which became the test for every visual decision (line-height for non-native readers; tag credibility hierarchy; visible match-reasons before scores). Discarded: any direction that treated language as a feature toggle rather than a meta-barrier.

**What/Who Influenced this Decision** The Checkpoint 1 user-research interview transcript (the *meta-barrier* quote, captured verbatim). The methodological choice to author the brief in Markdown first — rather than going straight to Figma or Stitch — came from a commitment to **spec-as-contract** that would carry through every later iteration; this is where that discipline starts.

**Screenshot / Video Demo Link / Prototype Link** _(see `screenshots/2-1-stitch-mockup.png` — Stitch-generated 9-page mockup row: Personalization / Homepage / Q&A / Q&A Scroll / Volunteer / Community / Message / Chat)_

---

### 2.2. Second Iteration — Spec & Component Definition

**Tools Used** Claude Code · Markdown (4-block spec template) · SwiftUI Canvas (`#Preview`)

**What was Made** I committed to a **spec-as-contract** discipline — the spec is canonical, code is derivative — and authored three written specs that decompose the design problem along orthogonal axes:

- `docs/design.md` — visual grammar (colour, typography, elevation, "no-line" rule)
- `docs/struct.md` — 22-entity data model with 11 enums (zero page-behaviour pollution)
- `docs/spec.md` — per-page 4-block template (Overview / Parameters / Actions / Layout) covering §1–§9

In parallel I built a **32-component SwiftUI library** in `ABDesignSystem/Sources/Components/AB*.swift` so that spec.md regions resolve to concrete Swift types rather than free-form decisions. The 4-block template per page sets a wireframe-precision contract before any page code lands. I used Claude Code throughout, but the *abstraction boundaries* — design tokens vs components vs pages, single-responsibility files, the four orthogonal spec docs — were design intentions I locked first; Claude Code drafted the content under those constraints.

**How the previous iteration shaped this** Carried forward: Stitch's visual grammar (kept as fidelity reference) and the 9-page mockup set as visual ground-truth. Discarded: relying on Stitch's auto-generated copy text — every string was re-authored against the user-research vocabulary (e.g., "Match a volunteer" rather than Stitch's generic "Get help"). Added: a Components/ layer that didn't exist in Stitch, because Stitch produces page artefacts but not reusable building blocks.

**What/Who Influenced this Decision** The realisation that Stitch's output, while visually competent, didn't *bind* the data model — `docs/struct.md` had to be authored separately and then traced back into the design.md vocabulary. This is when the four-doc separation became deliberate.

**Screenshot / Video Demo Link / Prototype Link** _(see `screenshots/2-2-component-library.png` — Xcode Canvas grid showing AB* components)_

---

### 2.3. Third Iteration — Spec-Driven Prototypes (V1→V4)

**Tools Used** Claude Code · SwiftUI Canvas (`#Preview` mode) · Markdown SPEC GAP markers

**What was Made** I tested the spec's sufficiency by an explicit experiment: re-implement each page **strictly from `docs/spec.md`**, without reading the corresponding `Pages/*View.swift`. If an implementer needed to self-pick a token, that was a *spec bug*, not a coding bug. The result is **14 spec-driven prototypes** in `ABDesignSystem/Sources/Prototypes/`. Onboarding (§1) and Home (§2) each got 4 versions (V1→V4); §3 Community / §4 Q&A List / §5 Q&A Detail / §6 Volunteer Match / §7 Message List / §8 Chat got a single V4 each since the workflow had stabilised by then; §9 Profile graduated directly to `Pages/` without a prototype ladder. I used Claude Code to generate each version, but each version had to honour a `// SPEC GAP` discipline: every place the spec was insufficient got a marker, which fed back into amendments to spec.md and Components/. The most visible amendment surfaced through this loop was the **split of `ABBackBar` and `ABPageHero` out of the early monolithic `ABHeader`** — V3 of Onboarding exposed that "back chevron" and "page hero headline" had been forced into one component when the mockup clearly separated them.

**How the previous iteration shaped this** Carried forward: the 4-block spec.md template (the prototypes were the test of whether it was sufficient). Discarded: any attempt to "freeze" components early — V1→V4 deliberately surfaced gaps that closed by amending spec.md and Components/, then iterating again.

**What/Who Influenced this Decision** The methodological commitment that *spec-driven means the spec must be sufficient*. The two pages with full V1→V4 ladders are evidence of where the workflow itself was being invented; the single-V4 pages are evidence of where it had stabilised.

**Screenshot / Video Demo Link / Prototype Link** _(see `screenshots/2-3-prototype-ladder.png` — Xcode Canvas side-by-side of `OnboardingPrototypeV1View` and `OnboardingPrototypeV4View` showing the back-bar / page-hero split that V3 forced)_

---

### 2.4. Fourth Iteration — Functional iOS App

**Tools Used** Claude Code · Xcode 16 · XcodeGen (`project.yml` → `.xcodeproj`) · iOS 17 Simulator (iPhone 16 Pro) · SwiftUI standard libs (`NavigationStack`, `@Observable`, `.environment`)

**What was Made** I added the **only architectural layer the spec couldn't supply** — state that crosses pages — by standing up a host iOS App Target (`AussieBridgeApp/`) that consumes `ABDesignSystem` as a local Swift Package. The transformation lands in two phases.

*Phase A — App shell & routing.* Four commits stand up the runnable app: (1) `chore(api): expose ABDesignSystem types as public` — 47 files upgraded so the App Target can reference Models/Tokens/Components/Pages by name; (2) `feat(app): scaffold iOS App Target` — `@main App`, `AppState` (@Observable), `Route` enum, `RootView` onboarding-gate, `MainTabView` 4-tab shell; (3) `feat(pages): parameterize navigation hooks via closures` — every Page replaces its 27 `[open §12]` placeholder closures with explicit closure parameters on its public init, so pages stay self-contained; (4) `feat(app): wire 4 tabs with NavigationStack routing` — each tab gets its own `NavigationStack(path:)` backed by AppState, with `navigationDestination(for: Route.self)` for value-driven routing. Cross-tab handoff is implemented end-to-end (VolunteerMatch → Chat hops Home tab → Messages tab; Chat's shared-context card hops back).

*Phase B — §9 Profile + §3 Community alignment.* Three commits close the loop on identity surfaces: (5) `feat(profile): add §9 Profile page and Edit profile loop` — `ProfileView` is the read-back surface for the captured ABUser, and `OnboardingView` gains an optional `prefilledUser` parameter so Edit profile re-enters the same form with current values prefilled (single-source identity capture); (6) `refactor(community): simplify §3 to a single hub` — the earlier Discussions / People-to-help segmented control was a layered duplication of what the bottom tab bar already provides, so CommunityView is now one body (people-you-can-help carousel above questions-you-can-answer list); (7) `docs(readme): align to 9 pages and document Stage 4`.

I used Claude Code throughout these seven commits, but the **decisions** were mine: which pages needed cross-tab state (mechanisms 4 and 5 of Context-First), where to break self-contained closures (the parameterise-via-closures refactor came from me, not the AI), and where to *remove* layers (the segmented-control collapse was an opinionated simplification against the earlier spec). Engineering rigor: every commit message names what changed and why; `#Preview` blocks remained working at every step so each Page stayed renderable in isolation.

**Alignment with Apple HIG.** The app uses native iOS patterns rather than custom reinventions: **SF Symbols** for every glyph (`chevron.up/down`, `bubble.left`, `square.and.arrow.up`, `plus.circle.fill`, `arrow.up`, etc. — 8+ usages across components like `ABTag`, `ABButton`, `ABQAPostCard`, `ABTextInput`); **value-driven NavigationStack** routing per HIG iOS 16+ guidance (each of the 4 tabs runs its own `NavigationStack(path: $appState.<tab>Path)` with `navigationDestination(for: Route.self)`); **standard TabView** for primary navigation; and tonal layering / no-line section breaks per HIG's depth recommendations. Accessibility surface is partial — `ABTabBar` carries `.accessibilityLabel` and `.accessibilityAddTraits(.isSelected)` for tab state — and `docs/design.md` calls for `body-lg` line-height of 1.6× explicitly to support non-native English readers. Full Dynamic Type and VoiceOver coverage are not yet wired across every component; this is a knowingly deferred axis.

**How the previous iteration shaped this** Carried forward: every visual / typography / copy decision from V4 prototypes, untouched; and the 27 `[open §12]` markers from V4 graduation, which pointed at exactly which closures needed real bindings. Discarded: nothing — the 4-layer architecture (tokens → components → models → pages) survived intact; the App Target only adds the orchestration layer above Pages.

**What/Who Influenced this Decision** The Checkpoint 3 rubric requirement to demonstrate *"essential core features that effectively demonstrate intended functionality for user stories."* And the Context-First mechanism in `docs/product-context.md` §10.3 — *shared-context handoff* — which only makes sense when state crosses pages, which only happens with an `AppState` and routing. So the App Target wasn't decoration; it was the only level at which the Context-First story is actually testable. The §1 ↔ §9 round-trip (Onboarding writes ABUser → Profile reads it back → Edit profile re-enters Onboarding to update it) is the runtime evidence that mechanism 1 (identity awareness) is end-to-end wired, not merely claimed in a spec.

**Screenshot / Video Demo Link / Prototype Link** _(see `screenshots/2-4-app-flow.png` — iOS Simulator captures: Onboarding → Home → Q&A Detail → Volunteer Match showing originating-post subtitle visible)_

---

## 3. Final Prototype

### 3.1. Final Prototype

**GitHub Repository \*** https://github.com/hancyhxy/aussiebridge

**What was Made** A runnable iOS 17 SwiftUI app organised as two parallel pieces in one repository:

- **`ABDesignSystem/`** — a Swift Package providing 4 design-token files (`ABColors`, `ABTypography`, `ABSpacing`, `ABElevation`), 32 reusable `AB*` components, the 22-entity data model with mock data, and 9 graduated Pages. Every Component carries a `#Preview` block; the Package builds standalone via `swift build`.
- **`AussieBridgeApp/`** — a host iOS App Target generated declaratively via [XcodeGen](https://github.com/yonaskolb/XcodeGen) from `project.yml`. It depends on `ABDesignSystem` as a local SwiftPM package and adds the orchestration layer: `@main` entry, `@Observable` `AppState`, a `Route` enum, an onboarding gate, and 4 `NavigationStack`-backed tabs (Home / Community / Messages / Profile).

The project layers, top-down: design tokens → components → models → pages → routing/tabs → app entry. No third-party UI libraries; only Apple's SwiftUI / SwiftPM standard surface. **AI tooling**: I authored a written design brief (`docs/product-context.md`) first, then used **Google Stitch** to translate that brief into the 9-page visual hypothesis (Iteration 1); from Iteration 2 onward I used **Claude Code (Anthropic CLI)** as the primary AI tool — for spec authoring (the 4-block template), prototype generation under the SPEC GAP discipline, gap-driven refactor (e.g. ABBackBar / ABPageHero split), access-control upgrade, routing wire-up, and the §1 ↔ §9 single-source identity capture refactor. Every commit message names what changed and why; the git history is the audit trail for AI engagement.

**How the iterations led here** Iteration 1 produced the visual hypothesis and the Context-First brief in concrete pixels. Iteration 2 produced the structural contracts (design.md / struct.md / spec.md / Components) — separating *what the system is* from *how each page expresses it*. Iteration 3 pressure-tested those contracts by asking "can a fresh implementer build the page from the spec alone?" — the V1→V4 ladder is the record of how that gap closed (most visibly via the ABBackBar + ABPageHero split). Iteration 4 added the only thing the spec couldn't supply: state that crosses pages — without which Context-First is just words on a screen. **What I would do differently:** I would start the App Target shell at Iteration 2, not Iteration 4 — because two of the three SPEC GAP categories (cross-page state, navigation, shared context) only surface when pages talk to each other, and waiting until Iteration 4 to discover them cost a full revision pass on Pages/. The lesson: spec-driven discipline is necessary but not sufficient; cross-page state must be exercised early to close the loop.

**Screenshot / Video Demo Link** [VIDEO_LINK_TBD]

> **Recording script (60–90 s):** Onboarding (pick language + status + location + duration) → Finish → Home → tap a service tile → Q&A list → tap a post → Q&A Detail → "Match a volunteer" → Volunteer Match (originating post visible in subtitle) → "Start chat" → auto-switch to Messages tab → Chat screen with shared-context card → tap shared-context to round-trip back. Switch to Community tab to show the People-you-can-help carousel + Questions-you-can-answer list (single-hub, no segmented control). Switch to Profile tab to show captured ABUser fields, tap "Edit profile" → re-enters Onboarding form prefilled → change Status (Immigrant Student → Working) → "Save changes" → return to Profile and confirm new value displays.
