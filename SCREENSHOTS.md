# Linkaroo — Screens

> Visual catalogue of the 9 spec-driven core pages in the iOS prototype, in their `§1 → §9` order from `docs/spec.md`. Some pages have multiple states (scrolled / modal / edit) and carry an extra row.

<p align="center">
  <img src="screenshots/00-banner.jpg" alt="Linkaroo Banner" width="100%" />
</p>

---

| # | Page | What it does | Screenshot |
|---|------|--------------|------------|
| §1 | **Onboarding** | Personalisation engine's initialisation. Captures preferred language, current status, location, and time-in-Australia in one short, warm form. The result is the `ABUser` that every downstream surface reads from. | <img src="screenshots/01-onboarding.jpg" alt="Onboarding" width="280" /> |
| §2 | **Home** | Profile-driven push layer. Greeting + search entry + 10 essential service categories as a 2×5 grid + one Featured Guide + a recommendation list filtered by status × duration × language. | <img src="screenshots/02-home.jpg" alt="Home" width="280" /> |
| §3 | **Community** | Social spine. A single-page hub: "who you can help right now" (horizontal carousel of `ABHelpRequest`) above "what you can answer" (vertical list of `ABQAPost`). No internal segmented control — Messages was promoted to its own tab. | <img src="screenshots/03-community.jpg" alt="Community" width="280" /> |
| §4 | **Q&A List** | Deep filter view. Single category axis (All / Renting / Subletting / Utilities / Visa) on top of a Reddit-style list. Each row carries the `ABContentTag` set inline (authority / reliability / timeliness / urgency) so credibility is readable before the title. | <img src="screenshots/04-qa-list.jpg" alt="Q&A List" width="280" /> |
| §4b | **Q&A List — scrolled** | Same surface mid-scroll. Demonstrates the credibility-tag rhythm continuing through the feed and the sticky category bar. | <img src="screenshots/04b-qa-list-scrolled.jpg" alt="Q&A List scrolled" width="280" /> |
| §5 | **Q&A Detail** | Product inflection point. A single thread with credibility tags pre-parsed and the Top Answer surfaced as a quote block. The "Match a volunteer" CTA forks the user into §6 — the load-bearing escalation that turns reading into a real 1-on-1. | <img src="screenshots/05-qa-detail.jpg" alt="Q&A Detail" width="280" /> |
| §6 | **Volunteer Match** | Where the matching algorithm becomes *legible*. Each volunteer is paired with explicit fit reasons ("UNSW alumna · NSW Renting Specialist · speaks Mandarin"). One Top Choice as a hero card with checkmark-bulleted reasons, then additional matches below. | <img src="screenshots/06-volunteer-match.jpg" alt="Volunteer Match" width="280" /> |
| §7 | **Message List** | Inbox-shaped re-entry surface. `All / Unread` segment with a numeric badge on Unread; each row carries online-state on the avatar. Tapping returns to §8 Chat with the same `ABSharedContext` still mounted. | <img src="screenshots/07-message-list.jpg" alt="Message List" width="280" /> |
| §8 | **Chat** | Conversation surface. Two design moves separate it from a generic messenger: (a) originating `ABQAPost` mounted at the top as a shared-context card, persistent across re-entries; (b) action pill row between the context card and the input area for one-tap profile-tag sync. | <img src="screenshots/08-chat.jpg" alt="Chat" width="280" /> |
| §9 | **Profile** | Read-back end of Mechanism 1. After §1 writes an `ABUser` into AppState, downstream surfaces consume it silently — Profile is the one place where the captured identity becomes visible. "Edit profile" re-enters §1 with values prefilled (single-source identity capture). | <img src="screenshots/09-profile.jpg" alt="Profile" width="280" /> |
| §9b | **Profile — Edit** | The Edit profile loop. Tapping "Edit" re-uses the same `OnboardingView` form with the current `ABUser` pre-populated, then writes back on Save. Demonstrates the §1 ↔ §9 round-trip. | <img src="screenshots/09b-profile-edit.jpg" alt="Profile Edit" width="280" /> |

---

## Image inventory (placeholders → fill in)

All images live under `screenshots/`. Filenames are slot-locked so the python-docx pipeline (`uts-coursework/.../checkpoint3/submission/build_docx.py`) can map them by name without manual indexing. **Drop the JPG/PNG into the path; do not rename.**

| Slot | Filename | Status |
|------|----------|--------|
| Banner (Overview row) | `screenshots/00-banner.jpg` | placeholder |
| §1 Onboarding | `screenshots/01-onboarding.jpg` | placeholder |
| §2 Home | `screenshots/02-home.jpg` | placeholder |
| §3 Community | `screenshots/03-community.jpg` | placeholder |
| §4 Q&A List | `screenshots/04-qa-list.jpg` | placeholder |
| §4b Q&A List scrolled | `screenshots/04b-qa-list-scrolled.jpg` | optional, placeholder |
| §5 Q&A Detail | `screenshots/05-qa-detail.jpg` | placeholder |
| §6 Volunteer Match | `screenshots/06-volunteer-match.jpg` | placeholder |
| §7 Message List | `screenshots/07-message-list.jpg` | placeholder |
| §8 Chat | `screenshots/08-chat.jpg` | placeholder |
| §9 Profile | `screenshots/09-profile.jpg` | placeholder |
| §9b Profile Edit | `screenshots/09b-profile-edit.jpg` | optional, placeholder |
