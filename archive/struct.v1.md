# Data Model Specification

This document defines the data model for AussieBridge. It follows the team's shared baseline of 8 core entities, plus individual extensions for the **Context-First** variation. Every field listed here has a 1:1 implementation in `ABDesignSystem/Sources/Models/ABModels.swift`.

**Origin column legend** *(present in every table)*:
- `team` — field defined in the team baseline (8 core entities, agreed across the group)
- `+ context` — field added for the Context-First variation
- `+ engineering` — field added for SwiftUI implementation needs (e.g. `id`, `createdAt`, computed helpers)

**Type column convention**:
- `String`, `Int`, `Double`, `Bool`, `Date`, `URL`, `UUID` — Swift built-ins
- `[X]` — array of X
- `X?` — optional X (may be nil)
- `→ Y` — references another entity (Y) defined later in this doc

---

## 1. User

The core user entity, populated during onboarding and used as the filter input by every Context-First mechanism.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | Stable identifier |
| `displayName` | `String` | `var` | team | Maps to baseline `name` |
| `username` | `String` | `var` | + context | Reddit-style handle, e.g. `u/sarah_m` (used in Q&A attribution) |
| `avatarURL` | `URL?` | `var` | + context | nil → render initials with a gradient background |
| `preferredLanguage` | `→ Language` | `var` | team | Maps to baseline `selectedLanguage` |
| `currentStatus` | `→ UserStatus` | `var` | + context | Identity captured during onboarding (student / working / etc.) |
| `location` | `→ Location?` | `var` | + context | City + state, used to filter content by geography |
| `durationInAustralia` | `→ Duration` | `var` | + context | Time-in-country bucket; drives "First 30 days" featured guide |
| `isOnline` | `Bool` | `var` | + context | Surfaces a green dot in chat / message list |
| `onboardingProgress` | `Double` | `var` | team | Maps to baseline `progress` (0.0–1.0) |
| `completedTasks` | `[→ Task]` | `var` | team | Maps to baseline `completedTasks` |
| `createdAt` | `Date` | `var` | + engineering | Account creation timestamp |
| `initials` | `String` | computed | + engineering | Derived from `displayName` for avatar fallback |

---

## 2. Language

Language preference, exposed both as a profile field on `User` and as a selectable option during onboarding.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `name` | `String` | (rawValue) | team | E.g. `English`, `Mandarin` — baseline `name` |
| `code` | `String` | computed | team | ISO 639-1, e.g. `en`, `zh` — baseline `code` |
| `flagIcon` | `String` | computed | team | Country flag emoji — baseline `flagIcon` |

> **Implementation note**: in code this is realised as an `enum ABLanguage: String, CaseIterable` (6 cases: english / mandarin / spanish / arabic / hindi / other) rather than a `struct`. The team baseline's `isSelected: Bool` lives instead on `User.preferredLanguage` — selection state is owned by the user, not the language. This is a structural simplification, not a missing field.

---

## 3. UserStatus *(extension)*

Onboarding identity, used as the primary filter signal for the home hub and for Q&A relevance ranking.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `name` | `String` | (rawValue) | + context | Display label |
| `icon` | `String` | computed | + context | SF Symbol name |

> Cases: `immigrantStudent`, `working`, `lookingForWork`, `businessOwner`. Implemented as `enum ABUserStatus: String`.

---

## 4. Duration *(extension)*

Time-in-Australia bucket. Drives the "First 7 Days Checklist" surfacing logic on Home.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `name` | `String` | (rawValue) | + context | Display label |

> Cases: `notYetArrived`, `justLanded`, `oneToSix`, `sixToTwelve`, `oneYearPlus`. Implemented as `enum ABDuration: String`.

---

## 5. Location *(extension)*

Structured geographic context. Used to filter content (housing rules per state, transport availability per city).

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `city` | `String` | `var` | + context | E.g. `Sydney` |
| `state` | `String` | `var` | + context | E.g. `NSW` |
| `latitude` | `Double?` | `var` | + context | For future map rendering |
| `longitude` | `Double?` | `var` | + context | |
| `displayString` | `String` | computed | + engineering | E.g. "Sydney, NSW" |

---

## 6. Task

Checklist item that the user can complete (e.g. "Get a phone number"). Used by the "First 7 Days" guide.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `title` | `String` | `var` | team | Baseline `title` |
| `category` | `→ ServiceCategoryType` | `var` | team | Baseline `category` (typed enum, not raw string) |
| `isCompleted` | `Bool` | `var` | team | Baseline `isCompleted` |
| `steps` | `[→ Step]` | `var` | team | Baseline `steps` |
| `progress` | `Double` | computed | team | Baseline `progress` (computed from `steps`) |

---

## 7. Step

Sub-step of a Task. Lightweight version of the team baseline.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `title` | `String` | `var` | team | Replaces baseline `instructionText` |
| `description` | `String` | `var` | + context | Detailed explanation shown when expanded |
| `isCompleted` | `Bool` | `var` | team | Baseline `isCompleted` |

> **Simplification vs baseline**: the team baseline lists `stepNumber: Int` and `requiredDocuments: [String]`. Both are deferred — `stepNumber` is implicit in the array index of `Task.steps`, `requiredDocuments` is not surfaced in any current page. They can be added back without breaking any consumer.

---

## 8. Message (Chat)

Single chat message between a user and a volunteer.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `text` | `String` | `var` | team | Baseline `text` |
| `translatedText` | `String?` | `var` | team | Baseline `translatedText` (auto-translation) |
| `senderID` | `UUID` | `let` | team | Baseline `sender` (typed reference instead of String) |
| `timestamp` | `Date` | `let` | team | Baseline `timestamp` |
| `direction` | `→ MessageDirection` | `var` | + context | `incoming` / `outgoing` — drives left/right bubble alignment |
| `isVoiceMessage` | `Bool` | `let` | team | Baseline `isVoiceMessage` |
| `timeString` | `String` | computed | + engineering | Formatted as `h:mm a` |

---

## 9. Volunteer

Experienced community member matched to incoming users.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `user` | `→ User` | `var` | + context | Volunteers are Users with extra fields — embedded rather than duplicated |
| `role` | `String` | `var` | + context | E.g. "Senior Community Advisor" |
| `rating` | `Double` | `var` | team | Baseline `rating` (out of 5.0) |
| `peopleHelped` | `Int` | `var` | + context | Surfaced on hero card and match listings |
| `skills` | `[→ SkillTag]` | `var` | + context | Baseline `expertise` flattened into multiple typed tags |
| `bio` | `String` | `var` | + context | Free-text introduction |
| `specializations` | `[String]` | `var` | + context | E.g. `["Housing", "Visa"]` for filtering |

> Baseline `name`, `languages`, `isOnline` are inherited via the embedded `user: User` reference rather than duplicated.

---

## 10. SkillTag *(extension)*

Typed expertise marker used on volunteer profiles.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `text` | `String` | `var` | + context | E.g. "UNSW Alumna", "NSW Renting Specialist" |
| `category` | `→ SkillCategory` | `var` | + context | `blue` (academic / background) or `warm` (specialty) |

---

## 11. MatchResult *(extension)*

Outcome of the volunteer-matching algorithm. The "reason-based matching" mechanism makes the algorithm legible.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `volunteer` | `→ Volunteer` | `var` | + context | Matched volunteer |
| `matchPercentage` | `Int` | `var` | + context | 0–100, e.g. 98 |
| `isTopChoice` | `Bool` | `var` | + context | True for "THE BEST FIT" hero card |
| `matchReasons` | `[String]` | `var` | + context | Visible reasons, e.g. `["Same university background", "Housing expertise matches"]` |

---

## 12. HelpRequest

Help request posted by a user, surfaced to volunteers on the Community page.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `requester` | `→ User` | `var` | + context | Who posted the request |
| `subtitle` | `String` | `var` | + context | E.g. "Just arrived in Sydney" |
| `questionText` | `String` | `var` | team | Baseline `questionText` |
| `tags` | `[→ ContentTag]` | `var` | + context | STUDENT MATCH, NEWCOMER, UNSW, etc. |
| `category` | `→ ServiceCategoryType` | `var` | team | Baseline `category` (typed enum) |
| `language` | `→ Language` | `var` | team | Baseline `language` |
| `isResolved` | `Bool` | `var` | team | Baseline `isResolved` |
| `assignedVolunteer` | `→ Volunteer?` | `var` | team | Baseline `assignedVolunteer` (nil until matched) |
| `achievement` | `→ AchievementBadge?` | `var` | + context | "You both attend UNSW" — drives match-reasoning UI |
| `createdAt` | `Date` | `var` | + engineering | |

---

## 13. Translation

Translation record for cross-language messaging and standalone translation tooling.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `originalText` | `String` | `let` | team | Baseline `originalText` (immutable source) |
| `translatedText` | `String` | `var` | team | Baseline `translatedText` (may be corrected) |
| `sourceLanguage` | `→ Language` | `let` | team | Baseline `sourceLanguage` |
| `targetLanguage` | `→ Language` | `let` | team | Baseline `targetLanguage` (defaults to English) |
| `confidence` | `Double?` | `var` | + context | 0.0–1.0 — used to surface "low-confidence" warnings |
| `createdAt` | `Date` | `var` | + engineering | |

---

# Context-First-only Constructs

The following entities have **no team baseline counterpart** — they exist solely to support the five Context-First mechanisms (identity awareness / contextual home hub / metadata tags / reason-based matching / context-aware chat).

## 14. ContentTag

Semantic tag attached to Q&A posts, help requests, and recommended guides. The "credibility-made-visible" mechanism relies on this entity.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `text` | `String` | `var` | + context | Display text, e.g. `STUDENT MATCH`, `OLD LAW` |
| `type` | `→ ContentTagType` | `var` | + context | Drives the visual style (8 styles total) |
| `hasIcon` | `Bool` | `var` | + context | Whether to render a leading SF Symbol |

---

## 15. QAPost

Reddit-style community Q&A thread.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `author` | `→ User` | `var` | + context | Original poster |
| `title` | `String` | `var` | + context | Question headline |
| `preview` | `String` | `var` | + context | First ~150 chars for list view |
| `fullContent` | `String` | `var` | + context | Body text for detail view |
| `tags` | `[→ ContentTag]` | `var` | + context | STUDENT MATCH / GOVERNMENT VERIFIED / OLD LAW etc. |
| `category` | `→ ServiceCategoryType` | `var` | + context | Housing / Visa / Healthcare etc. |
| `voteCount` | `Int` | `var` | + context | Reddit-style upvotes |
| `commentCount` | `Int` | `var` | + context | |
| `topAnswer` | `→ TopAnswer?` | `var` | + context | Pinned-by-community summary, may be absent |
| `verificationStatus` | `→ VerificationStatus` | `var` | + context | `verified`, `unverified`, `outdated`, `pending` |
| `source` | `→ ContentSource?` | `var` | + context | Origin of the info, e.g. `tiktok`, `government` |
| `createdAt` | `Date` | `var` | + engineering | |
| `timeAgoString` | `String` | computed | + engineering | "4h ago", "2d ago" |

---

## 16. TopAnswer

Excerpted top answer pinned to a Q&A post.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `authorUsername` | `String` | `var` | + context | Attribution |
| `excerpt` | `String` | `var` | + context | Quoted text (1–3 sentences) |
| `isVerified` | `Bool` | `var` | + context | Adds the green checkmark badge |

---

## 17. Conversation

Two-user chat thread (user ↔ volunteer).

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `participant` | `→ User` | `var` | + context | The other party (current user is implicit) |
| `lastMessage` | `String` | `var` | + context | Preview text for inbox row |
| `lastMessageAt` | `Date` | `var` | + context | For sort and `timeAgoString` |
| `unreadCount` | `Int` | `var` | + context | Drives unread-badge UI |
| `sharedContext` | `→ SharedContext?` | `var` | + context | Q&A post mounted at top of the thread |
| `isUnread` | `Bool` | computed | + engineering | True when `unreadCount > 0` |
| `timeAgoString` | `String` | computed | + engineering | "2 min ago", "Yesterday" |

---

## 18. SharedContext

Q&A post reference mounted at the top of a chat thread. Implements the "context-aware chat handoff" mechanism.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `title` | `String` | `var` | + context | Q&A post title |
| `relatedPostID` | `UUID` | `var` | + context | FK to the originating QAPost |
| `linkText` | `String` | `var` | + context | E.g. "View Q&A Post" |

---

## 19. ContextAction

Action pill shown in chat (e.g. "Share My Profile Tags", "Suggest a 5-min call").

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `text` | `String` | `var` | + context | Pill label |
| `icon` | `String` | `var` | + context | SF Symbol name |
| `variant` | `→ ActionVariant` | `var` | + context | `blue` (share/ask) or `orange` (call/urgent) |

---

## 20. ServiceCategory

One of the 10 service categories shown on the home grid.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `type` | `→ ServiceCategoryType` | `var` | + context | The enum value |
| `displayOrder` | `Int` | `var` | + context | For grid ordering |
| `name` | `String` | computed | + engineering | Human-readable label from `type` |
| `icon` | `String` | computed | + engineering | SF Symbol name from `type` |

---

## 21. Guide

Recommended article or guide surfaced on the home page.

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `id` | `UUID` | `let` | + engineering | |
| `title` | `String` | `var` | + context | |
| `description` | `String` | `var` | + context | |
| `category` | `→ ServiceCategoryType` | `var` | + context | |
| `tags` | `[→ ContentTag]` | `var` | + context | FEATURED GUIDE, STUDENT MATCH, NEW etc. |
| `readTimeMinutes` | `Int` | `var` | + context | E.g. 12 |
| `isFeatured` | `Bool` | `var` | + context | Drives the dark featured-card variant |
| `imageURL` | `URL?` | `var` | + context | |
| `createdAt` | `Date` | `var` | + engineering | |
| `readTimeString` | `String` | computed | + engineering | "12 min read" |

---

## 22. AchievementBadge

Badge surfaced inside a HelpRequest card to give context for matching (e.g. "You both attend UNSW").

| Field | Type | Mutability | Origin | Note |
|---|---|---|---|---|
| `text` | `String` | `var` | + context | The achievement statement |
| `icon` | `String` | `var` | + context | SF Symbol name |
| `variant` | `→ AchievementVariant` | `var` | + context | `warm` (personal achievement) or `cool` (shared background) |

---

# Enumerations

Type-safe enumerations referenced throughout the structs above.

| Enum | Cases | Used by | Origin |
|---|---|---|---|
| `Language` | english, mandarin, spanish, arabic, hindi, other | User, HelpRequest, Translation | team |
| `UserStatus` | immigrantStudent, working, lookingForWork, businessOwner | User | + context |
| `Duration` | notYetArrived, justLanded, oneToSix, sixToTwelve, oneYearPlus | User | + context |
| `SkillCategory` | blue, warm | SkillTag | + context |
| `VerificationStatus` | verified, unverified, outdated, pending | QAPost | + context |
| `ContentSource` | tiktok, government, community, official | QAPost | + context |
| `ContentTagType` | contextMatch, verified, newContent, warning, error, gold, topAdvice, category | ContentTag | + context |
| `MessageDirection` | incoming, outgoing | Message | + context |
| `ActionVariant` | blue, orange | ContextAction | + context |
| `ServiceCategoryType` | job, housing, healthcare, visa, bank, education, transport, social, finance, utilities | ServiceCategory, Task, QAPost, HelpRequest, Guide | + context |
| `AchievementVariant` | warm, cool | AchievementBadge | + context |

---

# Coverage summary

| Group | Team baseline | Status |
|---|---|---|
| 1. User | 4 fields (`name`, `selectedLanguage`, `progress`, `completedTasks`) | ✓ all 4 covered, 8 fields extended |
| 2. Language | 4 fields (`name`, `code`, `flagIcon`, `isSelected`) | ✓ 3/4 covered (`isSelected` lifted onto `User.preferredLanguage`) |
| 3. Task | 5 fields (`title`, `category`, `isCompleted`, `steps`, `progress`) | ✓ 5/5 covered |
| 4. Step | 4 fields (`stepNumber`, `instructionText`, `requiredDocuments`, `isCompleted`) | ✓ 2/4 covered (2 deferred — see Step §) |
| 5. Message | 5 fields (`text`, `translatedText`, `sender`, `timestamp`, `isVoiceMessage`) | ✓ 5/5 covered, 1 field extended (`direction`) |
| 6. Volunteer | 5 fields (`name`, `languages`, `expertise`, `isOnline`, `rating`) | ✓ 4/5 directly covered, 1 lifted to embedded `user`, 4 fields extended |
| 7. HelpRequest | 5 fields (`questionText`, `category`, `language`, `isResolved`, `assignedVolunteer`) | ✓ 5/5 covered, 5 fields extended |
| 8. Translation | 4 fields (`originalText`, `translatedText`, `sourceLanguage`, `targetLanguage`) | ✓ 4/4 covered, 1 field extended (`confidence`) |

**Plus 9 entities introduced for the Context-First variation**: ContentTag, QAPost, TopAnswer, Conversation, SharedContext, ContextAction, ServiceCategory, Guide, AchievementBadge — every one is justified by a Context-First mechanism (identity awareness, contextual home hub, metadata tags, reason-based matching, context-aware chat).

---

*Last revised: 2026-05-04. Authoritative source: `ABDesignSystem/Sources/Models/ABModels.swift`. When code and this document drift, the code wins — re-export this document by tracing each `struct` and `enum` declaration.*
