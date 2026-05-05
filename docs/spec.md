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
| Heading     | section title (level: major / section / label) · page hero (headline + subtitle) |
| Selection   | single-select card grid · multi-select card grid · single-select chip row · radio list · segmented control |
| Text        | single-line text input · multi-line text area · search input                  |
| Picker      | city/state picker · date picker · dropdown                                    |
| List        | vertical list · horizontal carousel · category-grouped list                   |
| Toggle      | toggle · tab bar                                                              |
| Block       | hero block · dark hero panel · informational card · banner · tip card · quote block |
| Action      | primary button · text link · floating action button · sticky footer overlay · back bar (title?: optional small heading) |
| Card        | content card · row card · compact card · hero card                            |
| Tag         | tag chip · category chip · status badge                                       |

`section title (level: section)` resolves to the `ABSectionTitle`
component (3-level hierarchy: `.major` for editorial headings,
`.section` for form-section headings, `.label` for tightest fieldset
labels). Layout bullets must specify which level to lock visual
hierarchy across pages.

`page hero (headline + subtitle)` resolves to the `ABPageHero`
component — a content-flow hero with `abHeadlineLg` headline and
optional `abBodySm` muted subtitle. Pair with `back bar` (overlay
above) when the page wants editorial breathing room rather than the
compact `ABHeader.pageTitle` (back + title in one row).

`back bar` resolves to the `ABBackBar` component — a slim (≈56pt)
frosted overlay with a back chevron pinned left and an *optional*
centered small title (`abTitleSm` 14pt Bold, `abOnSurface`). Two
usages, same init:

- `back bar` (no title) — pair with a `page hero` below; the page
  title lives in the content flow.
- `back bar (title: "...")` — for mid-depth pages (forms,
  intermediate views) that want a small page name on the chrome
  itself. Lighter than `ABHeader.pageTitle` (which is 64pt with a
  20pt `abHeadlineMd` title) — pick `back bar` for editorial
  density, `ABHeader.pageTitle` for compact detail pages.

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

### 0.5b Copy authority

When a region needs concrete copy (preview / canvas / screenshot /
demo), the source-of-truth precedence is:

1. **`docs/mockups/*.html`** — design-stage product copy. Highest
   authority because it is the artefact a designer signed off on.
2. **`Pages/*.swift` string literals** — implementation-stage copy.
   Treated as a developer's adaptation; does not override mockups.
3. **Self-authored placeholder** — only when neither of the above
   covers a region; mark with `// TODO: copy` so it is grep-able.

If `Pages/*.swift` and `docs/mockups/` disagree on a string, the
mockup wins and the SwiftUI string is the bug. (Discovered during the
§1/§2 spec-vs-prototype experiment: v1 SwiftUI used "Continue" /
"Hi, Amara" / "Heads-up" while mockups specify "Finish Setup" /
"G'day, Welcome Home." / "Tailored for New Arrivals". Mockups are
authoritative.)

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

Vertical-scroll form with a back-bar overlay on top and a sticky
footer overlay at the bottom; the page hero lives in the content
flow, not in the back bar.

1. **Back bar overlay** — back bar (frosted)
2. **Page hero** — page hero (headline + subtitle)
3. **Language section** — section title (level: section) + single-select card grid (6 options, 2 cols; each card: flag + language name) (§1.A1)
4. **Status section** — section title (level: section) + single-select icon-card grid (4 options, 2 cols; each card: icon + label) (§1.A2)
5. **Location section** — section title (level: section) + city/state picker (§1.A3)
6. **Duration section** — section title (level: section) + single-select chip row (5 options, wraps) (§1.A4)
7. **Tip card** — informational card (title + body)
8. **Sticky footer overlay** — primary button "Finish Setup" (§1.A5) + text link "Skip for now" (§1.A6)

---

## §2 Home

> M2 — contextual home hub; push, not pull. Recommendations and the
> Featured Guide are pre-filtered against the captured ABUser.

### Overview

Home is the first surface a returning user lands on after onboarding,
acting as a profile-driven push layer rather than a generic hub. It
greets the user, exposes a search entry, lays out the 10 essential
service categories as quick jumps, and lifts one Featured Guide plus
a list of recommendations chosen by the user's profile (status ×
duration × language). The page reverses the discovery gap surfaced
in user research ("I only knew about that service because a friend
mentioned it") — instead of waiting for the user to know what to
look for, Home surfaces what likely matches their stage.

### Feature

**Parameters**

| Field           | Type                  | Values                                                                                          | Required | Default                  |
| --------------- | --------------------- | ----------------------------------------------------------------------------------------------- | :------: | ------------------------ |
| searchText      | String                | free text                                                                                       |    no    | `""`                     |
| selectedTab     | ABTab                 | home · community · profile                                                                      |   yes    | home                     |
| services        | [ABServiceCategoryType] | job · housing · healthcare · visa · bank · education · transport · social · finance · utilities |   yes    | derived from `ABServiceCategoryType.allCases` |
| featuredGuide   | ABGuide               | resolved from ABMockData; selection rule [open §11]                                             |   yes    | `ABMockData.guides[0]`   |
| recommendations | [ABGuide]             | resolved from ABMockData; filter rule [open §11]                                                |   yes    | `ABMockData.guides.dropFirst()` |

**Actions**

| ID    | Trigger                              | Effect                                                                       |
| ----- | ------------------------------------ | ---------------------------------------------------------------------------- |
| §2.A1 | type in search bar                   | bind to local state `searchText`; submit target [open §11]                   |
| §2.A2 | tap a service category icon          | navigation target [open §11] — currently no closure in v1                    |
| §2.A3 | tap the Featured Guide card          | navigation target [open §11]                                                 |
| §2.A4 | tap a recommendation card            | navigation target [open §11]                                                 |
| §2.A5 | tap a tab in the bottom tab bar      | switch `selectedTab`; root-tab routing [open §11]                            |

### Layout

Vertical-scroll page with a fixed bottom tab bar overlay.

1. **Brand header** — header bar (brand variant)
2. **Search hero** — dark hero panel (centered brand-font greeting on `abPrimaryGradientEditorial`; frosted search input below) (§2.A1)
3. **Services grid** — section title (level: major) + horizontal-flowing icon grid (10 items derived from `ABServiceCategoryType.allCases`; label below each icon) (§2.A2)
4. **Featured section** — section title (level: major) + hero card (title + description) (§2.A3)
5. **Recommendations section** — section title (level: major) + vertical list of content cards; each card contains tag chip (first tag of `ABGuide.tags`, style mapped per design.md) + title + description + read-time caption (§2.A4)
6. **Bottom tab bar overlay** — tab bar (3 items: Home / Community / Profile) (§2.A5)

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

`ABTab` has 3 cases: `home · community · profile`. The bottom tab
bar is visible on §2 Home · §3 Community and on whatever §3 surfaces
the Profile tab. It is hidden on detail / chat / modal surfaces (§4 §5
§6 §8). Visibility on §4 Q&A List, the destination of the Profile
tab, and the entry point for §7 Message List are all `[open]` — see §11.

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
- **§7 Message List entry point** — `ABTab` only has 3 cases (home /
  community / profile). Is Message List reached via the Profile tab,
  via a header icon on §2/§3, or does the tab bar grow a 4th case?
- **Profile tab destination** — what page does `selectedTab = .profile`
  show? Not currently specified anywhere.
- **Search submit / category-tap navigation** — §2.A1 / §2.A2 currently
  have no closures in v1. Spec'd as v1 acceptance or deferred to v2?
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
