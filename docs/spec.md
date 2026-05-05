# AussieBridge — Feature Specification

> Page-by-page feature definitions for the iOS prototype. Each page
> spells out what the page is for, what parameters it consumes, what
> actions it supports, and how its layout is composed — at wireframe
> precision, so a reader can rebuild the page's behaviour without
> looking at the SwiftUI source.
>
> **Status:** §1 Onboarding is filled as the canonical sample.
> §2–§8 carry the 4-block template with empty bodies, awaiting fill.
> See §11 Open Questions for what blocks `final`.

This spec assumes:

- **Why** the product exists → `docs/product-context.md` (5 Context-First mechanisms)
- **Visual grammar** (colors / type / elevation / components) → `docs/design.md`
- **Data entities + relationships** → `docs/struct.md` (22 entities, 5 layers)
- **Repository layout / how to run** → `README.md`

This spec does **not** redefine those.

---

## 0. Conventions

How to read and write this document so it stays a thin reference layer
that drives changes precisely (`add a married field` → 1 row in
Parameters + 1 bullet in Layout + maybe 1 row in Actions).

### 0.1 Page template

Every §1–§8 page section uses the same 4 blocks, in this order:

```
## §X PageName
> Mechanism N — one-line mechanism tag

### Overview
3–5 sentence paragraph: Why (product role) + What (user does) + Then
(where the data flows). Include at least one product-context constraint
the implementer must respect (e.g. "language is a meta-barrier" → form
must be short and warm).

### Feature
**Parameters** table — every field, types fully enumerated.
**Actions**    table — one row per user-triggered effect.

### Layout
One sentence on overall topology, then a numbered bullet list of
regions. Each bullet names the region + the control type (from §0.4),
and references actions by ID where relevant.
```

### 0.2 Enumeration source rule

Every enum value in **Parameters** must spell-match the corresponding
enum case in `struct.md` and `ABModels.swift`. If those two diverge
from the spec, the spec is wrong (not the code). Single source of
truth, three checked locations.

### 0.3 Action ID rule

Each **Action** row gets an ID `§X.AN` where X is the page number and
N is sequential (`§1.A1`, `§1.A2`, …). Layout bullets reference
actions by ID, e.g. `primary button "Continue" (§1.A5)`. Cross-page
references work too: `§5.A4 → §6 VolunteerMatch`.

### 0.4 Control vocabulary

Layout bullets describe regions with **control types**, not visual
treatments and not in-house component names. The standard vocabulary:

| Group       | Standard terms                                                                |
| ----------- | ----------------------------------------------------------------------------- |
| Selection   | single-select card grid · multi-select card grid · single-select chip row · radio list · segmented control |
| Text        | single-line text input · multi-line text area · search input                  |
| Picker      | city/state picker · date picker · dropdown                                    |
| List        | vertical list · horizontal carousel · category-grouped list                   |
| Toggle      | toggle · tab bar                                                              |
| Block       | hero block · informational card · banner · tip card · quote block             |
| Action      | primary button · text link · floating action button · sticky footer overlay   |
| Card        | content card · row card · compact card · hero card                            |
| Tag         | tag chip · category chip · status badge                                       |

Add a row when the existing vocabulary cannot describe a real region.
Don't introduce ad-hoc terms inline.

### 0.5 Layout copy rule

Prototype-stage spec — **content text is mocked** and lives outside
this document. Layout bullets describe regions abstractly:

- ✅ `hero block — headline + supporting paragraph`
- ✅ `tip card — informational card (title + body)`
- ❌ `headline "Let's set the scene"` (decorative content — do not embed)

Exception: **action-typed copy** stays in the bullet because the words
encode the action's semantics:

- ✅ `primary button "Continue" (§1.A5)`
- ✅ `text link "Skip for now" (§1.A6)`

If a future product decision locks specific wording (legal disclaimer,
brand voice line), that string promotes into Layout in quotes.

### 0.6 Status badges

Inline tags appended to a row or bullet:

- `[shipped]` — implemented in v1 SwiftUI
- `[pending]` — decided, not yet implemented
- `[open]` — undecided; must also appear in §11

---

## 0.5 Page Map

Navigation topology. Read this once before any page section.

```
First-launch:  §1 Onboarding ──► (TabBar root)

TabBar root:
  ├─ §2 Home
  ├─ §3 Community ──► §4 Q&A List ──► §5 Q&A Detail ──► §6 Volunteer Match ──► §8 Chat
  └─ §7 Message List ──► §8 Chat
```

- `§3 Community` and `§4 Q&A List` overlap on Q&A surfaces; Community
  is the segmented entry, Q&A List is the deep filter view.
- `§5 → §6 → §8` is the load-bearing flow that proves Mechanism 4 +
  Mechanism 5 (originating ABQAPost rides into Chat as
  ABSharedContext). See §11.2 cross-page flow.

---

## §1 Onboarding

> M1 — first-launch identity capture; the captured ABUser drives all
> downstream filtering.

### Overview

Onboarding is the personalization engine's initialization step. On
first launch the user fills a short profile — preferred language,
current status, location, time-in-Australia. The captured ABUser is
written to app-level state and consumed by every downstream page
(Home recommendations, Q&A relevance, volunteer match reasons). The
form is intentionally short and warm rather than long and exhaustive
— "language is a meta-barrier" means the entry gate itself cannot
feel like an interrogation. A Skip path exists so users can defer
personalization and still reach Home with a default profile.

### Feature

**Parameters**

| Field    | Type         | Values                                                                  | Required | Default          |
| -------- | ------------ | ----------------------------------------------------------------------- | :------: | ---------------- |
| language | ABLanguage   | english · mandarin · spanish · arabic · hindi · other                   |   yes    | english          |
| status   | ABUserStatus | immigrantStudent · working · lookingForWork · businessOwner             |   yes    | immigrantStudent |
| location | ABLocation   | { city: String; state: String }                                         |   yes    | { Sydney, NSW }  |
| duration | ABDuration   | notYetArrived · justLanded · oneToSix · sixToTwelve · oneYearPlus       |   yes    | justLanded       |

**Actions**

| ID    | Trigger              | Effect                                                                       |
| ----- | -------------------- | ---------------------------------------------------------------------------- |
| §1.A1 | tap a language card  | set local state `language` to tapped value (single-select)                   |
| §1.A2 | tap a status card    | set local state `status` to tapped value (single-select)                     |
| §1.A3 | edit city/state      | set local state `location.city` / `location.state`                           |
| §1.A4 | tap a duration chip  | set local state `duration` to tapped value (single-select)                   |
| §1.A5 | tap "Continue"       | write `ABUser(language, status, location, duration)` to AppState; → §2 Home  |
| §1.A6 | tap "Skip for now"   | write default `ABUser` to AppState; → §2 Home                                |

### Layout

Vertical-scroll form with a fixed sticky footer overlay.

1. **Header bar** — page title
2. **Hero intro** — hero block (headline + supporting paragraph)
3. **Language section** — section label + single-select card grid (6 options, 2 cols; each card: flag + language name) (§1.A1)
4. **Status section** — section label + single-select icon-card grid (4 options, 2 cols; each card: icon + label) (§1.A2)
5. **Location section** — section label + city/state picker (§1.A3)
6. **Duration section** — section label + single-select chip row (5 options, wraps) (§1.A4)
7. **Tip card** — informational card (title + body)
8. **Sticky footer overlay** — primary button "Continue" (§1.A5) + text link "Skip for now" (§1.A6)

---

## §2 Home

> M2 — contextual home hub; push, not pull. Recommendations and the
> Featured Guide are pre-filtered against the captured ABUser.

### Overview

_to fill_

### Feature

**Parameters**

| Field | Type | Values | Required | Default |
| ----- | ---- | ------ | :------: | ------- |
| _to fill_ |  |  |  |  |

**Actions**

| ID    | Trigger | Effect |
| ----- | ------- | ------ |
| §2.A1 | _to fill_ | _to fill_ |

### Layout

_to fill — one sentence on topology, then numbered bullets._

---

## §3 Community

> M2 + M3 — segmented entry to Q&A discussions vs people-to-help.

### Overview

_to fill_

### Feature

**Parameters**

| Field | Type | Values | Required | Default |
| ----- | ---- | ------ | :------: | ------- |
| _to fill_ |  |  |  |  |

**Actions**

| ID    | Trigger | Effect |
| ----- | ------- | ------ |
| §3.A1 | _to fill_ | _to fill_ |

### Layout

_to fill_

---

## §4 Q&A List

> M3 — credibility tags surfaced at list level so non-native readers
> can parse trust without parsing prose.

### Overview

_to fill_

### Feature

**Parameters**

| Field | Type | Values | Required | Default |
| ----- | ---- | ------ | :------: | ------- |
| _to fill_ |  |  |  |  |

**Actions**

| ID    | Trigger | Effect |
| ----- | ------- | ------ |
| §4.A1 | _to fill_ | _to fill_ |

### Layout

_to fill_

---

## §5 Q&A Detail

> M3 + bridge into M4 — single thread + Top Answer + match-volunteer
> escalation. The originating ABQAPost rides forward as ABSharedContext
> when the user escalates to a volunteer chat.

### Overview

_to fill_

### Feature

**Parameters**

| Field | Type | Values | Required | Default |
| ----- | ---- | ------ | :------: | ------- |
| _to fill_ |  |  |  |  |

**Actions**

| ID    | Trigger | Effect |
| ----- | ------- | ------ |
| §5.A1 | _to fill_ | _to fill_ |

### Layout

_to fill_

---

## §6 Volunteer Match

> M4 — algorithm legibility via visible match reasons. Every matched
> volunteer renders the explicit reasons they fit, not just a score.

### Overview

_to fill_

### Feature

**Parameters**

| Field | Type | Values | Required | Default |
| ----- | ---- | ------ | :------: | ------- |
| _to fill_ |  |  |  |  |

**Actions**

| ID    | Trigger | Effect |
| ----- | ------- | ------ |
| §6.A1 | _to fill_ | _to fill_ |

### Layout

_to fill_

---

## §7 Message List

> M5 — inbox / re-entry surface. Existing conversations preserve their
> ABSharedContext on re-open.

### Overview

_to fill_

### Feature

**Parameters**

| Field | Type | Values | Required | Default |
| ----- | ---- | ------ | :------: | ------- |
| _to fill_ |  |  |  |  |

**Actions**

| ID    | Trigger | Effect |
| ----- | ------- | ------ |
| §7.A1 | _to fill_ | _to fill_ |

### Layout

_to fill_

---

## §8 Chat

> M5 — context-aware chat. The originating ABQAPost (when present)
> mounts at the top as ABSharedContext and persists across re-entries.

### Overview

_to fill_

### Feature

**Parameters**

| Field | Type | Values | Required | Default |
| ----- | ---- | ------ | :------: | ------- |
| _to fill_ |  |  |  |  |

**Actions**

| ID    | Trigger | Effect |
| ----- | ------- | ------ |
| §8.A1 | _to fill_ | _to fill_ |

### Layout

_to fill_

---

## §9 Mechanism × Page coverage

Proves the 5 Context-First mechanisms each land on at least one page,
and no page is mechanism-orphaned.

Legend: ● this page **originates** the mechanism · ◐ this page
**consumes** mechanism output produced elsewhere.

|                          | M1 Identity | M2 Home Hub | M3 Tags | M4 Match | M5 Chat |
| ------------------------ | :---------: | :---------: | :-----: | :------: | :-----: |
| §1 Onboarding            | ●           |             |         |          |         |
| §2 Home                  | ◐           | ●           |         |          |         |
| §3 Community             | ◐           | ●           | ◐       |          |         |
| §4 Q&A List              | ◐           |             | ●       |          |         |
| §5 Q&A Detail            |             |             | ●       | ◐ (CTA)  |         |
| §6 Volunteer Match       | ◐           |             |         | ●        |         |
| §7 Message List          |             |             |         |          | ●       |
| §8 Chat                  |             |             |         | ◐        | ●       |

If a page row is all-blank, it's a candidate for cutting. If a column
is empty, the product thesis has a gap.

---

## §10 Global Behaviors

Cross-page conventions written once so each page section can reference
them rather than restate them. Visual rules belong in `design.md`; this
section keeps only **layout/data topology** that crosses pages.

### §10.1 Tab bar visibility

The bottom tab bar is visible on the 3 root tabs (§2 Home · §3
Community · §7 Message List) and hidden on detail / chat / modal
surfaces. Visibility on §4 Q&A List is `[open]` — see §11.

### §10.2 Card adapter rule

Pages never bind Models directly into rendered components. Each page
declares an adapter (e.g. `toCardData() / toItemData() / toHeroData()`)
that maps a Model to the props its component needs. Living examples:
§3 Community, §6 Volunteer Match, §7 Message List.

### §10.3 Shared Context mounting

Any ABConversation initiated via the §5 → §6 → §8 flow carries the
originating ABQAPost into §8 Chat as ABSharedContext, mounted at the
top of the conversation, above the first message, persisting across
re-entries (it is not a one-time banner).

---

## §11 Open Questions

Decisions that block this spec from going final. Each must either fold
into the relevant page section, or be explicitly deferred.

- **Empty-button targets** — §1.A5/§1.A6 navigation, §4 "Ask a Question"
  CTA, §5 "Match a volunteer" CTA, §8 action pills.
- **Empty / loading / error states** — none of the 8 pages currently
  render a non-mock state in v1 SwiftUI. Spec'd as v2 work?
- **Data plumbing** — how does the captured ABUser reach §2/§4/§6 as
  filter input? Options: `@Observable` AppState, `EnvironmentObject`,
  or hardcoded mock filter for prototype only.
- **v1 empty closures** — spec'd as v1 acceptance criteria, or
  deferred to v2?
- **Tab bar on §4 Q&A List** — visible (consistent with root tabs) or
  hidden (treats Q&A List as a deep filter view)?
- **Featured Guide selection** — v1 currently `ABMockData.guides[0]`;
  filter-driven in v1 or v2?
- **In-flow translation** — when the user changes `language` mid-
  Onboarding, does in-page copy live-translate or only on next launch?

---

## §12 Verification

The prototype is **spec-aligned** when:

1. For each filled page (§1–§8), the SwiftUI file under
   `ABDesignSystem/Sources/Pages/` renders the layout described and
   the actions table matches its closures.
2. Every Open Question in §11 is resolved — folded into the relevant
   page section, or explicitly deferred.
3. The flows in §11 / Page Map (§0.5) reproduce end-to-end via Xcode
   Canvas previews.

A page is **section-aligned** (per-PR bar) when its Parameters,
Actions, and Layout match its SwiftUI file.
