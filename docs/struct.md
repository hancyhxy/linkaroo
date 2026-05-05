# Data Model

This document defines the data model for AussieBridge. It follows the team's shared baseline of 8 core entities, plus individual extensions for the **Context-First** variation.

The 22 entities below are organised into **five layers**, each layer corresponding to one of the Context-First mechanisms (plus a small cross-cutting layer for entities that don't belong to any single mechanism). This grouping is the visible argument that the data model was designed *around* the variation thesis, not retro-fitted to it.

Every field listed here has a 1:1 implementation in `../ABDesignSystem/Sources/Models/ABModels.swift`. Where the document and the code drift, **the code wins** — re-export this document by tracing each `struct` and `enum` declaration.

---

## Reading guide

**Layer legend** (each entity belongs to exactly one):

| Layer | Mechanism it serves | Entities in this layer |
|---|---|---|
| **§1 Identity** | M1 — onboarding captures identity, used as filter input downstream | User · Language · UserStatus · Duration · Location |
| **§2 Curation** | M2 + M3 — context-aware home hub + visible credibility tags | ServiceCategory · Guide · QAPost · TopAnswer · ContentTag |
| **§3 Matching** | M4 — reason-based volunteer matching | Volunteer · SkillTag · MatchResult · HelpRequest · AchievementBadge |
| **§4 Conversation** | M5 — context-aware chat handoff | Conversation · ChatMessage · SharedContext · ContextAction |
| **§5 Cross-cutting** | Not bound to any single mechanism | Translation · Task · Step |

**Origin column legend** (in every field table):

- `team` — defined in the team baseline (8 core entities, agreed across the group)
- `+ context` — added for the Context-First variation
- `+ engineering` — added for SwiftUI implementation needs (e.g. `id`, `createdAt`, computed helpers)

**Type column convention**:

- `String`, `Int`, `Double`, `Bool`, `Date`, `URL`, `UUID` — Swift built-ins
- `[X]` — array of X
- `X?` — optional X (may be nil)
- `→ Y` — references another entity (Y) defined in this doc

**Mutability column**: `let` = immutable once set, `var` = mutable, `computed` = derived from other fields.

---

# §1 — Identity Layer

> **Mechanism 1: Identity awareness.** Onboarding captures the "first context" (language, status, location, time-in-country) and stores it on the User. Every downstream surface — home recommendations, Q&A relevance, volunteer matching — reads from this profile silently. The identity is primarily a *filter*, not a *feature page* — but the **Profile tab (spec §9)** is the one surface that makes the captured identity *visible* to the user, and is also the only entry point into the edit flow (which re-uses `OnboardingView` with the current ABUser prefilled, so identity-capture remains single-sourced).

## 1. User

The core user entity, populated during onboarding and used as the filter input by every Context-First mechanism.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | Stable identifier; Swift `Identifiable` conformance and chat sender resolution depend on this |
| `displayName` | `String` | `var` | team | Maps to baseline `name`. Editable so users can correct typos or change to a preferred form |
| `username` | `String` | `var` | + context | Reddit-style handle (e.g. `u/sarah_m`) shown as Q&A attribution. Decouples `displayName` (UI label) from `username` (community identity) |
| `avatarURL` | `URL?` | `var` | + context | Optional photo; nil triggers initial-letter fallback. Migrants often arrive without a profile photo, so the fallback is part of the design, not an edge case |
| `preferredLanguage` | `→ Language` | `var` | team | Maps to baseline `selectedLanguage`. Drives translation availability and language-tagged content |
| `currentStatus` | `→ UserStatus` | `var` | + context | Identity captured during onboarding (student / working / etc.). The single most predictive filter signal — a student in week 1 needs different content from a working migrant of three years |
| `location` | `→ Location?` | `var` | + context | Structured (city + state) rather than baseline B's "suburb: String", because content filtering needs **state-level** legal/policy granularity (NSW renting law ≠ VIC) |
| `durationInAustralia` | `→ Duration` | `var` | + context | Bucketed (`justLanded`, `1–6mo`, etc.) rather than baseline B's "daysSinceArrival: Int", because UI surfaces change at thresholds, not on continuous numbers |
| `isOnline` | `Bool` | `var` | + context | Drives the green-dot indicator in chat / message list. Implemented as live state, not a computed timestamp |
| `onboardingProgress` | `Double` | `var` | team | 0.0–1.0; surfaces a progress chip in profile so partial onboarding feels resumable, not lost |
| `completedTasks` | `[→ Task]` | `var` | team | Personal checklist of "First 7 Days" items the user has finished. Migrants need a sense of progress through the bureaucratic maze |
| `createdAt` | `Date` | `var` | + engineering | Account creation timestamp; powers cohort analytics ("users who joined in their first week") |
| `initials` | `String` | computed | + engineering | Derived from `displayName` for avatar fallback. Computed (not stored) to stay in sync with name edits |

→ A **User** posts **HelpRequests**, sends **ChatMessages**, owns one **Location**, has one **UserStatus** and one **Duration**, and tracks completion of **Tasks**. Read-back surface: spec §9 Profile renders 4 of the User's onboarding-captured fields (`preferredLanguage`, `currentStatus`, `location`, `durationInAustralia`) and routes the "Edit profile" action back into the §1 OnboardingView form.

---

## 2. Language

User's language preference, exposed both as a User profile field and as a selectable option during onboarding.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `name` | `String` | (rawValue) | team | Display label — baseline `name` |
| `code` | `String` | computed | team | ISO 639-1 (e.g. `en`, `zh`) — baseline `code`. Used for translation API contracts |
| `flagIcon` | `String` | computed | team | Country flag emoji — baseline `flagIcon`. Provides a non-textual recognition cue for L2 readers |

> **Implementation note**: realised as `enum ABLanguage: String, CaseIterable` (6 cases: english / mandarin / spanish / arabic / hindi / other) rather than a `struct`. The team baseline's `isSelected: Bool` is **lifted onto** `User.preferredLanguage` — selection state is owned by the user, not the language. This is a deliberate normalisation, not a missing field.

→ A **Language** is referenced by **User** (as preference), by **HelpRequest** (as request language), and by **Translation** (as source / target).

---

## 3. UserStatus *(Context-First addition)*

Onboarding identity, used as the primary filter signal for the home hub and for Q&A relevance ranking.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `name` | `String` | (rawValue) | + context | Display label shown in onboarding selection card |
| `icon` | `String` | computed | + context | SF Symbol name; the onboarding cards use icons because L2 readers parse icons faster than English status words |

> Cases: `immigrantStudent`, `working`, `lookingForWork`, `businessOwner`. Implemented as `enum ABUserStatus: String`.

→ A **UserStatus** is held by exactly one **User**.

---

## 4. Duration *(Context-First addition)*

Time-in-Australia bucket. Drives the "First 7 Days Checklist" surfacing logic on Home and the urgency tone of recommendations.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `name` | `String` | (rawValue) | + context | Bucket label (e.g. `Just landed`, `1–6 months`) |

> Cases: `notYetArrived`, `justLanded`, `oneToSix`, `sixToTwelve`, `oneYearPlus`. Implemented as `enum ABDuration: String`. **Bucketed not numeric** because UI changes at thresholds (a "just landed" user sees the First 7 Days guide; a "1-year+" user does not), and continuous days-since-arrival would force every screen to declare its own thresholds.

> Conforms to `CustomStringConvertible` (`description == rawValue`) so generic picker components like `ABChipPicker<T: Hashable & CustomStringConvertible>` can display each case without forcing the call-site to declare the conformance.

→ A **Duration** is held by exactly one **User**.

---

## 5. Location *(Context-First addition)*

Structured geographic context. Used to filter content (housing rules per state, transport availability per city).

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `city` | `String` | `var` | + context | E.g. `Sydney`. Drives nearest-volunteer matching and city-specific guides |
| `state` | `String` | `var` | + context | E.g. `NSW`. **Critical** for law-and-policy filtering — renting law differs between NSW and VIC, and a migrant getting the wrong state's rule is worse than no rule at all |
| `latitude` | `Double?` | `var` | + context | For future map rendering (volunteer map, near-me services) |
| `longitude` | `Double?` | `var` | + context | (See latitude) |
| `displayString` | `String` | computed | + engineering | E.g. "Sydney, NSW". Computed so display stays in sync with city/state edits |

→ A **Location** belongs to one **User** (and may be revised when the user moves).

---

# §2 — Curation Layer

> **Mechanisms 2 + 3: Contextual home hub + visible credibility.** The home hub pushes relevant guides (rather than waiting for the user to search), and every piece of community content is tagged with credibility / freshness signals so a non-native English reader can parse trust *visually* without reading every paragraph.

## 6. ServiceCategory

One of the 10 service categories shown on the home grid.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | Stable identifier for ForEach |
| `type` | `→ ServiceCategoryType` | `var` | + context | The 10-case enum (Job / Housing / Healthcare / etc.). Enum-driven rather than free-string so spelling and ordering are guaranteed |
| `displayOrder` | `Int` | `var` | + context | Grid position. Stored separately from enum so we can A/B-test ordering without changing the enum |
| `name` | `String` | computed | + engineering | Human-readable label derived from `type` |
| `icon` | `String` | computed | + engineering | SF Symbol name derived from `type` |

→ A **ServiceCategory** is referenced by **Task**, **QAPost**, **HelpRequest**, and **Guide** for filter/categorisation.

---

## 7. Guide

Recommended article or guide surfaced on the home page (Featured Guide card or "Recommended for you" list).

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `title` | `String` | `var` | + context | Headline shown on the card |
| `description` | `String` | `var` | + context | One-sentence summary; provides preview without forcing a tap |
| `category` | `→ ServiceCategoryType` | `var` | + context | Powers per-category filtering and home-hub relevance ranking |
| `tags` | `[→ ContentTag]` | `var` | + context | E.g. `FEATURED GUIDE`, `STUDENT MATCH`, `NEW`. Tags surface the "why this guide is here" reason at a glance |
| `readTimeMinutes` | `Int` | `var` | + context | Surfaces effort cost up-front. Migrants often have fragmented time and need to know if "this is a 3-min vs 15-min commitment" |
| `isFeatured` | `Bool` | `var` | + context | Promotes the guide to the dark Featured Guide card; drives a different visual treatment, not just sort order |
| `imageURL` | `URL?` | `var` | + context | Cover image for Featured Guide; absent on lightweight recommendation cards |
| `createdAt` | `Date` | `var` | + engineering | Sort signal (newest first by default) and freshness check for the `NEW` tag |
| `readTimeString` | `String` | computed | + engineering | Formatted as "12 min read"; computed to keep formatting consistent across the app |

→ A **Guide** belongs to a **ServiceCategoryType** and carries multiple **ContentTags**.

---

## 8. QAPost

Reddit-style community Q&A thread — the central content unit for community knowledge.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `author` | `→ User` | `var` | + context | Original poster; reference (not embedded copy) so name edits propagate |
| `title` | `String` | `var` | + context | Question headline shown in lists |
| `preview` | `String` | `var` | + context | First ~150 chars for list view. Stored separately so list-rendering doesn't have to truncate at runtime |
| `fullContent` | `String` | `var` | + context | Body text for the detail view |
| `tags` | `[→ ContentTag]` | `var` | + context | The credibility / freshness layer (UNVERIFIED / OLD LAW / TOP ANSWER etc.). **This is the core of M3 visible-credibility** |
| `category` | `→ ServiceCategoryType` | `var` | + context | Drives QA list filter pills and home-hub "trending in Housing" surfacing |
| `voteCount` | `Int` | `var` | + context | Reddit-style upvotes; community signal of usefulness |
| `commentCount` | `Int` | `var` | + context | Engagement signal; drives "needs answer" surfacing when 0 |
| `topAnswer` | `→ TopAnswer?` | `var` | + context | Pinned summary; absent if no answer yet. Embedded (not referenced) because TopAnswer has no identity outside its parent post |
| `verificationStatus` | `→ VerificationStatus` | `var` | + context | Coarse-grained credibility. The fine-grained version is in `tags` — `verificationStatus` is for "should this row show a green check at all?" |
| `source` | `→ ContentSource?` | `var` | + context | Provenance (TikTok / government / official). Optional because community-authored content has no external source |
| `createdAt` | `Date` | `var` | + engineering | Sort key and recency check |
| `timeAgoString` | `String` | computed | + engineering | "4h ago", "2d ago"; computed because absolute timestamps don't help an L2 reader judge freshness |

→ A **QAPost** is authored by a **User**, categorised under **ServiceCategoryType**, tagged with multiple **ContentTags**, may have a **TopAnswer**, and may be referenced from a **SharedContext** when the conversation moves to chat.

---

## 9. TopAnswer

Excerpted top answer pinned to a Q&A post. Embedded inside QAPost rather than its own table — it has no identity outside its parent.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `authorUsername` | `String` | `var` | + context | Attribution; stored as denormalised string because the answer's author may have different display rules from the parent post's author |
| `excerpt` | `String` | `var` | + context | Quoted text (1–3 sentences). Pre-cut to length so list views don't have to wrap arbitrary HTML |
| `isVerified` | `Bool` | `var` | + context | Adds the green-checkmark badge. Independent from `QAPost.verificationStatus` — a verified answer can sit on an outdated question |

→ A **TopAnswer** belongs to exactly one **QAPost** (1:0..1).

---

## 10. ContentTag *(Context-First — core entity)*

Semantic tag attached to Q&A posts, help requests, and recommended guides. **The most-used Context-First entity** — credibility-made-visible relies on this.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `text` | `String` | `var` | + context | Display text (e.g. `STUDENT MATCH`, `OLD LAW`). Editorial control over wording — important because tag text is the **first English** an L2 reader parses |
| `type` | `→ ContentTagType` | `var` | + context | The 8-case enum determines colour + decoration (strikethrough for OLD LAW, solid green for VERIFIED, etc.). One enum drives all visual treatment |
| `hasIcon` | `Bool` | `var` | + context | Whether to render a leading SF Symbol. Some tags (GOVERNMENT VERIFIED) need an icon for fast recognition; others (NEW) work as text alone |

> **Why one tag system instead of three trust fields?** Group-mate B's Credibility-First variation uses three separate fields on Answer (`authorityTag`, `reliabilityTag`, `timelinessTag`). I chose a unified `ContentTag` system because Context-First's filter thesis requires *one* uniform visual layer where tags can mix freely (e.g. a single post can be `STUDENT MATCH` + `OLD LAW` + `SOURCE: TIKTOK` simultaneously). Three separate fields force a pre-decided trust hierarchy I don't want to commit to.

→ A **ContentTag** can attach to a **QAPost**, **Guide**, or **HelpRequest** (many-to-many in practice; modelled as direct array reference).

---

# §3 — Matching Layer

> **Mechanism 4: Reason-based volunteer matching.** Algorithm output is exposed as an explicit list of *reasons* (`matchReasons: [String]`), not a single percentage. The user can see *why* this volunteer was suggested and override the match if a reason doesn't apply. Algorithms become legible.

## 11. Volunteer

Experienced community member matched to incoming users.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `user` | `→ User` | `var` | + context | Volunteers are Users with extra fields. Embedded reference (not duplication) so volunteer's display name / online state stays in sync with user-side edits |
| `role` | `String` | `var` | + context | E.g. "Senior Community Advisor". Free-text rather than enum because role taxonomy is still evolving |
| `rating` | `Double` | `var` | team | Out of 5.0; recalculated server-side from reviews |
| `peopleHelped` | `Int` | `var` | + context | Surfaced on hero card. Concrete number ("142 people helped") is more trust-building for migrants than a star rating alone |
| `skills` | `[→ SkillTag]` | `var` | + context | Baseline `expertise: [String]` flattened into typed tags. Typed because skill colouring (academic-blue vs specialty-warm) carries information |
| `bio` | `String` | `var` | + context | Free-text introduction; lets volunteers signal their personal story (which is often what builds the "asking a friend" feeling) |
| `specializations` | `[String]` | `var` | + context | Coarse domains (`["Housing", "Visa"]`) for filtering. Distinct from `skills` — specialisations are domain buckets, skills are credentials/badges |

> **What the team baseline's `name`, `languages`, `isOnline` map to**: inherited via the embedded `user: User` reference rather than duplicated. Avoids drift.

→ A **Volunteer** wraps a **User**, holds many **SkillTags**, and appears in zero or more **MatchResults**.

---

## 12. SkillTag *(Context-First addition)*

Typed expertise marker used on volunteer profiles.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `text` | `String` | `var` | + context | E.g. "UNSW Alumna", "NSW Renting Specialist". Free-text so volunteers can describe their own credentials in their own words |
| `category` | `→ SkillCategory` | `var` | + context | `blue` (academic / background) vs `warm` (specialty / region-specific). Two-tier categorisation drives visual styling — academic credentials feel different from regional expertise |

→ A **SkillTag** belongs to one **Volunteer**.

---

## 13. MatchResult *(Context-First — core entity)*

Outcome of the volunteer-matching algorithm. **The "reason-based matching" mechanism's sole purpose is to surface this entity legibly.**

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `volunteer` | `→ Volunteer` | `var` | + context | The matched volunteer |
| `matchPercentage` | `Int` | `var` | + context | 0–100, e.g. 98. Single-number summary surfaced as a badge |
| `isTopChoice` | `Bool` | `var` | + context | Promotes one match to the hero "THE BEST FIT" treatment. Boolean rather than ordering so promotion is intentional, not accidental |
| `matchReasons` | `[String]` | `var` | + context | **The whole point.** Visible reasons (`["Same university background", "Housing expertise matches"]`). Without this field the variation collapses into algorithmic ranking, which is what the design is trying *not* to be |

> **Why match reasons are a `[String]`, not structured objects?** I considered a typed `MatchReason` enum, but reasons are inherently editorial — a volunteer might be a match because of "same WeChat group" or "both visited the same hostel", which can't be enumerated in advance. Free-text reasons keep the matching honest.

→ A **MatchResult** wraps a **Volunteer** and is rendered for one viewing **User** (the matchee).

---

## 14. HelpRequest

Help request posted by a user, surfaced to volunteers on the Community page.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `requester` | `→ User` | `var` | + context | Who posted the request; embedded reference for display sync |
| `subtitle` | `String` | `var` | + context | E.g. "Just arrived in Sydney". Hand-written context that supplements the question text — gives volunteers a sense of *who* is asking |
| `questionText` | `String` | `var` | team | Maps to baseline `questionText` |
| `tags` | `[→ ContentTag]` | `var` | + context | STUDENT MATCH / NEWCOMER / UNSW etc. Same tag system as QAPost — reuse, don't duplicate |
| `category` | `→ ServiceCategoryType` | `var` | team | Maps to baseline `category` (typed enum, not raw string) |
| `language` | `→ Language` | `var` | team | Maps to baseline `language`. Volunteer matching uses this to filter to language-compatible helpers |
| `isResolved` | `Bool` | `var` | team | Maps to baseline `isResolved` |
| `assignedVolunteer` | `→ Volunteer?` | `var` | team | Maps to baseline `assignedVolunteer`; nil until matched |
| `achievement` | `→ AchievementBadge?` | `var` | + context | "You both attend UNSW" — a contextual badge on the request card that gives the viewing volunteer a *reason* to engage. Optional because not every volunteer has a relevant achievement |
| `createdAt` | `Date` | `var` | + engineering | Sort key for the help feed |

→ A **HelpRequest** is posted by a **User**, may be assigned a **Volunteer**, can carry an **AchievementBadge**, and is tagged with multiple **ContentTags**.

---

## 15. AchievementBadge *(Context-First addition)*

Badge surfaced inside a HelpRequest card to give context for matching (e.g. "You both attend UNSW").

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `text` | `String` | `var` | + context | The achievement statement; written from the *viewing volunteer's* perspective ("you both X") not the requester's |
| `icon` | `String` | `var` | + context | SF Symbol name; usually a medal, school, or location pin |
| `variant` | `→ AchievementVariant` | `var` | + context | `warm` (personal achievement, gold styling) vs `cool` (shared background, blue styling). Two-tone styling separates "you've helped 3 students this month" from "you both attend UNSW" |

→ An **AchievementBadge** belongs to one **HelpRequest** (1:0..1).

---

# §4 — Conversation Layer

> **Mechanism 5: Context-aware chat.** When the user escalates from a Q&A thread to a 1-on-1 chat, the originating post is *auto-mounted* as a SharedContext card at the top of the conversation. Action pills offer one-tap shortcuts (share profile tags, suggest a 5-min call). The user never has to re-explain who they are or what they were asking — context is plumbing, not a feature page.

## 16. Conversation

Two-user chat thread (user ↔ volunteer).

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `participant` | `→ User` | `var` | + context | The other party (current user is implicit — the inbox is always *my* inbox) |
| `lastMessage` | `String` | `var` | + context | Preview text for inbox row; denormalised from latest ChatMessage so the inbox doesn't have to query the message store |
| `lastMessageAt` | `Date` | `var` | + context | For sort and `timeAgoString` |
| `unreadCount` | `Int` | `var` | + context | Drives the unread-badge UI (the small red dot) and the unread segment count |
| `sharedContext` | `→ SharedContext?` | `var` | + context | The Q&A post mounted at the top of the thread. Nullable because not every conversation starts from a Q&A (some are direct messages from a profile) |
| `isUnread` | `Bool` | computed | + engineering | True when `unreadCount > 0`; computed for cleaner call sites |
| `timeAgoString` | `String` | computed | + engineering | "2 min ago", "Yesterday" — same L2-reader rationale as elsewhere |

→ A **Conversation** has one other **User** as participant, may anchor to a **SharedContext**, and contains many **ChatMessages**.

---

## 17. ChatMessage

Single message inside a conversation.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `senderID` | `UUID` | `let` | team | Maps to baseline `sender`. Typed UUID reference rather than baseline's `String` so we can cross-look-up without ambiguity |
| `text` | `String` | `var` | team | Maps to baseline `text` |
| `translatedText` | `String?` | `var` | team | Maps to baseline `translatedText`. Surfaced inline below the original — the original is preserved so language learners can see both |
| `timestamp` | `Date` | `let` | team | Maps to baseline `timestamp` |
| `direction` | `→ MessageDirection` | `var` | + context | `incoming` / `outgoing`. Drives left/right bubble alignment. Stored separately from `senderID == currentUser.id` so we can render archive views without injecting current-user state |
| `isVoiceMessage` | `Bool` | `let` | team | Maps to baseline `isVoiceMessage`. Voice messages carry transcription differently |
| `timeString` | `String` | computed | + engineering | Formatted "h:mm a" |

→ A **ChatMessage** belongs to a **Conversation** and is sent by a **User** (referenced via `senderID`).

---

## 18. SharedContext *(Context-First — core entity)*

Q&A post reference mounted at the top of a chat thread. **This entity is the entire reason mechanism 5 exists** — without it, every conversation re-introduces the user.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `title` | `String` | `var` | + context | Q&A post title; denormalised so the chat header can render without re-fetching the post |
| `relatedPostID` | `UUID` | `var` | + context | FK to the originating QAPost. Tap-to-navigate-back is the entire point of this field |
| `linkText` | `String` | `var` | + context | E.g. "View Q&A Post". Editable so we can A/B-test the call-back wording for tap rate |

→ A **SharedContext** is anchored to one **Conversation** (1:0..1) and points at one **QAPost**.

---

## 19. ContextAction *(Context-First addition)*

Action pill shown in chat (e.g. "Share My Profile Tags", "Suggest a 5-min call").

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `text` | `String` | `var` | + context | Pill label. Editable because micro-copy on action pills is one of the highest-leverage tap-rate optimisations |
| `icon` | `String` | `var` | + context | SF Symbol name |
| `variant` | `→ ActionVariant` | `var` | + context | `blue` (share / ask) vs `orange` (call / urgent). Colour codes urgency without forcing the user to read the label first |

→ A **ContextAction** belongs to a **Conversation**.

---

# §5 — Cross-cutting Layer

> Not bound to any single mechanism. These three entities support the whole product (translation can attach to any text; tasks can be referenced from any guide).

## 20. Translation

Translation record for cross-language messaging and standalone translation tooling.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `originalText` | `String` | `let` | team | Maps to baseline `originalText`. Immutable so the source survives translator edits |
| `translatedText` | `String` | `var` | team | Maps to baseline `translatedText`. Editable because users sometimes correct machine translation |
| `sourceLanguage` | `→ Language` | `let` | team | Maps to baseline `sourceLanguage` |
| `targetLanguage` | `→ Language` | `let` | team | Maps to baseline `targetLanguage` (defaults to English) |
| `confidence` | `Double?` | `var` | + context | 0.0–1.0 from the translation engine. Surfaces a "low-confidence" banner when below a threshold — matters for legal / medical text where wrong translation is dangerous |
| `createdAt` | `Date` | `var` | + engineering | |

→ A **Translation** references two **Languages** (source + target) and may attach to a **ChatMessage** (as the `translatedText` field on that message).

---

## 21. Task

Checklist item that the user can complete (e.g. "Get a phone number"). Used by the "First 7 Days" guide.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `title` | `String` | `var` | team | Maps to baseline `title` |
| `category` | `→ ServiceCategoryType` | `var` | team | Maps to baseline `category`. Typed enum (not raw string) so tasks can be filtered alongside guides and Q&A |
| `isCompleted` | `Bool` | `var` | team | Maps to baseline `isCompleted` |
| `steps` | `[→ Step]` | `var` | team | Maps to baseline `steps`. Tasks have substeps so progress isn't all-or-nothing — a 7-step task can be 4/7 done |
| `progress` | `Double` | computed | team | Maps to baseline `progress`. Computed from `steps` so it can't drift out of sync |

→ A **Task** is categorised under **ServiceCategoryType**, contains many **Steps**, and is owned by a **User** (via `User.completedTasks`).

---

## 22. Step

Sub-step of a Task.

| Field | Type | Mutability | Origin | Why |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `title` | `String` | `var` | team | Replaces baseline `instructionText`. Same field renamed for parallelism with Task.title |
| `description` | `String` | `var` | + context | Detailed explanation shown when the step is expanded. The baseline doesn't have this — but L2 readers benefit from progressive disclosure (short title for scan, long description for execution) |
| `isCompleted` | `Bool` | `var` | team | Maps to baseline `isCompleted` |

> **Simplification vs baseline**: the team baseline lists `stepNumber: Int` and `requiredDocuments: [String]`. Both deferred — `stepNumber` is implicit in the array index of `Task.steps`; `requiredDocuments` is not surfaced in any current page. Both can be added back without breaking any consumer.

→ A **Step** belongs to one **Task**.

---

# Enumerations

Type-safe enumerations referenced throughout the structs above. Listed here in one place because they're cross-cutting and don't belong to any single layer.

| Enum | Cases | Used by | Origin | Why this enum exists |
|---|---|---|---|---|
| `Language` | english, mandarin, spanish, arabic, hindi, other | User, HelpRequest, Translation | team | Closed set — the supported languages are a deliberate product decision, not user input |
| `UserStatus` | immigrantStudent, working, lookingForWork, businessOwner | User | + context | Drives downstream filtering; closed set ensures consistent UI tabs and filter pills |
| `Duration` | notYetArrived, justLanded, oneToSix, sixToTwelve, oneYearPlus | User | + context | Bucketed because UI changes at thresholds, not on continuous time |
| `SkillCategory` | blue, warm | SkillTag | + context | Two-tier visual style; "academic" vs "regional/specialty" |
| `VerificationStatus` | verified, unverified, outdated, pending | QAPost | + context | Coarse credibility flag; the fine grain is in `tags` |
| `ContentSource` | tiktok, government, community, official | QAPost | + context | Provenance taxonomy; surfaces "where did this come from" without long source URLs |
| `ContentTagType` | contextMatch, verified, newContent, warning, error, gold, topAdvice, category | ContentTag | + context | The 8-style visual taxonomy that powers all tag rendering |
| `MessageDirection` | incoming, outgoing | ChatMessage | + context | Drives bubble alignment without forcing every render to inject current-user identity |
| `ActionVariant` | blue, orange | ContextAction | + context | Two-tone urgency colour-coding for chat action pills |
| `ServiceCategoryType` | job, housing, healthcare, visa, bank, education, transport, social, finance, utilities | ServiceCategory, Task, QAPost, HelpRequest, Guide | + context | The 10 closed categories drive the entire home grid + cross-content filtering |
| `AchievementVariant` | warm, cool | AchievementBadge | + context | Two-tone styling: personal achievement vs shared background |

---

# Variation Comparison

How my Context-First model differs from the team baseline and group-mate B's Credibility-First variation.

| Dimension | Team baseline | B (Credibility-First) | Me (Context-First) |
|---|---|---|---|
| **Entity count** | 8 | 5 | 22 (15 struct + 11 enum, partly overlapping) |
| **User schema** | 4 fields (name / lang / progress / tasks) | 7 fields, including `visaType` and `isVerified` | 12 fields, including `currentStatus`, structured `Location`, and bucketed `Duration` |
| **Trust metadata** | None | 3 fields on Answer (`authorityTag`, `reliabilityTag`, `timelinessTag`) + a `Certification` entity | One unified `ContentTag` system (8 types) used across QAPost, Guide, HelpRequest |
| **Q&A modelling** | Not present | Question + Answer as separate entities | `QAPost` with embedded `TopAnswer` (no separate Answer entity) |
| **Match reasoning** | Not present | Implicit in `Volunteer.helpfulRate` and `reviews` | Explicit `MatchResult.matchReasons: [String]` — visible per-match |
| **Chat handoff context** | Not present | Not present | `SharedContext` entity anchors Q&A post to conversation |
| **Identity granularity** | `name` + `selectedLanguage` | `+ visaType + suburb + daysSinceArrival + isVerified` | `+ currentStatus + Location (city, state) + Duration (bucketed)` |

**Why these differences are not "more is better"** — each variation chose a *different design constraint* to serve:

- **B's design constraint**: "Don't propagate misinformation." Therefore data-model effort goes into trust/verification metadata, certifications, and source attribution. Schema serves credibility ranking.
- **My design constraint**: "Make context legible without re-explanation." Therefore data-model effort goes into identity capture, tag-driven filtering, and chat-context preservation. Schema serves filter consistency across surfaces.

Same baseline, three legitimate destinations. The data model is the first place a UX variation makes itself visible — and ours diverged at exactly that level.

---

# Coverage summary

| Group | Team baseline fields | Status in this model |
|---|---|---|
| 1. User | `name`, `selectedLanguage`, `progress`, `completedTasks` | ✓ all 4 covered, 8 fields extended |
| 2. Language | `name`, `code`, `flagIcon`, `isSelected` | ✓ 3/4 covered (`isSelected` lifted onto `User.preferredLanguage`) |
| 3. Task | `title`, `category`, `isCompleted`, `steps`, `progress` | ✓ 5/5 covered |
| 4. Step | `stepNumber`, `instructionText`, `requiredDocuments`, `isCompleted` | ✓ 2/4 covered (2 deferred — see Step §) |
| 5. Message | `text`, `translatedText`, `sender`, `timestamp`, `isVoiceMessage` | ✓ 5/5 covered, 1 field extended (`direction`) |
| 6. Volunteer | `name`, `languages`, `expertise`, `isOnline`, `rating` | ✓ 4/5 directly covered, 1 lifted to embedded `user`, 4 fields extended |
| 7. HelpRequest | `questionText`, `category`, `language`, `isResolved`, `assignedVolunteer` | ✓ 5/5 covered, 5 fields extended |
| 8. Translation | `originalText`, `translatedText`, `sourceLanguage`, `targetLanguage` | ✓ 4/4 covered, 1 field extended (`confidence`) |

**Plus 9 entities introduced for Context-First**: ContentTag · QAPost · TopAnswer · Conversation · SharedContext · ContextAction · ServiceCategory · Guide · AchievementBadge — every one is justified by a Context-First mechanism (identity awareness, contextual home hub, metadata tags, reason-based matching, context-aware chat).

---

*Last revised: 2026-05-04. Authoritative source: `../ABDesignSystem/Sources/Models/ABModels.swift`. When code and this document drift, the code wins — re-export this document by tracing each `struct` and `enum` declaration.*
