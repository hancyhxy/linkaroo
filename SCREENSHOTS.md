# Linkaroo — Screens

> Visual catalogue of the 9 spec-driven core pages in the iOS prototype, in their `§1 → §9` order from `docs/spec.md`. Pages with a meaningful second state (a later step, a mid-scroll view) carry an inline pair so the rhythm of the page is visible at a glance.

## §1 · Onboarding
Personalisation engine's initialisation. Captures preferred language, current status, location, and time-in-Australia in one short, warm form. The result is the `ABUser` that every downstream surface reads from.

<table>
  <tr>
    <td valign="top" width="50%"><img src="screenshots/01-onboarding.png" alt="Onboarding — step 1" /></td>
    <td valign="top" width="50%"><img src="screenshots/01b-onboarding-step2.png" alt="Onboarding — step 2" /></td>
  </tr>
</table>

## §2 · Home
Profile-driven push layer. Greeting + search entry + 10 essential service categories as a 2×5 grid + one Featured Guide + a recommendation list filtered by status × duration × language.

<table>
  <tr>
    <td valign="top" width="50%"><img src="screenshots/02-home.png" alt="Home — top" /></td>
    <td valign="top" width="50%"><img src="screenshots/02b-home-scrolled.png" alt="Home — Recommended for You" /></td>
  </tr>
</table>

## §3 · Community
Social spine. A single-page hub: "people you can help" (horizontal carousel of `ABHelpRequest`) above "questions you can answer" (vertical list of `ABQAPost`). No internal segmented control — Messages was promoted to its own tab.

<table>
  <tr>
    <td valign="top" width="50%"><img src="screenshots/03-community.png" alt="Community — carousel" /></td>
    <td valign="top" width="50%"><img src="screenshots/03b-community-scrolled.png" alt="Community — Q&A list" /></td>
  </tr>
</table>

## §4 · Q&A List
Deep filter view. Single category axis (All / Renting / Subletting / Utilities / Visa) on top of a Reddit-style list. Each row carries the `ABContentTag` set inline (authority / reliability / timeliness / urgency) so credibility is readable before the title.

<table>
  <tr>
    <td valign="top" width="50%"><img src="screenshots/04-qa-list.png" alt="Q&A List" /></td>
    <td valign="top" width="50%"><img src="screenshots/04b-qa-list-scrolled.png" alt="Q&A List — scrolled" /></td>
  </tr>
</table>

## §5 · Q&A Detail
Product inflection point. A single thread with credibility tags pre-parsed and the Top Answer surfaced as a quote block. The "Match a volunteer" CTA forks the user into §6 — the load-bearing escalation that turns reading into a real 1-on-1.

<table>
  <tr>
    <td valign="top" width="50%"><img src="screenshots/05-qa-detail.png" alt="Q&A Detail — top" /></td>
    <td valign="top" width="50%"><img src="screenshots/05b-qa-detail-scrolled.png" alt="Q&A Detail — answers" /></td>
  </tr>
</table>

## §6 · Volunteer Match
Where the matching algorithm becomes *legible*. Each volunteer is paired with explicit fit reasons ("UNSW alumna · NSW Renting Specialist · speaks Mandarin"). One Top Choice as a hero card with checkmark-bulleted reasons, then additional matches below.

<table>
  <tr>
    <td valign="top" width="50%"><img src="screenshots/06-volunteer-match.png" alt="Volunteer Match — top choice" /></td>
    <td valign="top" width="50%"><img src="screenshots/06b-volunteer-match-scrolled.png" alt="Volunteer Match — more matches" /></td>
  </tr>
</table>

## §7–§8 · Messages
Inbox-shaped re-entry surface paired with the conversation it opens into. The list (left) is an `All / Unread` segment with a numeric badge on Unread; each row carries online-state on the avatar. The chat (right) makes two design moves that separate it from a generic messenger: (a) originating `ABQAPost` mounted at the top as a shared-context card, persistent across re-entries; (b) action pill row between the context card and the input area for one-tap profile-tag sync. Tapping a row returns to the same chat with `ABSharedContext` still mounted.

<table>
  <tr>
    <td valign="top" width="50%"><img src="screenshots/07-message-list.png" alt="Message List" /></td>
    <td valign="top" width="50%"><img src="screenshots/08-chat.png" alt="Chat" /></td>
  </tr>
</table>

## §9 · Profile
Read-back end of Mechanism 1. After §1 writes an `ABUser` into AppState, downstream surfaces consume it silently — Profile is the one place where the captured identity becomes visible. "Edit profile" re-enters §1 with values prefilled (single-source identity capture).

<p align="center">
  <img src="screenshots/09-profile.png" alt="Profile" width="50%" />
</p>
