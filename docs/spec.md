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
| Selection   | single-select card grid · multi-select card grid · single-select chip row · radio list · segmented control · horizontal category tabs |
| Text        | single-line text input · multi-line text area · search input · chat input area |
| Picker      | city/state picker · date picker · dropdown                                    |
| List        | vertical list · horizontal carousel · category-grouped list · message row list · chat thread (date separator + bubble stream) |
| Toggle      | toggle · tab bar                                                              |
| Block       | hero block · dark hero panel · informational card · banner · tip card · quote block · CTA banner · shared context card · match-reasons list |
| Action      | primary button · text link · floating action button · sticky footer overlay · back bar (title?: optional small heading) · action pill row |
| Card        | content card · row card · compact card · hero card                            |
| Tag         | tag chip · category chip · status badge · match-percent badge                 |

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
left-aligned title sitting next to the chevron (`abTitleLg` 18pt
Bold, `abOnSurface`, brand-strip style — not iOS centered nav-bar
style). Two usages, same init:

- `back bar` (no title) — pair with a `page hero` below; the page
  title lives in the content flow as a long welcome headline.
- `back bar (title: "...")` — pair with a `page hero` below as well,
  but the back bar shows a *short nav-context label* (e.g.
  "Profile Setup") next to the chevron. The two titles play distinct
  roles: back bar = "where am I in the flow" (short, stable);
  page hero = "what should I do here" (long, welcoming). Both
  exist on the same page when navigation context matters.

Pick `ABHeader.pageTitle` instead for compact detail pages (Q&A
Detail, Volunteer Match) where one taller 64pt header replaces the
back-bar + page-hero pair entirely.

`horizontal category tabs` resolves to the `ABHorizontalCategoryTabs`
component — a horizontally scrolling row of pill-shaped category
filters with optional SF-Symbol icons; a single selection drives the
list below it.

`CTA banner` resolves to the `ABCTABanner` component — a primary-tinted
panel with title + body + a single primary button, used to invite a
high-value action (e.g. "Ask a Question" on §4).

`shared context card` resolves to the `ABSharedContextCard` component —
a pinned card at the top of a chat thread that links back to the
originating ABQAPost. Persists across re-entries (see §10.3).

`action pill row` resolves to a horizontal scroll of `ABActionPill`
items — short context-aware shortcuts (e.g. "Share My Profile Tags",
"Suggest a Call") sitting between the shared context card and the
first message.

`chat input area` resolves to `ABChatInputArea` — a fixed-bottom text
area with an attachment / mic / send affordance. Pinned to the bottom
of the chat surface, sibling to (not inside) the scroll view.

`chat thread` is the composite of `ABDateSeparator` + a stream of
`ABChatBubble` items aligned by `ABMessageDirection` (incoming = left,
outgoing = right).

`message row list` resolves to a vertical list of `ABMessageItem`
rows — avatar (with online dot) + name + preview + timeAgo + unread
indicator. Used by §7 Message List.

`match-reasons list` resolves to a checkmark-prefixed bulleted list
sitting inside an `ABCard(.standard)` directly under the volunteer
hero — renders `ABMatchResult.matchReasons` so the matching algorithm
is legible to the user (Mechanism 4).

`match-percent badge` resolves to `ABTag(style: .matchPercent)` — a
small numeric badge ("98% Match") rendered next to a `tag chip
(style: gold)` "TOP CHOICE" on §6.

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

1. **Back bar overlay** — back bar (title: "Profile Setup")
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

Community is the social spine of the app: a single page with two
segments toggling between *what the user can read / ask* (Discussions)
and *what the user can give back* (People to help). The segmented
control is intentional — it folds two different mental models
("seeking" vs "contributing") into one tab so a returning user does
not feel siloed into one role. Discussions surfaces ABQAPost rows;
People to help surfaces ABHelpRequest rows where the current user's
profile (status × duration × language) overlaps with the requester's
need. Both segments feed into the same downstream surfaces (§5 Q&A
Detail / §8 Chat) — Community is a discovery layer, not a destination.

### Feature

**Parameters**

| Field         | Type                | Values                                   | Required | Default            |
| ------------- | ------------------- | ---------------------------------------- | :------: | ------------------ |
| segment       | CommunitySegment    | discussions · peopleYouCanHelp           |   yes    | discussions        |
| selectedTab   | ABTab               | home · community · profile               |   yes    | community          |
| qaPosts       | [ABQAPost]          | resolved from `ABMockData.qaPosts`       |   yes    | `ABMockData.qaPosts` |
| helpRequests  | [ABHelpRequest]     | resolved from `ABMockData.helpRequests`  |   yes    | `ABMockData.helpRequests` |

**Actions**

| ID    | Trigger                              | Effect                                                                       |
| ----- | ------------------------------------ | ---------------------------------------------------------------------------- |
| §3.A1 | tap a segment                        | set local state `segment` to tapped value                                    |
| §3.A2 | tap a Q&A post card (Discussions)    | → §5 Q&A Detail with the tapped `ABQAPost`                                   |
| §3.A3 | tap a help-request card (People)     | navigation target [open §11] — escalation path to §6 / §8 not yet wired      |
| §3.A4 | tap a tab in the bottom tab bar      | switch `selectedTab`; root-tab routing [open §11]                            |

### Layout

Vertical-scroll page with a fixed bottom tab bar overlay; segmented
control swaps the body between two layouts.

1. **Header bar** — header bar (page-title variant, no back) — title "Community"
2. **Segment selector** — segmented control (2 options: "Discussions" / "People to help") (§3.A1)
3. **Discussions body** *(when `segment == discussions`)* — vertical list of content cards (one per `ABQAPost`; tap target §3.A2)
4. **People-to-help body** *(when `segment == peopleYouCanHelp`)* — section title (level: section) + horizontal carousel of content cards (one per `ABHelpRequest`; tap target §3.A3)
5. **Bottom tab bar overlay** — tab bar (3 items: Home / Community / Profile) (§3.A4)

---

## §4 Q&A List

> M3 — credibility tags surfaced at list level so non-native readers
> can parse trust without parsing prose.

### Overview

Q&A List is the deep filter view into discussions: a single category
axis (All / Renting / Subletting / Utilities / Visa) on top of a
Reddit-style list. Each row carries the `ABContentTag` set inline so
a reader can parse credibility (verified · outdated · source) before
parsing the title — closing the gap where non-native English readers
spend more effort assessing trust than reading content. A CTA banner
above the list invites the user to author a new question, framing the
list as a participation surface rather than a read-only feed.

### Feature

**Parameters**

| Field              | Type                | Values                                                          | Required | Default            |
| ------------------ | ------------------- | --------------------------------------------------------------- | :------: | ------------------ |
| selectedCategoryId | String              | "all" · "renting" · "subletting" · "utilities" · "visa"         |   yes    | "all"              |
| selectedTab        | ABTab               | home · community · profile                                      |   yes    | community          |
| posts              | [ABQAPost]          | resolved from `ABMockData.qaPosts`; filter by `selectedCategoryId` [open §11] | yes | `ABMockData.qaPosts` |

**Actions**

| ID    | Trigger                              | Effect                                                                       |
| ----- | ------------------------------------ | ---------------------------------------------------------------------------- |
| §4.A1 | tap "Ask a Question"                 | navigation target [open §11] — author-flow page not yet built                |
| §4.A2 | tap a category tab                   | set local state `selectedCategoryId` to tapped value                         |
| §4.A3 | tap a Q&A post card                  | → §5 Q&A Detail with the tapped `ABQAPost`                                   |
| §4.A4 | tap a tab in the bottom tab bar      | switch `selectedTab`; root-tab routing [open §11]                            |

### Layout

Vertical-scroll page; tab bar visibility [open §11 — see §10.1].

1. **Header bar** — header bar (page-title variant, with back) — title "Q&A & Guides"
2. **CTA banner** — CTA banner with primary button "Ask a Question" (§4.A1)
3. **Category filter** — horizontal category tabs (5 items: All / Renting / Subletting / Utilities / Visa) (§4.A2)
4. **Posts list** — vertical list of content cards (one per filtered `ABQAPost`; each card carries inline tag chips for credibility / source) (§4.A3)
5. **Bottom tab bar overlay** *(if visible)* — tab bar (3 items: Home / Community / Profile) (§4.A4)

---

## §5 Q&A Detail

> M3 + bridge into M4 — single thread + Top Answer + match-volunteer
> escalation. The originating ABQAPost rides forward as ABSharedContext
> when the user escalates to a volunteer chat.

### Overview

Q&A Detail is the inflection point of the product: it presents a
single Reddit-style thread with credibility tags pre-parsed and the
Top Answer surfaced as a quote block, but its load-bearing role is
to escalate the reader from passive reading into a 1-on-1 match. The
"Match a volunteer" CTA at the bottom forks the user into §6, and the
originating ABQAPost rides forward as `ABSharedContext` when the user
eventually lands in §8 Chat — see §10.3. The page is intentionally
linear (no comments thread in v1): the choice is *trust the answer
and act* vs *escalate to a human*, not *scroll deeper*.

### Feature

**Parameters**

| Field | Type      | Values                                                                          | Required | Default                  |
| ----- | --------- | ------------------------------------------------------------------------------- | :------: | ------------------------ |
| post  | ABQAPost  | injected by caller (§3.A2 / §4.A3); contains tags · author · topAnswer · source |   yes    | `ABMockData.qaPosts[0]`  |

**Actions**

| ID    | Trigger                              | Effect                                                                                                  |
| ----- | ------------------------------------ | ------------------------------------------------------------------------------------------------------- |
| §5.A1 | tap header back chevron              | dismiss; → previous surface (§3 Community or §4 Q&A List)                                               |
| §5.A2 | tap "Match a volunteer"              | → §6 Volunteer Match; `post` is captured as the originating ABQAPost for downstream §10.3 mounting       |

### Layout

Vertical-scroll detail page using the compact 64pt header; no tab bar
on this surface (§10.1 — detail / chat / modal hides the tab bar).

1. **Header bar** — header bar (page-title variant, with back) — title "Q&A"
2. **Tag row** — horizontal row of tag chips (one per `post.tags`; styles drive credibility legibility — verified / unverified / outdated / source / contextMatch)
3. **Title + meta** — section title (level: section) headline + caption row (author username · time-ago)
4. **Body paragraph** — paragraph rendering `post.fullContent` (falls back to `post.preview` when empty)
5. **Top Answer block** *(when `post.topAnswer != nil`)* — quote block (header text "Top Answer · Verified" when `topAnswer.isVerified`, else "Top Answer")
6. **Stats row** — caption row (vote count · comment count)
7. **Match CTA section** — informational card (title + body + primary button "Match a volunteer" (§5.A2))

---

## §6 Volunteer Match

> M4 — algorithm legibility via visible match reasons. Every matched
> volunteer renders the explicit reasons they fit, not just a score.

### Overview

Volunteer Match is the page where the matching algorithm becomes
*legible*: instead of presenting a black-box score, every matched
volunteer is paired with the explicit reasons they fit (e.g. "UNSW
alumna · NSW Renting Specialist · speaks Mandarin"). The hierarchy is
deliberately steep — one Top Choice rendered as a hero card with a
checkmark-bulleted reasons list, then a smaller stack of additional
matches. The hero treatment carries the algorithmic claim; the
secondary list shows alternates without forcing the user to compare
five symmetric tiles. Choosing a volunteer initiates §8 Chat with
the originating ABQAPost mounted as ABSharedContext (see §10.3).

### Feature

**Parameters**

| Field      | Type             | Values                                                          | Required | Default                  |
| ---------- | ---------------- | --------------------------------------------------------------- | :------: | ------------------------ |
| matches    | [ABMatchResult]  | resolved from `ABMockData.matchResults`; ordered by selection rule [open §11] | yes | `ABMockData.matchResults` |
| topChoice  | ABMatchResult?   | first match where `isTopChoice == true`, else `matches.first`   |   yes    | derived                  |

**Actions**

| ID    | Trigger                              | Effect                                                                       |
| ----- | ------------------------------------ | ---------------------------------------------------------------------------- |
| §6.A1 | tap header back chevron              | dismiss; → previous surface (typically §5 Q&A Detail)                        |
| §6.A2 | tap Top Choice hero card (or its CTA)| → §8 Chat with the chosen volunteer; mount originating ABQAPost as `ABSharedContext` per §10.3 |
| §6.A3 | tap a More-matches card (or its CTA) | → §8 Chat with the chosen volunteer; mount originating ABQAPost as `ABSharedContext` per §10.3 |

### Layout

Vertical-scroll detail page using the compact 64pt header; no tab bar
on this surface.

1. **Header bar** — header bar (page-title variant, with back) — title "Best matches for you"
2. **Top Choice hero** — tag-chip pair (style: gold "TOP CHOICE" + match-percent badge) + hero card (volunteer hero) + match-reasons list (§6.A2)
3. **More matches section** — section title (level: label, uppercase tracking) + vertical list of compact cards (one per non-top-choice `ABMatchResult`) (§6.A3)

---

## §7 Message List

> M5 — inbox / re-entry surface. Existing conversations preserve their
> ABSharedContext on re-open.

### Overview

Message List is the re-entry surface for conversations the user
previously opened — usually those that originated from a §5 → §6 → §8
escalation. The page is intentionally inbox-shaped: an `All / Unread`
segment is the only filter, the unread segment carries a numeric
badge, and each row shows online-state on the avatar. Tapping a row
returns to §8 Chat with the same `ABSharedContext` still mounted at
the top of the thread (see §10.3) — re-entry is not a fresh page,
it's a continuation. The entry point into this surface is currently
[open §11].

### Feature

**Parameters**

| Field          | Type                | Values                                            | Required | Default                  |
| -------------- | ------------------- | ------------------------------------------------- | :------: | ------------------------ |
| segment        | MessageSegment      | all · unread                                      |   yes    | all                      |
| conversations  | [ABConversation]    | resolved from `ABMockData.conversations`; filtered by `segment` (`isUnread` true when `unread`) | yes | `ABMockData.conversations` |
| unreadCount    | Int                 | derived: count where `conversations.isUnread == true` | yes  | derived                  |

**Actions**

| ID    | Trigger                              | Effect                                                                       |
| ----- | ------------------------------------ | ---------------------------------------------------------------------------- |
| §7.A1 | tap header back chevron              | dismiss; → previous surface (entry point [open §11])                          |
| §7.A2 | tap a segment                        | set local state `segment` to tapped value                                    |
| §7.A3 | tap a conversation row               | → §8 Chat with the tapped `ABConversation` (preserves its `sharedContext`)   |

### Layout

Vertical-scroll inbox using the compact 64pt header; no tab bar on
this surface.

1. **Header bar** — header bar (page-title variant, with back) — title "Messages"
2. **Segment selector** — segmented control (2 options: "All" / "Unread"; "Unread" carries a numeric badge of `unreadCount`) (§7.A2)
3. **Conversations list** — message row list (one row per filtered `ABConversation`; rows separated by hairline dividers) (§7.A3)

---

## §8 Chat

> M5 — context-aware chat. The originating ABQAPost (when present)
> mounts at the top as ABSharedContext and persists across re-entries.

### Overview

Chat is the conversation surface where matches turn into actual help.
Two design moves separate it from a generic 1-on-1 messenger: (a) the
originating ABQAPost is mounted at the very top as a `shared context
card` and stays there across re-entries — so a user returning two days
later still sees *what this conversation was opened to solve*; and
(b) a row of `action pill row` items between the context card and
the first message exposes context-aware shortcuts ("Share My Profile
Tags", "Suggest a Call") so the conversation can move forward without
the user composing prose. The header is the chat-variant header
(avatar + name + online dot), distinct from the page-title variant
used elsewhere.

### Feature

**Parameters**

| Field         | Type                | Values                                           | Required | Default                       |
| ------------- | ------------------- | ------------------------------------------------ | :------: | ----------------------------- |
| conversation  | ABConversation      | injected by caller (§6.A2 / §6.A3 / §7.A3)       |   yes    | `ABMockData.conversations[0]` |
| messages      | [ABChatMessage]     | resolved from `ABMockData.chatMessages`           |   yes    | `ABMockData.chatMessages`     |
| actions       | [ABContextAction]   | resolved from `ABMockData.contextActions`         |   yes    | `ABMockData.contextActions`   |
| draft         | String              | free text (input draft)                          |    no    | `""`                          |
| sharedContext | ABSharedContext?    | `conversation.sharedContext` ?? mock fallback     |    no    | derived                       |

**Actions**

| ID    | Trigger                              | Effect                                                                       |
| ----- | ------------------------------------ | ---------------------------------------------------------------------------- |
| §8.A1 | tap header back chevron              | dismiss; → previous surface (§6 or §7)                                       |
| §8.A2 | tap shared context card              | navigation target [open §11] — return to originating §5 Q&A Detail by `relatedPostID` |
| §8.A3 | tap an action pill                   | per-pill effect [open §11] — currently no closures in v1                     |
| §8.A4 | type in chat input area              | bind to local state `draft`                                                  |
| §8.A5 | tap send                             | append outgoing `ABChatMessage` to `messages`; clear `draft`                  |

### Layout

Fixed-bottom chat surface: header bar pinned top, chat input area
pinned bottom, scrollable thread between them. No tab bar on this
surface.

1. **Header bar** — header bar (chat variant) — avatar + participant name + online dot
2. **Shared context section** *(when `sharedContext != nil`)* — shared context card (§8.A2)
3. **Action pills** — action pill row (one per `ABContextAction`; variant maps to blue / orange) (§8.A3)
4. **Date separator** — chat thread date separator
5. **Messages** — chat thread bubble stream (one `ABChatBubble` per `ABChatMessage`; alignment driven by `direction`; incoming bubbles render avatar fallback initials)
6. **Chat input area** — chat input area pinned to bottom (§8.A4 binds, §8.A5 sends)

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

Decisions that block this spec from going final. Each is referenced by
the relevant `[open §11]` marker in §1–§8; once resolved, the question
folds back into its page section and the marker is replaced with the
concrete decision.

- **Onboarding navigation targets** — §1.A5 / §1.A6 destinations
  (currently both written as "→ §2 Home" but no router exists in v1).
- **Home navigation targets** — §2.A1 search submit, §2.A2 service
  category tap, §2.A3 Featured Guide tap, §2.A4 recommendation tap,
  §2.A5 root-tab routing. Currently no closures in v1; spec'd as v1
  acceptance criteria, or deferred to v2?
- **Community help-request escalation** — §3.A3 destination. Help
  cards in v1 have a button labelled "Answer Mei Lin" / "Help David"
  but no closure. Likely → §8 Chat with the requester, but the
  ABSharedContext source (no originating ABQAPost) is unclear.
- **Q&A List "Ask a Question" target** — §4.A1. No author flow exists
  in v1; deferred to v2?
- **Q&A List filter behavior** — §4.A2: does `selectedCategoryId`
  filter `ABMockData.qaPosts` by `ABServiceCategoryType` rawValue
  match, or is the category axis a separate taxonomy?
- **Tab bar on §4 Q&A List** — visible (consistent with root tabs) or
  hidden (treats Q&A List as a deep filter view)?
- **Volunteer Match selection rule** — §6 currently picks
  `topChoice` as the first match where `isTopChoice == true`. The
  algorithm that *populates* `ABMatchResult.matchReasons` and
  `matchPercentage` is not specified.
- **§5 → §6 → §8 ABSharedContext propagation** — §6.A2 / §6.A3 and
  §10.3 say the originating ABQAPost mounts as ABSharedContext in §8.
  The mechanism (route param, shared store, callback) is not
  specified. Currently v1 falls back to `ABMockData.chatContext`.
- **§7 Message List entry point** — `ABTab` only has 3 cases (home /
  community / profile). Is Message List reached via the Profile tab,
  via a header icon on §2/§3, or does the tab bar grow a 4th case?
- **Profile tab destination** — what page does `selectedTab == .profile`
  show? Not currently specified anywhere; candidate location for
  §7 Message List entry.
- **§8 action pill effects** — §8.A3 currently no closures in v1.
  Each `ABContextAction.text` implies a different effect ("Share My
  Profile Tags" → injects a profile-tag bubble; "Suggest a Call" →
  opens a system call sheet?).
- **§8 shared context tap** — §8.A2 destination: return to §5 by
  `relatedPostID`? Spec'd, not implemented in v1.
- **Empty / loading / error states** — none of the 8 pages currently
  render a non-mock state in v1. Spec'd as v2 work.
- **Data plumbing** — how does the captured ABUser reach §2/§4/§6 as
  filter input? Options: `@Observable` AppState, `EnvironmentObject`,
  or hardcoded mock filter for prototype only.
- **Featured Guide selection** — §2 currently `ABMockData.guides[0]`;
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
