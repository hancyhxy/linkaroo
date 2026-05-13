# Linkaroo Banner Generator

Tiny Next.js app that renders the README banner (`screenshots/00-banner.png`) as a styled DOM and lets the browser export it as a PNG via `html-to-image`. Forked from the iSpent screenshot generator and trimmed to just the banner slide.

## Run locally

```sh
bun install
bun run dev
```

Open http://localhost:3000, click **Export 00-banner.png**, then move the downloaded file to the repo root:

```sh
mv ~/Downloads/00-banner.png ../screenshots/00-banner.png
```

## What lives where

| Path | Role |
|------|------|
| `app/page.tsx` | The `BannerSlide` component (canvas size, layout, colors, headline, subtitle, tag list) and the export-to-PNG button. |
| `app/layout.tsx` | Loads Inter + DM Serif Display fonts and sets the page title. |
| `public/logo.svg` | Linkaroo logo. **Symlink-style copy**: keep in sync with `docs/branding/logo.svg`. |
| `public/mockup.png` | Generic iPhone-frame asset, reused from iSpent. The `Phone` component composes a screenshot inside this frame. |
| `public/screenshots/02-home.png` | Home-page screenshot used inside the phone frame. **Copy from `screenshots/02-home.png`** — keep manually in sync if home page is re-screenshotted. |

## Brand palette (banner-only, calibrated against `docs/branding/logo.svg`)

| Token | Hex | Where |
|-------|-----|-------|
| `BRAND_DEEP` | `#0C2C5C` | Top accent bar |
| `BRAND_CYAN` | `#22D3EE` | Italic headline accent (`for you`) |
| `BG_WARM` | `linear-gradient(180deg, #F5F0EB → #E8DFD5)` | Banner background (lifted from iSpent — warm temperature against the cool brand pair) |
| `TEXT_DARK` | `#181C1D` | Headline + tag text (= `abOnSurface`) |
| `TEXT_MUTED` | `#41484E` | App name + subtitle + tag border (= `abOnSurfaceVariant`) |

The brand pair (`BRAND_DEEP` + `BRAND_CYAN`) comes from the logo, **not** from `ABColors.swift`. The design-system primary `#003955` is too teal next to cyan; the logo file's notes call this out explicitly. The warm background is a banner-only choice — `abSurface` (#F7FAFB) was tried first but reads as "unrendered white" against the white tag pills.

## Why not just edit a PNG in Figma

- The banner has 4 dynamic regions (headline / subtitle / tags / app name). Re-exporting via Figma every time copy changes is slow.
- This generator gives a single source of truth in code: change `BannerSlide` and re-export. Diffs are reviewable.
- Future variants (LinkedIn header sized at 1584×396, X header at 1500×500) are a matter of adding another canvas component, not redesigning a frame.

## ⚠️ Next.js version note

This project ships Next.js 16. `app/AGENTS.md` warns: APIs differ from training data. If something looks broken, read `node_modules/next/dist/docs/` before guessing.
