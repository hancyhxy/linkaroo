# AussieBridge

A platform for newly-arrived migrants in Sydney, combining **community Q&A** (categorized, credibility-tagged) with **1-on-1 volunteer matching**. The personal variation explored in this repo is **Context-First** — the app treats user identity, location, and urgency as a *filter* rather than a *feature*, so the same content surfaces differently depending on who is reading.

## Status

iOS prototype, built as a SwiftUI design system + 8 self-contained Pages. All 8 Pages are spec-driven and live behind `#Preview` in Xcode Canvas (open `ABDesignSystem/Package.swift`). Next milestone is an installable iOS app target.

## Repository layout

Top-level:

| Path              | What's inside                                                              |
| ----------------- | -------------------------------------------------------------------------- |
| `ABDesignSystem/` | Swift Package — the iOS prototype itself (tokens · components · models · pages) |
| `docs/`           | Written specs + Stitch HTML mockups (the project's readable spec set)      |

`ABDesignSystem/Sources/` (4-layer architecture):

```
Sources/
├── ABColors.swift · ABTypography.swift · ABSpacing.swift · ABElevation.swift   ← layer 1: design tokens
├── Components/                                                                  ← layer 2: 30 reusable SwiftUI components
├── Models/                                                                      ← layer 3: ABModels + ABMockData
├── Pages/                                                                       ← layer 4: 8 self-contained pages
│   ├── OnboardingView      — identity capture (language / status / location / arrival)
│   ├── HomeView            — search + service grid + featured guide + recommendations
│   ├── CommunityView       — discussions vs. people-to-help
│   ├── QAListView          — Reddit-style Q&A list with category filter
│   ├── QADetailView        — single thread + Top Answer + match-volunteer CTA
│   ├── VolunteerMatchView  — best-fit hero + "why she's a match" + more matches
│   ├── MessageListView     — All / Unread segmented inbox
│   └── ChatView            — shared-context handoff + action pills + bubbles
└── Screens/                                                                     ← layout scaffold helpers
```

`docs/`:

```
docs/
├── product-context.md  Context-First mechanism summary (5 contextual moments)
├── design.md           Authoritative design spec (tokens · type · elevation · components)
├── struct.md           Data model — 22 entities organised into 5 Context-First layers
├── struct.html         Rendered HTML version of struct.md (open in browser)
├── spec.md             Page-level functional spec — 4-block template per page (§1–§8)
└── mockups/            Stitch-generated HTML mockups — visual prior to the SwiftUI implementation
    ├── personalization.html · homepage.html · community.html · volunteer.html
    ├── qa.html · qa_scroll.html      (two variants — SwiftUI's QAListView consolidates both)
    ├── message.html · chat.html
```

## Quick start

There are two ways to run this prototype, depending on what you want to see.

### A. Single-page Canvas preview (design-system view)

1. Open `ABDesignSystem/Package.swift` in Xcode.
2. In the project navigator, click any file under `Sources/Pages/` or `Sources/Components/`.
3. Press `⌥⌘↵` to reveal the Canvas; choose an **iPhone 16 Pro** simulator as the preview target.
4. Click the live-preview ▶ button on the Canvas toolbar — interactions (scroll, tap, type) work in this mode.

To verify the package builds:
```sh
cd ABDesignSystem
swift build
```

### B. Full iOS App in the simulator (functional view)

The App Target is generated declaratively from `AussieBridgeApp/project.yml` via [XcodeGen](https://github.com/yonaskolb/XcodeGen). The committed `.xcodeproj` will work as-is, but if you want to regenerate it locally:

```sh
brew install xcodegen           # if not already installed
cd AussieBridgeApp
xcodegen generate
```

Then:

1. Open `AussieBridgeApp/AussieBridge.xcodeproj` in Xcode.
2. Select an **iPhone 16 Pro** simulator from the run-destination menu.
3. Press ▶ (or `⌘R`) to build and run.

The launch flow is: Onboarding → Home → tap any service tile → Q&A list → tap a post → Q&A Detail → "Match a volunteer" → Volunteer Match (originating post surfaces as a subtitle) → "Start chat" → auto-hops to Messages tab → Chat (with shared-context card). Tap the shared-context card to round-trip back to the originating Q&A in Home tab. The Profile tab shows the user record captured during onboarding.

## Design rationale

The product is built on one user-research insight, captured verbatim during a Checkpoint 1 interview:

> *"Language is a meta-barrier."*

This sentence drives every downstream decision: typography line-height, tag credibility hierarchy, visible match-reasons, context-aware chat handoff. Each of the 5 Context-First mechanisms exists because language gates information access — and gating must therefore be made visible, not algorithmic.

See `docs/product-context.md` for the full mechanism summary.

## AI workflow

This repo is built with a **spec-driven** workflow in 3 stages. AI (Claude Code) is bounded to *executing each step against the artefact upstream of it* — no free-form generation. Components are not a separate stage; they are a *mindset* carried through every stage (every visual / page region resolves to a reusable `AB*` component, never a one-off).

| Stage | Sub-step | Key artefact |
| ----- | -------- | ------------ |
| **1. Concept → Ideation** *(form a shared "what are we building")* | (1) Context-First defined as the personal variation: identity / location / urgency act as a *filter* over the same content. | `docs/product-context.md` (5 mechanisms) |
| | (2) Google Stitch generated 8 page designs + an auto-generated design specification, copied verbatim into the repo. | Stitch design output, hand-pasted into `docs/design.md` |
| | (3) The 8 Stitch screenshots were converted into static HTML — kept as a fidelity reference for downstream SwiftUI implementations. | `docs/mockups/*.html` (8 pages) |
| **2. Spec & Component Definition** *(produce the static contract: visual / data / behaviour / building blocks)* | (a) Calibrate the Stitch-pasted design spec — tokens, typography scale, elevation, component visual grammar. | `docs/design.md` |
| | (b) Personalised data model — the team's group structure refined into 5 Context-First layers (22 entities). Not derived from Stitch; captures how the mechanisms compose at the data level. | `docs/struct.md` + `docs/struct.html` |
| | (c) Per-page functional spec — 4-block template (Overview / Parameters / Actions / Layout) at wireframe precision, written in conversation with Claude. | `docs/spec.md` (`§1`–`§8`) |
| | (d) Initial component library — 30 reusable `AB*` views derived from the visual grammar so spec.md regions resolve to real Swift types, not free-form decisions. | `ABDesignSystem/Sources/Components/` |
| **3. Rendering Test → Final** *(use code to reverse-validate the spec; close gaps, then graduate)* | Each page is re-implemented from `spec.md` *without reading the existing `Pages/` source*. Gaps surface as "had to self-pick a token / copy / behaviour" notes; spec.md and the component library are amended; the prototype iterates until it converges. Once converged, it graduates to `Pages/*View.swift`. | `ABDesignSystem/Sources/Prototypes/` (evolution record) → `ABDesignSystem/Sources/Pages/` (final 8 views) |

```mermaid
flowchart TD
    subgraph S1 ["Stage 1 — Concept → Ideation"]
        direction TB
        A1["Context-First concept<br/>docs/product-context.md"]
        A2["Google Stitch demo<br/>8 designs + design spec"]
        A3["HTML mockups<br/>docs/mockups/*.html"]
        A1 --> A2 --> A3
    end

    subgraph S2 ["Stage 2 — Spec &amp; Component Definition"]
        direction TB
        B1["docs/design.md<br/><i>visual grammar</i>"]
        B2["docs/struct.md<br/><i>5-layer / 22 entities</i>"]
        B3["docs/spec.md<br/><i>per-page 4-block</i>"]
        B4["Components/<br/><i>30 AB* views</i>"]
    end

    subgraph S3 ["Stage 3 — Rendering Test → Final"]
        direction TB
        C1["Prototypes/<br/>spec-driven prototypes<br/><i>iterate until convergence</i>"]
        C2["Pages/<br/>final 8 SwiftUI pages"]
        C1 --> C2
    end

    S1 --> S2
    S2 --> S3
    C1 -.->|spec gaps fed back| B3
    C1 -.->|new components| B4

    style A1 fill:#e8f4ff,stroke:#00639b,color:#171c21
    style A2 fill:#e8f4ff,stroke:#00639b,color:#171c21
    style A3 fill:#e8f4ff,stroke:#00639b,color:#171c21
    style B1 fill:#fff3e0,stroke:#c4983f,color:#171c21
    style B2 fill:#fff3e0,stroke:#c4983f,color:#171c21
    style B3 fill:#fff3e0,stroke:#c4983f,color:#171c21
    style B4 fill:#fff3e0,stroke:#c4983f,color:#171c21
    style C1 fill:#dcfce7,stroke:#16a34a,color:#171c21
    style C2 fill:#dcfce7,stroke:#16a34a,color:#171c21
```

The two dashed feedback edges from Stage 3 back to Stage 2 are what makes this workflow *spec-driven* rather than just spec-aligned: the prototypes don't merely consume the spec — they pressure-test it, and any gap they expose is closed in the spec or the component library before the page graduates.

`Sources/Prototypes/` stays in the repo as the evolution record — see `Sources/Prototypes/README.md` for what's in there and how to read it.

## Where the rest of the project lives

This repository is intentionally **product-only**. User research, ideation history, and presentation materials live alongside in `~/Desktop/xinyihan/uts-coursework/ios_innovation_studio/` — they're the path that led here, but they don't belong to the product itself.

## License

Personal academic project; no public license issued. Contact for re-use.
