# Design System Specification: The Compass & The Coast

## 1. Overview & Creative North Star
**Creative North Star: The Anchored Horizon**
This design system moves away from the "utility-only" aesthetic of typical government or support apps. Instead, it adopts a **High-End Editorial** approach that balances the authoritative trust of an established institution with the warmth of a welcoming home. We achieve this through "The Anchored Horizon"—a layout philosophy where deep, stable oceanic blues (`primary`) meet the airy, expansive light of the Australian coast (`surface`).

To break the "template" look, we employ **Intentional Asymmetry**. Hero sections should feature overlapping elements—such as a `display-lg` headline partially superimposed over a soft, glassmorphic card—to create a sense of movement and organic growth. This system is not a flat grid; it is a series of layered experiences designed to guide a newcomer through a complex journey with clarity and grace.

---

## 2. Colors: Tonal Depth & The "No-Line" Rule
Our palette transitions from the deep stability of the Pacific (`primary`) to the sun-drenched warmth of the Outback (`tertiary`).

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning. Structural boundaries must be defined solely through background color shifts or tonal transitions.
- Use `surface-container-low` for large content blocks sitting on a `surface` background.
- Use `surface-container-highest` to draw immediate focus to a nested utility.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack of fine paper.
- **Base:** `surface` (#f7fafb)
- **Secondary Section:** `surface-container-low` (#f1f4f5)
- **Interactive Card:** `surface-container-lowest` (#ffffff)
This nesting creates a natural "lift" that guides the eye without the visual "noise" of outlines.

### The Glass & Gradient Rule
To ensure the system feels premium:
- **Floating Elements:** Use `surface` at 80% opacity with a `20px` backdrop-blur for navigation bars or floating action prompts.
- **Signature Textures:** Apply a subtle linear gradient (Top-Left to Bottom-Right) from `primary` (#003955) to `primary_container` (#005177) for primary CTAs. This adds a "soul" to the color that flat hex codes cannot achieve.

---

## 3. Typography: Editorial Authority
We pair **Public Sans** (Display/Headlines) for its geometric, authoritative clarity with **Inter** (Body/Labels) for its world-class legibility at small scales.

- **Display & Headline (Public Sans):** Used for "Wayfinding" moments. Use `display-lg` (3.5rem) with tighter tracking (-0.02em) to create an editorial, magazine-style impact.
- **Body & Title (Inter):** The "Workhorse." `body-lg` (1rem) is the standard for support articles. Ensure line-height is set to 1.6x for maximum readability for non-native English speakers.
- **Tonal Hierarchy:** Headlines should always use `on_surface` (#181c1d), while secondary descriptors use `on_surface_variant` (#41484e) to create a clear information scent.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are often too heavy. This system uses **Ambient Light** and **Tonal Lift**.

- **The Layering Principle:** Instead of a shadow, place a `surface-container-lowest` card atop a `surface-container-high` background. The contrast in "brightness" provides all the elevation needed.
- **Ambient Shadows:** For "Modal" components that must float, use a multi-layered shadow: `0px 10px 40px rgba(0, 30, 47, 0.06)`. Note the use of a blue-tinted shadow (`on_primary_fixed`) rather than pure black to maintain a natural, atmospheric feel.
- **Ghost Border Fallback:** If a border is required for accessibility (e.g., in high-contrast modes), use `outline_variant` at **15% opacity**. Never use a 100% opaque border.

---

## 5. Components: Friendly & Context-Aware
All components utilize the `md` (0.75rem) or `lg` (1rem) roundedness scale to feel approachable.

### Buttons
- **Primary:** Gradient fill (`primary` to `primary_container`), `on_primary` text, `lg` rounding.
- **Secondary:** `secondary_container` fill with `on_secondary_container` text. No border.
- **Interaction:** On hover, increase the "Glass" effect or shift the gradient intensity—do not simply darken the color.

### Contextual Inputs & Cards
- **Input Fields:** Use `surface_container_highest` as the fill. On focus, transition the background to `surface_container_lowest` and apply a 2px "Ghost Border" of `surface_tint`.
- **Cards & Lists:** **Strictly forbid divider lines.** Separate list items using `spacing-4` (1rem) and subtle background shifts (alternating between `surface` and `surface_container_low`).
- **Map Motifs:** Incorporate "Australian-inspired" subtle map paths as low-opacity SVG backgrounds (using `outline_variant` at 5% opacity) within large cards to provide local relevance.

### Specialized Components
- **The "Pathway" Stepper:** Use a wide, horizontal track using `secondary_fixed_dim` with `on_secondary_container` icons to visualize a user's immigration progress.
- **Support Chips:** Use `tertiary_fixed` (#ffe088) for "Help Available" or "Urgent" status to provide a warm, sun-like highlight that breaks the blue dominance.

---

## 6. Do's and Don'ts

### Do
- **Do** use white space as a structural element. If a layout feels crowded, increase spacing to `spacing-12` (3rem).
- **Do** use "Editorial Insets"—push body text in further than headlines to create a sophisticated, asymmetrical rhythm.
- **Do** use high-quality, warm-toned photography of Australian landscapes or diverse communities, layered behind glassmorphic overlays.

### Don't
- **Don't** use pure black (#000000) for text or shadows. Use `on_surface`.
- **Don't** use "Default" rounded corners (0.25rem). Lean into the `lg` (1rem) scale to maintain the "Friendly" brand promise.
- **Don't** use vertical dividers. Use the `surface-container` hierarchy to separate columns of data.
- **Don't** use "Alert Red" for anything but errors. Use `tertiary` (Gold) for warnings to keep the tone supportive rather than alarming.
