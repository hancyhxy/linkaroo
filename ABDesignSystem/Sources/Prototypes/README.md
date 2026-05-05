# Prototypes — spec-driven evolution snapshots

This directory is the **experiment layer** of the AI workflow (see the main `README.md` for the full pipeline diagram). Every file here is a SwiftUI page re-implemented *strictly from `docs/spec.md`*, without reading the corresponding `Pages/*View.swift` source. The exercise validates whether the spec is sufficient to drive an implementation on its own.

## How to read this directory

| File pattern | What it is |
| ------------ | ---------- |
| `OnboardingPrototypeV1View.swift` … `V4View.swift` | Onboarding (`§1`) iterated 4 times. Started from a Stitch-derived translation; each version closed gaps that the previous one exposed. |
| `HomePrototypeV1View.swift` … `V4View.swift` | Home (`§2`) iterated 4 times alongside Onboarding. |
| `CommunityPrototypeV4View.swift`, `QAListPrototypeV4View.swift`, `QADetailPrototypeV4View.swift`, `VolunteerMatchPrototypeV4View.swift`, `MessageListPrototypeV4View.swift`, `ChatPrototypeV4View.swift` | The other 6 pages. First version is V4 — by then the workflow had stabilised on Onboarding + Home, so a single pass was enough. |

So 14 files = 4 + 4 + 6, organised by page, version-suffixed.

## Why these stay in the repo

After `Pages/*View.swift` graduated to the V4 implementation, this directory could have been deleted — but each generation captures **a decision the spec was not yet able to make on its own**. They're kept as:

- **Evolution evidence** — a reviewer can open V1 and V4 of the same page side by side and see the spec gaps that closed between them.
- **Regression baseline** — if a future spec change breaks an assumption, the pinned V1–V4 ladder shows where the assumption was first introduced.
- **Workflow demo** — graduating courses / portfolios reading the repo can see the spec-driven loop concretely, not just described.

## The two-shape pattern

The two pages with full V1→V4 ladders (Onboarding, Home) are the ones the workflow was *invented on*. Everything experimental — control vocabulary, copy authority rule, the back-bar / page-hero split — surfaced first there.

The other 6 pages were re-implemented *after* the workflow stabilised, so they only have V4. That's not laziness; it's evidence that the spec was now mature enough to drive an implementation in one pass.

## How each prototype declares its inputs

Every file's top comment includes:

- ✅ **What I read** — every doc / token file / Component init signature consulted.
- ❌ **What I deliberately did NOT read** — the corresponding `Pages/*View.swift`, V1/V2/V3 of the same page (would amount to copying the existing implementation), and Component bodies past the init signature.
- **SPEC GAP markers** — every place the spec was insufficient and the prototype had to self-pick a token, copy, or behaviour. Each gap suggests a future spec or component-library improvement.

These comments are the durable artefact of the experiment, not the prototype code itself. The code graduated to `Pages/`; the gap log stays here.

## Running them

The directory is part of the same Swift Package as `Components/` and `Pages/`. Open any file in Xcode, hit `⌥⌘↵`, pick **iPhone Dynamic Island** as the preview target — every prototype has a `#Preview` block.
