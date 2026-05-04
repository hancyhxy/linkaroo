# AussieBridge

A platform for newly-arrived migrants in Sydney, combining **community Q&A** (categorized, credibility-tagged) with **1-on-1 volunteer matching**. The personal variation explored in this repo is **Context-First** — the app treats user identity, location, and urgency as a *filter* rather than a *feature*, so the same content surfaces differently depending on who is reading.

## Status

iOS prototype, built as a SwiftUI design system + 8 self-contained Pages. Currently runnable as Xcode Canvas previews (open `ABDesignSystem/Package.swift`); next-iteration goal is an installable iOS app target.

## Repository layout

```
aussiebridge/
├── ABDesignSystem/         Swift Package — the iOS prototype itself
│   ├── Package.swift
│   └── Sources/
│       ├── ABColors.swift, ABTypography.swift,
│       │   ABSpacing.swift, ABElevation.swift     ← Design tokens (4-layer architecture, layer 1)
│       ├── Components/                            ← 30 reusable SwiftUI components (layer 2)
│       ├── Models/                                ← Construct definitions: ABModels, ABMockData (layer 3)
│       ├── Pages/                                 ← 8 self-contained pages (layer 4)
│       │   ├── OnboardingView      — identity capture (language / status / location / arrival)
│       │   ├── HomeView            — search + service grid + featured guide + recommendations
│       │   ├── CommunityView       — discussions vs. people-to-help
│       │   ├── QAListView          — Reddit-style Q&A list with category filter
│       │   ├── QADetailView        — single thread + Top Answer + match-volunteer CTA
│       │   ├── VolunteerMatchView  — best-fit hero + "why she's a match" + more matches
│       │   ├── MessageListView     — All / Unread segmented inbox
│       │   └── ChatView            — shared-context handoff + action pills + bubbles
│       └── Screens/                               ← Layout scaffold helpers
├── design.md               Authoritative design spec (Stitch baseline; "Anchored Horizon")
├── design.archive.md       v1 design notes — Craft-aligned visual exploration (preserved for iteration history)
├── html_pages/             Stitch-generated HTML mockups (one per Page; visual prior to the SwiftUI implementation)
└── docs/
    └── product-context.md  Context-First mechanism summary (5 contextual moments)
```

## Quick start

1. Open `ABDesignSystem/Package.swift` in Xcode.
2. In the project navigator, click any file under `Sources/Pages/`.
3. Press `⌥⌘↵` to reveal the Canvas; choose **iPhone 15 Pro** (or **iPhone Dynamic Island**) as the preview target.
4. Click the live-preview ▶ button on the Canvas toolbar — interactions (scroll, tap, type) work in this mode.

To verify the package builds:
```sh
cd ABDesignSystem
swift build
```

## Design rationale

The product is built on one user-research insight, captured verbatim during a Checkpoint 1 interview:

> *"Language is a meta-barrier."*

This sentence drives every downstream decision: typography line-height, tag credibility hierarchy, visible match-reasons, context-aware chat handoff. Each of the 5 Context-First mechanisms exists because language gates information access — and gating must therefore be made visible, not algorithmic.

See `docs/product-context.md` for the full mechanism summary.

## Where the rest of the project lives

This repository is intentionally **product-only**. The supporting course-and-research artefacts live in a separate location, kept clean of build code:

```
~/Desktop/xinyihan/uts-coursework/ios_innovation_studio/
├── checkpoint1/         User research, interviews, AI engagement log
├── checkpoint2/         Course design documentation, rubrics
├── checkpoint3/         Presentation prep, course-side fallback copy of this product
├── ideation_doc/        6-direction exploration → AussieBridge convergence (with 23-Mar pivot history)
└── README.md            Index pointing back to this product repo
```

If you need:
- **the user research that justifies the design** → `uts-coursework/.../checkpoint1/interview/`
- **how AI was used and verified** → `uts-coursework/.../checkpoint1/ai_engagement.md`
- **how the team converged from 6 directions to AussieBridge** → `uts-coursework/.../ideation_doc/`
- **the presentation deck and slide narrative** → `uts-coursework/.../checkpoint3/` (assembled from the source files in this repo)

## Iteration plan

| Round | Status | Focus |
|-------|--------|-------|
| **v1** (Anchored Horizon) | shipped | AI-generated `design.md` from Google Stitch; faithfully translated into SwiftUI. Current visual = Stitch baseline ≈ 75% of intended quality. |
| **v2** (Open Harbour exploration) | archived in `design.archive.md` | Hand-tuned Craft aesthetic (warm paper + near-black + pastel accents); reverted to v1 baseline to keep narrative aligned with `design.md`. Worth revisiting for warmth. |
| **v3** (target) | next | Either (a) graft published design system (Radix Colors / Apple HIG semantic tokens) onto current spec, or (b) selectively re-introduce v2's editorial warmth on top of v1's Pacific palette. Decision pending user-test results. |

User-testing hypotheses for v3 priority-setting: see the presentation script in `uts-coursework/.../checkpoint3/`.

## License

Personal academic project; no public license issued. Contact for re-use.
