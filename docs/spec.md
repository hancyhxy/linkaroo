# AussieBridge — Feature Specification

> Page-by-page feature definitions for the iOS prototype. Covers the
> sections that compose each page, the data each section consumes /
> writes, the interactions that fire (incl. currently empty closures),
> and the edge cases (empty / loading / error / skip).
>
> **Status:** skeleton. Sub-sections are stubbed — bodies will be filled
> per page in subsequent passes. See §6 Open Questions for what blocks
> `final`.

This spec assumes:
- **Why** the product exists → `docs/product-context.md` (5 Context-First mechanisms)
- **Visual grammar** (colors / typography / elevation / components) → `docs/design.md`
- **Data entities + relationships** → `docs/struct.md` (22 entities, 5 layers)
- **Repository layout / how to run** → `README.md`

This spec does **not** redefine those. It only writes what each page does
on top of them.

---

## 0. Conventions

How to read and write this document so it stays a thin reference layer
rather than a re-statement of the other docs.

- **Token references** — write design tokens as bare names
  (`surface-container-low`, `spacing-4`, `display-lg`). Resolution lives
  in `design.md` §2 / §3 / §4.
- **Entity references** — point at `struct.md` sections rather than
  re-listing fields. Format: `ABQAPost (struct.md §2)`.
- **Cross-page navigation** — `→ QADetailView` for forward navigation;
  `← QAListView` for back-stack semantics.
- **Status badges** for individual line items:
  - `[shipped]` — already implemented in v1 SwiftUI
  - `[pending]` — decided but unimplemented
  - `[open]` — still needs decision (must also appear in §6)

---

## 1. Onboarding

> Mechanism 1 — identity capture, the first context filter. Profile
> drives every downstream feed.

### 1.1 Purpose & data flow
- _to fill_ — one sentence on what this page captures and where the
  resulting `ABUser` flows to.

### 1.2 Layout (top to bottom)
- _to fill_ — section list, each line names the `design.md` pattern.

### 1.3 Language Selection
- Card grid · selected state · default · table of supported `ABLanguage`
  values (struct.md §1).

### 1.4 Status Selection
- Icon grid · `ABUserStatus` enum (4 values) · required.

### 1.5 Location Picker
- City + state · `ABLocation` (struct.md §1) · cities table.

### 1.6 Duration Chips
- `ABDuration` 5-bucket chips · required.

### 1.7 Continue / Skip Actions
- **Continue** target [open] · **Skip** target [open] — defines the two
  empty closures that block onboarding from working in v1.
- Validation table (Field / Rule / Error Message).

### 1.8 Models touched
- Reads: _to fill_ · Writes: `ABUser` to app-level state ([open] —
  store mechanism, see §6).

### 1.9 Edge cases
- Re-entering the app after onboarding — skip on launch?
- Skip path → how does HomeView fall back without a profile?
- Locale switch mid-flow — does in-page copy translate live?

---

## 2. Home

> Mechanism 2 — contextual home hub; push, not pull. Recommendations
> and Featured Guide pre-filtered against the captured profile.

### 2.1 Purpose & data flow
### 2.2 Layout (top to bottom)
### 2.3 Search Hero
### 2.4 Service Category Grid
- 10 categories table — `ABServiceCategoryType` enum (struct.md §2).
### 2.5 Featured Guide Card
- `ABGuide` selection logic [open] — currently `ABMockData.guides[0]`.
### 2.6 Recommendations List
- Filtering rule against `ABUser` profile [open].
### 2.7 Tab Bar Interaction
- See §10.1 ABTabBar global rules.
### 2.8 Models touched
### 2.9 Edge cases
- Empty profile (Skip path) — what does Recommendations show?
- No matching guide for current `(status × duration)` combination?

---

## 3. Community

> Supports mechanisms 2 + 3 — segmented entry to Q&A vs people-to-help.

### 3.1 Purpose & data flow
### 3.2 Layout (top to bottom)
### 3.3 Segment Control (Discussions / People to help)
### 3.4 Discussions List
- Adapter: `ABQAPost.toCardData()` — see §10.2 Card adapter rule.
### 3.5 People-to-Help Horizontal Cards
- `ABHelpRequest` (struct.md §3).
### 3.6 Cross-segment behaviour
- State preservation when switching tabs?
### 3.7 Models touched
### 3.8 Edge cases

---

## 4. Q&A List

> Mechanism 3 — credibility tags surfaced at list level.

### 4.1 Purpose & data flow
### 4.2 Layout (top to bottom)
### 4.3 CTA Banner ("Ask a Question")
- Action target [open] — currently empty closure.
### 4.4 Category Tabs (horizontal)
- All 10 `ABServiceCategoryType` + "All" — table.
### 4.5 QA Post Card
- `ABContentTag` ordering rule — STUDENT MATCH > GOVERNMENT VERIFIED >
  TOP ANSWER > UNVERIFIED > OLD LAW (see §10.3).
### 4.6 Card Tap Action
- `→ QADetailView` with selected `ABQAPost`.
### 4.7 Models touched
### 4.8 Edge cases
- Empty category (no posts in selected filter)?
- All-old-law thread surfacing rule?

---

## 5. Q&A Detail

> Mechanism 3 + bridge into mechanism 4 — single thread + Top Answer +
> match-volunteer escalation.

### 5.1 Purpose & data flow
### 5.2 Layout (top to bottom)
### 5.3 Tag Row
- Same ordering rule as §4.5.
### 5.4 Title + Author Meta
### 5.5 Content Body
- Typography: `body-lg` · 1.6 line-height (design.md §3 — "language as
  a meta-barrier" rationale).
### 5.6 Top Answer Quote Block
- `ABTopAnswer` (struct.md §2) · embedded, optional.
### 5.7 Vote / Comment Stats
### 5.8 Match-a-Volunteer CTA
- `→ VolunteerMatchView` with originating `ABQAPost` carried forward
  (becomes `ABSharedContext` in §8 ChatView).
- Currently empty closure — defines the navigation target [open].
### 5.9 Models touched
### 5.10 Edge cases
- No Top Answer yet — block hidden vs placeholder?
- Post tagged `OLD LAW` — does CTA still show, or is it disabled?

---

## 6. Volunteer Match

> Mechanism 4 — algorithm legibility via visible match reasons.

### 6.1 Purpose & data flow
### 6.2 Layout (top to bottom)
### 6.3 Hero Match Card
- `ABMatchResult` top entry · `matchPercentage` display rule.
- "Why she's a match for you" reasons list — render every `matchReason`
  (no truncation; legibility > density).
### 6.4 More Matches (compact cards)
### 6.5 Initiate Conversation Action
- Creates `ABConversation` + mounts originating `ABQAPost` as
  `ABSharedContext` → `ChatView`.
### 6.6 Models touched
### 6.7 Edge cases
- No matches above threshold — what shows?
- Match reasons empty — degrade gracefully?

---

## 7. Message List (Inbox)

> Mechanism 5 — inbox / re-entry surface.

### 7.1 Purpose & data flow
### 7.2 Layout (top to bottom)
### 7.3 Segment Control (All / Unread)
- Unread badge count = `conversations.filter(\.isUnread).count`.
### 7.4 Conversation Row
- Avatar + online indicator + participant + last message + timestamp.
- Adapter: `ABConversation.toItemData()`.
### 7.5 Row Tap Action
- `→ ChatView` with selected `ABConversation` (preserves attached
  `ABSharedContext`).
### 7.6 Models touched
### 7.7 Edge cases
- Empty inbox — first-time-user copy?
- All-read state for Unread tab?

---

## 8. Chat

> Mechanism 5 — context-aware chat with shared-context handoff.

### 8.1 Purpose & data flow
### 8.2 Layout (top to bottom)
### 8.3 Header
- Participant name + online status; back affordance `← MessageListView`.
### 8.4 Shared Context Card
- `ABSharedContext` mounting rule — see §10.4.
- Always at top of conversation, persists across re-entries.
### 8.5 Action Pills (horizontal scroll)
- `ABContentAction` set: Share My Profile Tags / Ask about the Q&A post
  / Suggest a 5-min call.
- Each pill action target [open].
### 8.6 Date Separator
### 8.7 Message Bubbles
- Self vs other styling · timestamp grouping rule.
### 8.8 Input Area
- `@State draft` · onSend rule · empty-input disabled-send rule.
### 8.9 Models touched
### 8.10 Edge cases
- Conversation opened without a `SharedContext` (e.g. direct DM, no
  Q&A origin) — does the card hide or show a default?
- Long shared-context preview — collapse rule?

---

## 9. Mechanism × Page coverage matrix

A grid that proves the 5 Context-First mechanisms each land on at least
one page, and no page is mechanism-orphaned.

|                          | M1 Identity | M2 Home Hub | M3 Tags | M4 Match | M5 Chat |
| ------------------------ | :---------: | :---------: | :-----: | :------: | :-----: |
| 1. Onboarding            | ●           |             |         |          |         |
| 2. Home                  |             | ●           |         |          |         |
| 3. Community             |             | ●           | ●       |          |         |
| 4. Q&A List              |             |             | ●       |          |         |
| 5. Q&A Detail            |             |             | ●       | ● (CTA)  |         |
| 6. Volunteer Match       |             |             |         | ●        |         |
| 7. Message List          |             |             |         |          | ●       |
| 8. Chat                  |             |             |         |          | ●       |

If a future page has all-blank row, it's a candidate for cutting. If a
mechanism column is empty, the product thesis has a gap.

---

## 10. Global Behaviors

Cross-page conventions written once so each page section above can
reference them by §10.x rather than re-stating.

### 10.1 Tab Bar
- Always visible on Home / Community / Message List ([open] — visible
  on Q&A pages too?).
- Hidden on modal / detail / chat surfaces.
- Selected-state color: `primary` gradient.

### 10.2 Card adapter rule
- Pages never render Models directly. Each page's adapter
  (`toCardData()` / `toItemData()` / `toHeroData()`) maps a Model to the
  exact props its component needs. Living examples: `Pages/CommunityView`,
  `Pages/MessageListView`, `Pages/VolunteerMatchView`.

### 10.3 Tag ordering and rendering rule
- Render `ABContentTag`s in this severity-aware order:
  STUDENT/SENIOR MATCH → GOVERNMENT VERIFIED → TOP ANSWER → NEW →
  UNVERIFIED → OLD LAW.
- Width-overflow rule: wrap; never horizontal-scroll inside a card.
- `OLD LAW` always renders strikethrough, even when it would be
  ordering-deprioritised.

### 10.4 Shared Context mounting rule
- An `ABConversation` initiated from `QADetailView → VolunteerMatchView`
  carries the originating `ABQAPost` into the resulting Chat as
  `ABSharedContext`.
- The card mounts at the top of the chat, above the first message, and
  persists across re-entries (it is not a one-time banner).

### 10.5 Empty / loading / error states
- Default: every list page has a designed empty state (illustration +
  one-line copy + optional CTA).
- Loading: skeleton rows for lists; spinner for hero / detail.
- Error: in-line retry on the page that failed (not a full-screen
  takeover) [open] — confirm with iOS HIG before locking.

### 10.6 Navigation back-stack
- Forward navigation via standard SwiftUI `NavigationStack` push.
- Back-swipe always available; modal sheets dismiss on backdrop tap
  with no unsaved-content confirmation (prototype reduces friction).

---

## 11. Cross-page flows

Three named end-to-end journeys; each is ≤ 6 numbered steps and calls
out which entity travels between pages.

### 11.1 First-launch flow
Onboarding → Home — captured `ABUser` profile drives Home filtering.

### 11.2 Q&A → human help flow
QAList → QADetail → VolunteerMatch → Chat — originating `ABQAPost`
mounts as `ABSharedContext` in the resulting chat.

### 11.3 Inbox re-entry flow
MessageList → Chat — resume an existing conversation with its
persisted `ABSharedContext` still attached.

---

## 12. Open Questions

Decisions that block this spec from being final. Each must either be
folded into the relevant §1–§8 page section, or explicitly deferred to
a future version, before the affected page section is authoritative.

- **Empty-button targets** — Onboarding `Continue` / `Skip` (§1.7) ·
  QADetail `Match a volunteer` (§5.8) · QAList `Ask a Question` (§4.3) ·
  Chat action pills (§8.5).
- **Empty / loading / error states** — none of the 8 pages currently
  render a non-mock state (see §10.5).
- **Data plumbing** — how does the onboarding profile (`ABUser`) reach
  Home / Q&A feeds? Options: app-level `@Observable` store,
  `EnvironmentObject`, or hardcoded mock filter for prototype only.
- **v1 empty closures** — spec'd as v1 acceptance criteria, or deferred
  as v2 work? Affects whether `Match a volunteer` must navigate in v1.
- **Tab bar visibility** — visible on Q&A pages or hidden? (§10.1)
- **Featured Guide selection** — currently `ABMockData.guides[0]`;
  should it be filter-driven for v1 or only for v2? (§2.5)
- **In-flow translation** — does Onboarding (and elsewhere) live-
  translate UI copy when the user changes language mid-flow? (§1.9)

---

## 13. Verification

After the spec is filled, the prototype is **spec-aligned** when:

1. For each of the 8 pages (§1–§8), the SwiftUI file under
   `ABDesignSystem/Sources/Pages/` renders the layout described.
2. Every Open Question in §12 is resolved — folded into the relevant
   page section, or explicitly deferred to a future version (v3).
3. The three flows in §11 can be reproduced end-to-end via Xcode Canvas
   previews (and, once an installable target exists, on a real device).

A page is **section-aligned** (a smaller bar, useful per-PR) when its
§1–§8 entry's *Layout* and *Interactions* sub-sections match its
SwiftUI file.
