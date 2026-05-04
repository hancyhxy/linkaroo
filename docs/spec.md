# AussieBridge · Spec

> **Status:** skeleton. Section bodies to be filled in subsequent passes —
> see §4 Open Questions for what blocks `final`.

This document defines page-level functional behaviour and layout for the
AussieBridge iOS prototype. It assumes:

- **Why** this product exists → see `docs/product-context.md`
  (the 5 Context-First mechanisms)
- **Visual grammar** (colors / typography / elevation / components) →
  see `docs/design.md` ("Anchored Horizon")
- **Data entities** and their relationships → see `docs/struct.md`
  (22 entities, 5 layers, 11 enums)

Spec.md does **not** redefine those. It writes only what each page does
on top of them.

---

## 0. Conventions

How to read and write this document so it stays a thin reference layer
rather than a re-statement of the other three docs.

- **Token references** — write design tokens as bare names
  (e.g. `surface-container-low`, `spacing-4`, `display-lg`). Resolution
  lives in `docs/design.md` §2 (color), §3 (type), §4 (elevation).
- **Entity references** — point at struct.md sections rather than
  re-listing fields. Format: `ABQAPost (struct.md §2)`.
- **Cross-page navigation** — `→ QADetailView` for forward navigation;
  `← QAListView` for back-stack semantics.
- **Status badges** for any line item:
  - `[shipped]` — already implemented in v1 SwiftUI
  - `[pending]` — decided but unimplemented
  - `[open]` — still needs Xinyi's call (must also appear in §4)

---

## 1. Data Model index

Two-column lookup: which struct.md sections each page touches.
This section does **not** redefine entities — it is a navigation aid for
readers jumping into a specific page below.

| Page | Entities touched (struct.md §) |
| ---- | ------------------------------ |
| _to fill_ | _to fill_ |

---

## 2. Pages

Each page below uses a **fixed five-field template**. No filled page
should exceed roughly one screen of markdown — if it does, the design
likely has hidden complexity that belongs in a sub-doc or a refactor.

**Template:**

- **Purpose** — 1 sentence. Tie to which Context-First mechanism it
  serves (see `product-context.md` §1–5).
- **Models consumed / written** — bullet list with `struct.md §` refs.
  Mark which are read vs written.
- **Layout** — top-to-bottom section list. Each line names the
  `design.md` pattern it uses.
- **Interactions** — `@State` vars · button targets (including specs
  for currently-empty closures) · navigation destinations.
- **Edge cases** — empty / loading / error / "Skip" or back-out paths.

### 2.1 OnboardingView
*Mechanism 1 — identity capture, the first context filter.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

### 2.2 HomeView
*Mechanism 2 — contextual home hub; push, not pull.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

### 2.3 CommunityView
*Supports mechanisms 2 + 3 — segmented entry to Q&A vs people-to-help.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

### 2.4 QAListView
*Mechanism 3 — credibility tags surface at list level.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

### 2.5 QADetailView
*Mechanism 3 + bridge into mechanism 4 — single thread, top answer,
match-a-volunteer escalation.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

### 2.6 VolunteerMatchView
*Mechanism 4 — algorithm legibility via visible match reasons.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

### 2.7 MessageListView
*Mechanism 5 — inbox / re-entry surface.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

### 2.8 ChatView
*Mechanism 5 — context-aware chat with shared-context handoff.*

- **Purpose** — _to fill_
- **Models consumed / written** — _to fill_
- **Layout** — _to fill_
- **Interactions** — _to fill_
- **Edge cases** — _to fill_

---

## 3. Cross-page flows

Each flow is a numbered list of ≤ 6 steps, naming which entity travels
between pages. These exist because Context-First's thesis is **context
is plumbing, not a feature page** — flows are where the plumbing shows.

### 3.1 First-launch flow
Onboarding → Home — captured profile drives Home filtering.
_Steps to fill._

### 3.2 Q&A → human help flow
QAList → QADetail → VolunteerMatch → Chat — originating `ABQAPost`
mounts as `ABSharedContext` in the resulting chat.
_Steps to fill._

### 3.3 Inbox re-entry flow
MessageList → Chat — resume an existing conversation with its
persisted `ABSharedContext` still attached.
_Steps to fill._

---

## 4. Open questions

Decisions that block Spec.md from being final. Each must either be
resolved (folded into §2 / §3) or explicitly deferred to a future
version before the page sections above can be considered authoritative.

- **Empty-button targets [open]**
  - `OnboardingView` — `Continue` / `Skip` actions
  - `QADetailView` — `Match a volunteer` action
  - `QAListView` — `Ask a Question` CTA
- **Empty / loading / error states [open]** — none of the 8 pages
  currently render a non-mock state. Decide which states are v1
  acceptance criteria vs deferred.
- **Data plumbing [open]** — how does the onboarding profile reach
  Home / Q&A feeds? Options: app-level store, `EnvironmentObject`,
  hardcoded mock filter for prototype only.
- **v1 empty closures [open]** — spec them as "future work" or as v1
  acceptance criteria? Affects whether Match-a-volunteer must navigate
  in v1 or only in v2.

---

## 5. Verification

After Spec.md is filled, the prototype is **spec-aligned** when:

1. For each of the 8 pages, the SwiftUI file under
   `ABDesignSystem/Sources/Pages/` renders the layout described in §2.
2. Every Open Question in §4 is resolved — folded into the relevant §2
   page section, or explicitly deferred to a future version (v3).
3. The three flows in §3 can be reproduced end-to-end via Xcode Canvas
   previews (and, once an installable target exists, on a real device).

A page is **section-aligned** (a smaller bar, useful per-PR) when its
§2 entry's *Layout* and *Interactions* fields match its SwiftUI file.
