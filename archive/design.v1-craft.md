# Design System Specification: The Compass & The Coast

## 1. Overview & Creative North Star

**App Name:** AussieBridge  
**Creative North Star: The Anchored Horizon**

This design system moves away from the "utility-only" aesthetic of typical government or support apps. Instead, it adopts a **High-End Editorial** approach that balances the authoritative trust of an established institution with the warmth of a welcoming home. We achieve this through "The Anchored Horizon" — a layout philosophy where deep, stable oceanic blues (`primary`) meet the airy, expansive light of the Australian coast (`surface`).

To break the "template" look, we employ **Intentional Asymmetry**. Hero sections feature overlapping elements — such as a `display-lg` headline partially superimposed over a soft, glassmorphic card — to create a sense of movement and organic growth. This system is not a flat grid; it is a series of layered experiences designed to guide a newcomer through a complex journey with clarity and grace.

**Design Variation:** Context-First — the app senses user identity, location, and urgency to filter information into personalised guidance.

---

## 2. Color System

### 2.1 Primary Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#00639b` | Nav text, links, CTA fills, accent borders |
| `primary-bright` | `#39acff` | Selected borders, gradient end, active indicators |
| `primary-gradient` | `linear-gradient(135deg, #39acff, #00639b)` | Primary CTA buttons, send button, hero cards |
| `primary-gradient-editorial` | `linear-gradient(164deg, #00639b, #39acff)` | Alternate gradient direction for editorial sections |

### 2.2 Surface Hierarchy (The "No-Line" Rule)

Designers are **prohibited** from using 1px solid borders for sectioning. Structural boundaries are defined through background color shifts or tonal transitions.

| Token | Hex | Opacity Variant | Usage |
|-------|-----|----------------|-------|
| `surface` | `#f7f9ff` | — | Page background, base layer |
| `surface-card` | `#ffffff` | — | Cards, input backgrounds, modals |
| `surface-container` | `#f0f4fb` | — | Service icon backgrounds, quote blocks, vote columns |
| `surface-frosted` | `rgba(247,249,255,0.85)` | 85% | Frosted glass headers |
| `surface-frosted-white` | `rgba(255,255,255,0.9)` | 90% | Bottom nav bars, floating action bars |
| `surface-dark` | `#2c3136` | — | Featured guide card, dark editorial sections |

### 2.3 Text Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `on-surface` | `#171c21` | Headlines, primary body text, card titles |
| `on-surface-variant` | `#3f4851` | Subtitles, secondary descriptions, meta text |
| `on-surface-disabled` | `#9ca3af` | Placeholder text, inactive tab labels, timestamps |
| `on-primary` | `#ffffff` | Text on primary buttons/gradients |
| `on-dark` | `#edf1f8` | Text on dark surfaces |

### 2.4 Semantic Tag Colors

| Category | Background | Text | Usage |
|----------|-----------|------|-------|
| `tag-context` | `#e8f4ff` / `#e0f2fe` | `#00639b` / `#0369a1` | STUDENT MATCH, SENIOR MATCH |
| `tag-verified` | `#059669` (solid) | `#ffffff` | GOVERNMENT VERIFIED |
| `tag-new` | `#dcfce7` / `#fef3c7` | `#16a34a` / `#92400e` | NEW, NEWCOMER |
| `tag-warning` | `#fef3c7` / `#fffbeb` | `#d97706` / `#b45309` | UNVERIFIED, SOURCE: TIKTOK |
| `tag-outdated` | `#f1f5f9` | `#64748b` | OLD LAW (with strikethrough) |
| `tag-gold` | `#855400` / `#c4983f` | `#ffffff` / `#553300` | FEATURED GUIDE, TOP CHOICE |
| `tag-skill-blue` | `#cee5ff` / `rgba(181,216,253,0.5)` | `#001d33` / `#3c5e7e` | UNSW Alumna, Legal Background |
| `tag-skill-warm` | `#ffddb7` | `#2a1700` | NSW Renting Specialist |

### 2.5 Accent & Status Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `accent-gold` | `#ffddb7` | Warm tip cards, tertiary CTA pills |
| `accent-gold-dark` | `#855400` / `#653e00` | Gold badge text on warm backgrounds |
| `accent-orange` | `#f97316` / `#ea580c` | Call-to-action pills (e.g., "Suggest a 5-min call") |
| `accent-orange-surface` | `#fff7ed` / `#fff3e0` | Orange pill backgrounds, warm skill tag backgrounds |
| `status-online` | `#22c55e` / `#16a34a` | Online indicator dot, "Online" label text |
| `status-unread` | `#ef4444` | Unread badge, notification dots |
| `status-selected` | `#e6f4ff` | Selected option background (blue tint) |
| `border-selected` | `#39acff` | 2px border on selected items |
| `surface-message-unread` | `rgba(240,249,255,0.5)` | Unread message row background |
| `avatar-fallback-gradient` | `linear-gradient(135deg, #f97316, #ea580c)` | Initial-based avatar background when no photo |
| `chat-outgoing` | `#dbeafe` | Outgoing chat bubble background |
| `action-pill-blue-bg` | `#f0f8ff` | Blue action pill background (chat) |
| `action-pill-orange-bg` | `#fff7ed` | Orange action pill background (chat) |

### 2.6 Tag Error & Outdated Colors (Addendum)

| Token | Background | Text | Decoration | Usage |
|-------|-----------|------|-----------|-------|
| `tag-error` | `#fee2e2` | `#dc2626` | `line-through` | OLD LAW (deprecated/incorrect info) |
| `tag-top-advice` | `#fef3c7` | `#d97706` | — | Top Advice badge in community cards |
| `tag-skill-warm-alt` | `#fff3e0` | `#e65100` | — | Warm skill tags (NSW Renting Specialist) |

### 2.7 Alternate Palette Reference (Google Stitch / Dark Mode Candidate)

For reference, the original Google Stitch creative brief used a deeper, more muted primary palette. These values are preserved as potential **Dark Mode** candidates:

| Token | Google Stitch Hex | Current Hex | Notes |
|-------|------------------|-------------|-------|
| `primary` | `#003955` | `#00639b` | Deeper ocean blue |
| `primary-container` | `#005177` | `#39acff` | Mid-tone blue |
| `surface` | `#f7fafb` | `#f7f9ff` | Slightly warmer |
| `on-surface` | `#181c1d` | `#171c21` | Near-identical |
| `on-surface-variant` | `#41484e` | `#3f4851` | Near-identical |
| `outline-variant` | — | — | Used at 15% opacity for ghost borders |

**Decision:** HTML prototypes use the brighter palette (`#00639b` / `#39acff`) as canonical. The Google Stitch palette may be revisited for dark mode or high-density contexts.

### 2.8 The Glass & Gradient Rule

- **Floating Elements:** Use `surface-frosted` (rgba(247,249,255,0.85)) with `backdrop-filter: blur(12px)` for headers and floating action bars.
- **Signature CTA:** Apply `primary-gradient` for all primary action buttons. The gradient adds "soul" that flat hex codes cannot achieve.
- **Hero Overlays:** Use `linear-gradient(to bottom, rgba(0,0,0,0.2), rgba(0,0,0,0.55))` over hero images.

---

## 3. Typography System

### 3.1 Font Stack

| Role | Family | Fallback | Usage |
|------|--------|----------|-------|
| Display & Headlines | **Public Sans** | system-ui, sans-serif | Page titles, section headers, wayfinding moments |
| Body & Labels | **Inter** | system-ui, sans-serif | Body text, meta info, button labels, input text |
| Brand & Editorial | **Liberation Serif** | Georgia, serif | App logo ("AussieBridge"), editorial section headings |

### 3.2 Type Scale

| Token | Size | Weight | Line Height | Tracking | Usage |
|-------|------|--------|-------------|----------|-------|
| `display-lg` | 36px | 900 (Black) | 1.25 (45px) | -0.9px | Hero headings ("Let's personalize your journey") |
| `display-md` | 30px | 800 (ExtraBold) | 1.25 (37.5px) | -0.75px | Major section titles ("Best Matches for You") |
| `headline-lg` | 24px | 900 (Black) | 1.33 (32px) | -0.6px | Page hero text, brand name |
| `headline-md` | 20px | 700/800 (Bold/ExtraBold) | 1.4 (28px) | -0.5px | Section headers ("Essential Services", "Volunteer") |
| `title-lg` | 18px | 700 (Bold) | 1.56 (28px) | — | Card titles, volunteer names, tip card headers |
| `title-md` | 16px | 700 (Bold) | 1.5 (24px) | — | Q&A post titles, status card names, sub-headers |
| `title-sm` | 14px | 700 (Bold) | 1.43 (20px) | — | Recommendation titles, message preview bold text |
| `body-lg` | 18px | 400 | 1.625 (29px) | — | Hero subtitle paragraphs |
| `body-md` | 16px | 400/500 | 1.5 (24px) | — | Card descriptions, form options, volunteer bios |
| `body-sm` | 14px | 400 | 1.43 (20px) | — | Q&A preview text, community posts, chat messages |
| `label-lg` | 14px | 600/700 | 1.43 (20px) | — | Button text, tab labels, action text |
| `label-md` | 12px | 600/700 | 1.33 (16px) | — | Comments count, share text, meta labels |
| `label-sm` | 10px | 600/700 | 1.5 (15px) | 0.5-1px | Tab bar labels, bottom nav, badge text |
| `caption` | 10px | 400/500 | 1.5 (15px) | — | Timestamps, "Posted by" text |
| `micro` | 9px | 700 | 1.5 (13.5px) | 0.9px | Tag text (STUDENT MATCH, etc.), uppercase badges |

### 3.3 Typography Rules

- **Tonal Hierarchy:** Headlines use `on-surface` (#171c21); secondary descriptions use `on-surface-variant` (#3f4851).
- **Editorial Insets:** Push body text in further than headlines to create asymmetric rhythm.
- **Line Height for Accessibility:** body-lg uses 1.625x for maximum readability for non-native English speakers.
- **All-Caps Convention:** Tags, badge labels, and tab-bar icons use `uppercase` + `tracking-wider` (letter-spacing 0.5-1.2px).

---

## 4. Spacing & Layout

### 4.1 Spacing Scale (Base: 4px)

| Token | Value | Usage |
|-------|-------|-------|
| `space-1` | 4px | Tight gaps (icon-to-badge, inline elements) |
| `space-1.5` | 6px | Badge internal gaps, compact stacks |
| `space-2` | 8px | Default inline gaps, tag rows |
| `space-3` | 12px | Card internal gaps, grid gaps, between meta items |
| `space-4` | 16px | Section padding, card padding standard |
| `space-5` | 20px | Card padding generous, horizontal page padding |
| `space-6` | 24px | Section vertical gaps, between major elements |
| `space-8` | 32px | Large section margins |
| `space-10` | 40px | Section top padding after header |
| `space-12` | 48px | Between form fieldsets, maximum breathing room |
| `space-16` | 64px | Between major page sections |

### 4.2 Border Radius Scale

| Token | Value | Usage |
|-------|-------|-------|
| `radius-sm` | 6px | Tags, small badges |
| `radius-md` | 8px | Segmented control buttons, small cards |
| `radius-lg` | 12px | Buttons, input fields, icon containers, tab pills |
| `radius-xl` | 16px | Cards, modals, bottom nav bar corners |
| `radius-2xl` | 24px | Hero sections, large cards, tip cards |
| `radius-3xl` | 32px | Extra-large decorative containers |
| `radius-full` | 9999px | Avatars, pill buttons, badges, circular elements |

### 4.3 Layout Containers

| Container | Width | Usage |
|-----------|-------|-------|
| `phone-frame` | 390px | iPhone 14 Pro frame simulation |
| `content-max` | 768px | Max content width for responsive scaling |
| `card-horizontal` | 280px | Horizontal scroll cards (Community "People You Can Help") |

### 4.4 Grid Systems

| Pattern | Columns | Gap | Usage |
|---------|---------|-----|-------|
| Language Selection | 2-col | 12px | Onboarding language picker |
| Essential Services | 2-col (5 rows) | 16px | Homepage category grid |
| More Matches | 1-col | 24px | Volunteer secondary cards |

---

## 5. Elevation & Depth

### 5.1 Shadow Scale

| Token | Value | Usage |
|-------|-------|-------|
| `shadow-none` | none | Default for most cards (use tonal lift instead) |
| `shadow-sm` | `0px 1px 2px rgba(0,0,0,0.05)` | Subtle card lift, segmented control active tab |
| `shadow-ambient` | `0px 10px 40px rgba(0,30,47,0.06)` | Floating headers, major overlays (blue-tinted) |
| `shadow-cta` | `0px 20px 25px -5px rgba(57,172,255,0.2), 0px 8px 10px -6px rgba(57,172,255,0.2)` | Primary gradient buttons |
| `shadow-card` | `0px 10px 15px -3px rgba(0,0,0,0.1), 0px 4px 6px -4px rgba(0,0,0,0.1)` | Hero volunteer card, map overlay |

### 5.2 Layering Principles

- **Tonal Lift:** Place `surface-card` (#fff) on `surface` (#f7f9ff) background. The contrast provides elevation without shadows.
- **Ambient Shadows:** Use blue-tinted shadows (`rgba(0,30,47,...)`) rather than pure black.
- **Ghost Border Fallback:** If a border is required for accessibility, use `outline-variant` at 15% opacity. Never use 100% opaque borders for section dividers.
- **Frosted Glass:** `backdrop-filter: blur(12px)` + semi-transparent background for floating elements.

---

## 6. Component Specifications

### 6.1 Top App Bar (Header)

```
Height: 64px
Background: surface-frosted (rgba(247,249,255,0.9)) + backdrop-blur(12px)
Shadow: shadow-ambient (0px 10px 40px rgba(0,30,47,0.06))
Position: sticky top-0, z-index 50
Content padding: horizontal 24px
Bottom accent: 2px gradient line (primary-bright 20% → transparent)

Variants:
├── Brand Header: "AussieBridge" italic bold, color primary
├── Page Header: Back arrow (32px) + Page title (headline-md, on-surface)
└── Chat Header: Back arrow + Avatar (40px) + Name/Status + Menu icon
```

### 6.2 Bottom Navigation Bar

```
Height: ~77px (including safe area)
Background: surface-frosted-white (rgba(255,255,255,0.9)) + backdrop-blur(12px)
Shadow: 0px -10px 40px rgba(0,30,47,0.06) (upward)
Border-radius: radius-xl top-left, radius-xl top-right
Position: fixed bottom-0

Items: 3 tabs (Home, Community, Profile)
├── Active: primary color icon + label, bg primary/10 rounded-lg padding
└── Inactive: on-surface-variant icon + label

Icon size: 24px (width varies by icon)
Label: label-sm (10px), uppercase, tracking 0.5px
Gap icon→label: space-1 (4px)
```

### 6.3 Segmented Control (Tabs)

```
Container: bg #e5e8ef, radius-lg (12px), padding 4px
Tab: flex-1, radius-md (8px), padding vertical 8px

Active state:
├── Background: surface-card (white)
├── Shadow: shadow-sm
├── Text: label-lg bold, color primary
└── Optional: badge (status-unread bg, 20px circle, white bold text)

Inactive state:
├── Background: transparent
├── Text: label-lg semibold, color on-surface-variant
```

### 6.4 Horizontal Category Tabs

```
Container: horizontal scroll, gap space-2 (8px), padding horizontal 16px
Tab pill: radius-full, padding horizontal 16px vertical 6px

Active state:
├── Background: #e0f2fe (light blue)
├── Icon + Text: color #0c4a6e, font-semibold
└── Icon size: ~12px

Inactive state:
├── Background: transparent
├── Text: color #475569, font-normal
└── Icon + Text layout same
```

### 6.5 Buttons

#### Primary CTA (Gradient)
```
Background: primary-gradient (linear-gradient 135deg/164deg)
Text: on-primary (white), label-lg bold, centered
Padding: vertical 16px, horizontal 40px
Border-radius: radius-full (9999px) or radius-lg (12px)
Shadow: shadow-cta
Min-height: 56-64px (large), 48px (medium)
```

#### Secondary Button
```
Background: surface-card (white)
Border: 1px solid outline-variant at 20% opacity
Text: primary (#00639b), label-lg bold
Padding: vertical 11px, horizontal auto
Border-radius: radius-md (8px)
```

#### Text Button
```
Background: transparent
Text: on-surface-variant (#3f4851), label-lg bold
Padding: vertical 16px, horizontal ~44px
```

#### Action Pill (Contextual)
```
Background: tag-skill-blue (#b5d8fd) or accent-gold (#ffddb7)
Text: label-md medium, matching darker shade
Padding: vertical 8px, horizontal 16px
Border-radius: radius-full
Icon: 11-12px, leading
Layout: flex items-center gap-2
```

### 6.6 Tags & Badges

```
Base: uppercase, tracking 0.5-1px, radius-sm (6px) or radius-full

Size micro (9px):
├── Padding: horizontal 9px, vertical 3px
├── Font: micro (9px), bold
└── Use: STUDENT MATCH, OLD LAW, GOVERNMENT VERIFIED

Size small (10px):
├── Padding: horizontal 8px, vertical 2px
├── Font: label-sm (10px), bold
└── Use: skill tags, category tags

Size badge (12px):
├── Padding: horizontal 12px, vertical 4-6px
├── Font: label-md (12px), bold
└── Use: TOP CHOICE, FEATURED GUIDE, match percentage
```

### 6.7 Cards

#### Standard Content Card
```
Background: surface-card (white)
Padding: space-4 to space-5 (16-20px)
Border-radius: radius-xl (16px)
Shadow: shadow-sm or tonal lift (no shadow)
Border: 1px rgba(223,227,234,0.3) (ghost border)
```

#### Q&A Post Card
```
Background: surface-card
Border-bottom: 1px #eaeef5
Padding: vertical 16-17px, horizontal 16px
Layout: flex gap-3
├── Vote Column: flex-col items-center gap-1, width 32px
│   ├── Upvote icon (16px)
│   ├── Count (label-md bold, on-surface)
│   └── Downvote icon (16px)
└── Content Column: flex-1
    ├── Tag row: flex gap-2
    ├── Meta: "Posted by u/name • time" (caption, on-surface-variant)
    ├── Title: title-md bold (Public Sans)
    ├── Preview: body-sm, on-surface-variant, 2 lines max
    ├── Top Answer block (optional): see Quote Block
    └── Actions: flex gap-4 (Comments count, Share)
```

#### Volunteer Hero Card
```
Background: surface-card
Border-radius: radius-2xl (24px)
Shadow: shadow-card
Overflow: hidden
├── Image section: h-256px, cover fit
│   └── Frosted overlay at bottom: backdrop-blur(6px), bg white/70%
│       ├── Match label + percentage
│       └── TOP CHOICE badge
├── Content section: padding 32px
│   ├── Name (display-md) + Role + Rating + Stats
│   ├── Skill tags row (3 pills)
│   ├── Bio (body-md, on-surface-variant)
│   └── Primary CTA (gradient, radius-lg)
└── Decorative: blur circle (primary-bright 20%, 128px)
```

#### Message Item
```
Layout: flex gap-4 items-center
Padding: horizontal 8px, vertical 16px
Background: rgba(240,249,255,0.5) for unread, transparent for read
Border-radius: radius-lg (12px)
├── Avatar: 56px circle, with optional online indicator (14px green dot, white border)
├── Content: flex-1
│   ├── Name (title-md bold) + Timestamp (caption bold, primary)
│   └── Preview (title-sm bold for unread, body-sm normal for read)
└── Unread dot: 8px circle, status-unread (#ef4444)
```

#### Chat Bubble
```
Incoming (left):
├── Avatar: 32px circle, bottom-aligned
├── Bubble: surface-card, radius-xl + radius-tl-xl, no radius-bl
├── Padding: 16px
├── Text: body-sm, on-surface
└── Timestamp: caption (10px), on-surface-disabled, right-aligned

Outgoing (right):
├── Bubble: primary-bright/20% bg, border 1px primary/10%
├── Border-radius: radius-xl + radius-tr-xl, no radius-br
├── Text: body-sm, #003e63 (dark blue)
└── Timestamp: caption, primary-dark/60%
```

### 6.8 Shared Context Card (Chat)

```
Background: surface-container (#f0f4fb)
Border-left: 4px solid primary (#00639b)
Border-radius: radius-lg (12px)
Shadow: shadow-sm
Padding: 16px left(20px)
Layout: flex gap-4
├── Icon: 32x36px document/context icon
└── Content:
    ├── Label: "SHARED CONTEXT" (micro uppercase, tracking 1.1px, primary)
    ├── Title: title-sm semibold (Public Sans), on-surface
    └── Link: "View Q&A Post →" (label-md medium, primary)
```

### 6.9 Quote / Top Answer Block

```
Background: surface-container (#f0f4fb)
Border-left: 4px solid primary/20%
Border-radius: radius-md (8px)
Padding: 12px, left 16px
├── Header (optional): icon + "Top Answer" (label-md semibold, primary)
└── Text: body-sm, on-surface, italic quotes
```

### 6.10 Info/Tip Card (Warm)

```
Background: accent-gold (#ffddb7)
Border-radius: radius-3xl (32px)
Padding: space-6 (24px)
Overflow: hidden (for decorative elements)
Layout: flex gap-6
├── Icon container: 48px, bg accent-gold-dark/10%, radius-xl
└── Content:
    ├── Title: title-lg bold (Public Sans), #2a1700
    └── Body: body-sm, accent-gold-dark (#653e00)
Decorative: overflow element bottom-right
```

### 6.11 Form Elements

#### Selection Card (Radio-style)
```
Unselected:
├── Background: surface-card
├── Border: 2px solid transparent
├── Border-radius: radius-lg (12px)
├── Padding: 22px or 18px
└── Text: body-md medium, on-surface

Selected:
├── Background: status-selected (#e6f4ff)
├── Border: 2px solid border-selected (#39acff)
├── Checkmark: 24px circle, bg primary-bright, white check icon
└── Text: body-md medium, on-surface
```

#### Text Input
```
Background: #dfe3ea (surface-container-high)
Border-radius: radius-xl (16px)
Padding: vertical 20px, horizontal 24px (left 48px when icon present)
Text: body-md medium, on-surface
Icon: absolute left 16px, centered vertically
```

#### Search Bar (Hero variant)
```
Outer: bg white/20%, backdrop-blur(12px), border 1px white/20%
Inner: bg surface-card, radius-md (8px)
Padding: horizontal 16px, vertical 10px
Icon: 15px search, leading
Placeholder: label-lg semibold, on-surface-variant/60%
Shadow: shadow-card on outer container
```

### 6.12 Service Icon Grid Item

```
Container: flex-col items-center gap-3
Background: surface-container (#f0f4fb)
Border-radius: radius-xl (16px)
Padding: space-6 (24px)
Icon container: 48px, bg primary/10%, radius-lg (12px)
Icon: 20-25px
Label: title-md bold (Inter), on-surface, centered
```

---

## 7. Responsive Strategy & Xcode Migration

### 7.1 Responsive Web (Current Implementation)

```
Mobile-first approach:
├── Base: 390px (iPhone 14 Pro) — current design target
├── Small phone: 320px — reduce horizontal padding to 16px
├── Large phone: 428px — maintain 390px content, center
├── Tablet: 768px — max-width 768px container, 2-column layouts
└── Desktop: 1280px — max-width 896px content area

Breakpoints:
├── sm: 390px (design baseline)
├── md: 768px (tablet)
└── lg: 1280px (desktop)
```

### 7.2 SwiftUI Migration Guide

#### Color System → SwiftUI
```swift
// Color+AussieBridge.swift
extension Color {
    // Primary
    static let abPrimary = Color(hex: "00639b")
    static let abPrimaryBright = Color(hex: "39acff")
    
    // Surface
    static let abSurface = Color(hex: "f7f9ff")
    static let abSurfaceCard = Color.white
    static let abSurfaceContainer = Color(hex: "f0f4fb")
    
    // Text
    static let abOnSurface = Color(hex: "171c21")
    static let abOnSurfaceVariant = Color(hex: "3f4851")
    static let abOnSurfaceDisabled = Color(hex: "9ca3af")
    
    // Semantic
    static let abAccentGold = Color(hex: "ffddb7")
    static let abStatusOnline = Color(hex: "22c55e")
    static let abStatusUnread = Color(hex: "ef4444")
    static let abSelected = Color(hex: "e6f4ff")
    static let abSelectedBorder = Color(hex: "39acff")
}
```

#### Typography → SwiftUI
```swift
// Typography+AussieBridge.swift
extension Font {
    // Public Sans for headlines
    static let abDisplayLg = Font.custom("PublicSans-Black", size: 36)
    static let abDisplayMd = Font.custom("PublicSans-ExtraBold", size: 30)
    static let abHeadlineLg = Font.custom("PublicSans-Black", size: 24)
    static let abHeadlineMd = Font.custom("PublicSans-Bold", size: 20)
    static let abTitleLg = Font.custom("PublicSans-Bold", size: 18)
    static let abTitleMd = Font.custom("Inter-Bold", size: 16)
    
    // Inter for body
    static let abBodyLg = Font.custom("Inter-Regular", size: 18)
    static let abBodyMd = Font.custom("Inter-Regular", size: 16)
    static let abBodySm = Font.custom("Inter-Regular", size: 14)
    static let abLabelLg = Font.custom("Inter-Bold", size: 14)
    static let abLabelMd = Font.custom("Inter-Bold", size: 12)
    static let abLabelSm = Font.custom("Inter-SemiBold", size: 10)
}
```

#### Key Components → SwiftUI Mapping

| Web Component | SwiftUI Equivalent |
|---------------|-------------------|
| Frosted header | `.background(.ultraThinMaterial)` + `.toolbarBackground(.visible, for: .navigationBar)` |
| Bottom tab bar | `TabView` with custom styling |
| Gradient button | `Button` with `.background(LinearGradient(...))` |
| Card | `VStack` in `.background(RoundedRectangle).shadow(...)` |
| Segmented control | `Picker` with `.pickerStyle(.segmented)` or custom |
| Tags/Badges | Custom `Text` view with `.padding()` + `.background(Capsule().fill(...))` |
| Horizontal scroll | `ScrollView(.horizontal)` with `LazyHStack` |
| Vote column | Custom `VStack` with stepper-like interaction |
| Chat bubbles | Custom `HStack` alignment with `ChatBubbleShape` |
| Frosted glass | `.background(.ultraThinMaterial)` (iOS 15+) |

#### Xcode Project Setup Checklist
1. Add **Public Sans** and **Inter** font files to Xcode project
2. Register fonts in `Info.plist` under `UIAppFontNames`
3. Create `Color.xcassets` with all design tokens
4. Create `ABDesignSystem` Swift package or folder with:
   - `ABColors.swift` — Color extensions
   - `ABTypography.swift` — Font extensions
   - `ABComponents/` — Reusable SwiftUI views
5. Use `@Environment(\.colorScheme)` for future dark mode support

---

## 8. Do's and Don'ts

### Do
- **Do** use white space as a structural element. If crowded, increase to `space-12` (48px).
- **Do** use "Editorial Insets" — push body text in further than headlines for asymmetric rhythm.
- **Do** use high-quality, warm-toned photography of Australian landscapes, layered behind glassmorphic overlays.
- **Do** use the tag color system consistently — blue for context matches, green for verified, amber for warnings.
- **Do** use `backdrop-filter: blur(12px)` for all floating/sticky elements.

### Don't
- **Don't** use pure black (#000000) for text or shadows. Use `on-surface` (#171c21).
- **Don't** use "Default" rounded corners (4px). Lean into the `radius-lg` (12px) scale minimum.
- **Don't** use vertical dividers or 1px borders for sections. Use the surface hierarchy.
- **Don't** use "Alert Red" for anything but errors. Use `accent-gold` for warnings.
- **Don't** use more than 2 gradient angles in a single screen — maintain visual consistency.
- **Don't** use flat drop-shadows. Always use blue-tinted ambient shadows.

---

## 9. Asset Inventory

### Icon Sets Required
- Navigation: Home, Community, Profile, Back arrow, Menu (3-dot), Close
- Actions: Search, Share, Save/Bookmark, Comment, Send, Plus, Filter
- Voting: Upvote arrow, Downvote arrow
- Status: Checkmark (in circle), Online dot, Unread dot, Verified shield
- Categories: Job, Housing, Healthcare, Visa, Bank, Education, Transport, Social, Finance, Utilities
- Context: Document/Post link, Location pin, Detect location, Star rating, Crown/best fit, People group
- Communication: Chat bubble, Phone/call, Profile tags

### Photography Guidelines
- Hero images: Australian landmarks (Opera House, coastlines) with warm daylight tones
- Volunteer portraits: Professional but approachable, diverse representation
- Map tiles: Light theme, minimal labels, blue accent for location markers

---

## 10. Additional Component Specifications

### 10.1 Featured Guide Card (Dark)

*Source: homepage.html lines 117-125*

```
Background: surface-dark (#2c3136)
Border-radius: radius-xl (16px)
Padding: space-5 (20px)

Content:
├── Badge: tag-gold (#c4983f bg, white text), radius-full, 10px bold, px-2.5 py-1
├── Title: title-lg bold, white (#ffffff), margin-top space-3
├── Description: body-sm (12px), #9ca3af (gray-400), margin-top space-2
└── CTA Button: accent color (#39acff), white text, radius-full, py-2.5 px-5
    ├── Icon: 16px trailing arrow (brightness-0 invert for white)
    └── Text: label-lg semibold
```

### 10.2 CTA Banner Card (Gradient)

*Source: qa.html lines 161-171*

```
Background: primary-gradient (linear-gradient 135deg, #39acff → #00639b)
Border-radius: radius-xl (16px)
Padding: space-5 (20px)
Text-align: center
Overflow: hidden (for decorative element)

Content:
├── Decorative: absolute right-0 top-0 h-full opacity-20 image
├── Title: title-md bold, white, margin-bottom space-2
├── Description: body-sm, white/80%, margin-bottom space-4
└── CTA Button (Inverted):
    ├── Background: white
    ├── Text: primary (#00639b), label-lg semibold
    ├── Border-radius: radius-full
    ├── Padding: py-2.5 px-6
    ├── Icon: 16px leading
    └── Layout: flex items-center gap-2, mx-auto (centered)
```

### 10.3 Help/Opportunity Card (Horizontal Scroll)

*Source: community.html lines 52-94*

```
Width: 280px (fixed, horizontal scroll)
Background: surface-card (white)
Border-radius: radius-xl (16px)
Padding: space-4 (16px)
flex-shrink: 0

Content:
├── Header Row: flex items-center gap-3
│   ├── Avatar: 40px circle, object-cover
│   ├── Name: title-sm bold, on-surface
│   └── Subtitle: 11px, on-surface-disabled
├── Tag Row: flex flex-wrap gap-1.5, margin-top space-3
│   └── Tags: micro (9px) bold, radius-full, various semantic colors
├── Quote: body-sm (12px), on-surface-variant, leading-relaxed, margin-top space-3
├── Achievement Badge (optional): flex items-center gap-1.5
│   ├── Container: px-3 py-2, radius-lg, bg #fff8e1 or #f0f8ff
│   ├── Icon: 16px medal/context icon
│   └── Text: 10px, matching color (#b45309 or #00639b)
└── CTA: Primary gradient button, full-width, radius-full, margin-top space-3
    └── Text: label-sm bold, white
```

### 10.4 Date Separator

*Source: chat.html lines 56-58*

```
Layout: flex items-center justify-center, margin-vertical space-5
Pill:
├── Background: #e5e7eb (gray-200)
├── Text: 10px font-medium, #9ca3af (on-surface-disabled)
├── Padding: horizontal space-4 (16px), vertical space-1 (4px)
└── Border-radius: radius-full (9999px)
```

### 10.5 Chip Picker (Duration Selector)

*Source: personalization.html lines 90-96*

```
Container: flex flex-wrap gap-2

Chip (Unselected):
├── Background: surface-card (white)
├── Border: 1px solid gray-200
├── Text: 12px font-medium, on-surface-variant (#3f4851)
├── Padding: vertical 8px, horizontal 16px
└── Border-radius: radius-full (9999px)

Chip (Selected):
├── Background: status-selected (#e8f4ff)
├── Border: 2px solid border-selected (#39acff)
├── Text: 12px font-medium, primary (#00639b)
├── Padding: vertical 8px, horizontal 16px
└── Border-radius: radius-full (9999px)
```

### 10.6 Avatar Variants

Three distinct avatar patterns appear across the prototype:

```
Variant A — Image Avatar:
├── Size: 32px (chat), 40px (card header), 48px (message list), 56px (message detail)
├── Shape: circle (rounded-full)
├── Fit: object-cover
└── Online Indicator (optional):
    ├── Size: 10px (small) / 14px (large)
    ├── Color: status-online (#22c55e / green-400)
    ├── Border: 2px solid white
    └── Position: absolute bottom-0 right-0

Variant B — Initial Avatar:
├── Size: same scale as Image Avatar
├── Shape: circle
├── Background: avatar-fallback-gradient (linear-gradient 135deg, #f97316 → #ea580c)
├── Text: font-bold, white, centered
│   ├── 48px avatar → 14px text
│   └── 24px avatar → 9px text
└── Used when: no profile photo available

Variant C — Micro Avatar (Chat):
├── Size: 28-32px
├── Shape: circle
├── Position: bottom-aligned with message bubble
└── Only shown for incoming messages
```

### 10.7 Action Pill (Chat Context)

*Source: chat.html lines 86-98*

```
Container: horizontal scroll, gap space-2, padding horizontal 16px

Pill:
├── Layout: flex items-center gap-1.5
├── Border-radius: radius-full
├── Padding: horizontal 12px, vertical 8px
├── flex-shrink: 0 (no wrapping)

Blue Variant:
├── Background: action-pill-blue-bg (#f0f8ff)
├── Border: 1px solid #39acff
├── Icon: 16px
├── Text: 11px font-medium, primary (#00639b)

Orange Variant:
├── Background: action-pill-orange-bg (#fff7ed)
├── Border: 1px solid #f97316
├── Icon: 16px
├── Text: 11px font-medium, accent-orange (#ea580c)
```

### 10.8 Sticky Footer Bar

*Source: personalization.html lines 113-116*

```
Position: fixed bottom-0
Width: 390px (phone-frame)
Background: surface-frosted (rgba(247,249,255,0.95)) + backdrop-blur(12px)
Border-top: 1px solid #e5e7eb
Padding: horizontal 20px, vertical 16px

Layout: flex items-center justify-between gap-4
├── Skip Button: text button, body-sm font-medium, on-surface-variant
└── Primary CTA: flex-1, gradient button, radius-full, py-3
```

### 10.9 Chat Input Area

*Source: chat.html lines 102-110*

```
Container: flex items-center gap-3, padding horizontal 16px, padding-bottom 32px (safe area), padding-top 8px

Elements:
├── Plus Button: 36px circle, pre-styled icon
├── Text Input: flex-1
│   ├── Background: gray-100
│   ├── Border-radius: radius-full
│   ├── Padding: horizontal 16px, vertical 10px
│   └── Placeholder: body-sm, on-surface-disabled
└── Send Button: 36px circle
    ├── Background: primary-gradient
    ├── Icon: 16px, white
    └── Border-radius: radius-full
```

---

## 11. Interaction States

All interactive components define three states: **Default**, **Pressed**, and **Disabled**.

### 11.1 State Definitions

| Component | Default | Pressed | Disabled |
|-----------|---------|---------|----------|
| **Primary CTA (Gradient)** | gradient fill + shadow-cta | scale(0.97), shadow reduced 50% | opacity 0.5, flat gray (#9ca3af), no gradient |
| **Secondary Button** | white bg, border #39acff | bg surface-container (#f0f4fb) | opacity 0.4 |
| **Text Button** | transparent | text color darkened 10% | opacity 0.4, no tap response |
| **Action Pill** | border + light bg fill | bg darkened 10% | opacity 0.4 |
| **Card (tappable)** | shadow-sm or tonal lift | scale(0.98), shadow-none | opacity 0.6 |
| **Segmented Tab** | transparent bg | bg white/50% | n/a (always at least one active) |
| **Category Tab Pill** | white bg + border | bg primary/10% | opacity 0.4 |
| **Vote Arrow** | on-surface-variant color | primary-bright fill | on-surface-disabled |
| **Message Item** | transparent (read) / unread bg | bg surface-container | n/a |
| **Chat Bubble** | static (no interaction) | — | — |
| **Selection Card** | white bg, gray border | bg #f5f7fa | opacity 0.4 |
| **Chip (pill)** | white bg, gray border | bg selected (#e8f4ff) | opacity 0.4 |

### 11.2 Focus States (Accessibility)

For keyboard/assistive technology navigation:
- All interactive elements: 2px outline, color `primary-bright` (#39acff), offset 2px
- Input fields: transition background from `#dfe3ea` to `surface-card` (white), apply 2px border `surface-tint` (#39acff)

---

## 12. Animation & Transition Specifications

### 12.1 Timing Functions

| Token | Duration | Easing | Usage |
|-------|----------|--------|-------|
| `transition-standard` | 200ms | ease-out | Button presses, tab switches, toggle states |
| `transition-emphasized` | 350ms | ease-in-out | Page transitions, modal presentation |
| `spring-interactive` | — | damping: 0.7, stiffness: 300 | Card press/release, pull-to-refresh bounce |
| `spring-gentle` | — | damping: 0.8, stiffness: 200 | Tab bar item bounce, avatar appearance |
| `transition-subtle` | 150ms | ease-out | Tab bar label scale, tooltip fade |

### 12.2 Animation Patterns

| Pattern | Specification | Usage |
|---------|--------------|-------|
| **Button Press** | scale(0.97) with `spring-interactive` on touch-down, scale(1.0) on release | All tappable buttons |
| **Card Press** | scale(0.98) with `spring-interactive` | Tappable cards, message items |
| **Page Push** | Slide from right, 350ms ease-in-out | Navigation stack push |
| **Page Pop** | Slide to right, 300ms ease-in-out | Navigation stack pop |
| **Modal Present** | Slide from bottom + fade in, 300ms spring | Bottom sheets, action sheets |
| **Modal Dismiss** | Slide to bottom + fade out, 250ms ease-out | Modal close |
| **Horizontal Scroll** | Deceleration rate: `.fast`, snap to card edge | Horizontal scroll cards, category tabs |
| **Tab Switch** | Cross-fade content, 200ms ease-out | Segmented control content change |
| **Frosted Header** | Opacity transition on scroll (0% → 100%), 250ms | Header background appears on scroll |
| **Loading Shimmer** | Gradient sweep left→right, 1.5s linear infinite | Skeleton loading states |

### 12.3 Reduce Motion Alternatives

When the user has enabled **Reduce Motion** (accessibility setting):
- Replace all spring animations with simple opacity fades (200ms)
- Replace slide transitions with cross-fades
- Disable scale animations on press
- Keep scroll snap behavior (functional, not decorative)

---

## 13. Accessibility Guidelines

### 13.1 Touch Targets

- **Minimum size:** 44 × 44pt (Apple HIG requirement)
- **Buttons & tabs:** Already meet this requirement via padding
- **Vote arrows:** Visual size is 20px but tap area must be extended to 44px via `.contentShape(Rectangle())`
- **Tags:** Non-interactive, no tap target needed. If made tappable, extend to 44pt height.

### 13.2 Color Contrast Audit

| Combination | Foreground | Background | Ratio | WCAG | Status |
|-------------|-----------|------------|-------|------|--------|
| `on-surface` on `surface` | #171c21 | #f7f9ff | 14.5:1 | AAA | Pass |
| `on-surface` on `surface-card` | #171c21 | #ffffff | 15.4:1 | AAA | Pass |
| `on-surface-variant` on white | #3f4851 | #ffffff | 8.2:1 | AAA | Pass |
| `on-surface-disabled` on white | #9ca3af | #ffffff | 3.0:1 | — | **Fails AA small text** |
| `primary` on white | #00639b | #ffffff | 5.0:1 | AA | Pass |
| `on-primary` on `primary` | #ffffff | #00639b | 5.0:1 | AA | Pass |
| `tag-verified` text on bg | #ffffff | #059669 | 4.6:1 | AA | Pass |

**Recommendation:** `on-surface-disabled` (#9ca3af) only achieves 3.0:1. This is acceptable for decorative timestamps (WCAG incidental text exception), but consider using **#6b7280** (ratio 5.0:1) for any disabled text that conveys meaningful information.

### 13.3 VoiceOver Strategy

- **Cards:** Group as single accessible elements with summary labels (e.g., "Q&A post by SydneySilver, 142 upvotes, What are the best suburbs for seniors")
- **Tags:** Read as part of the parent card's label, not as individual elements
- **Vote column:** Expose as adjustable element (increment/decrement)
- **Tab bars:** Use `.accessibilityElement(children: .contain)` with role `.tabBar`
- **Images:** Decorative images use `.accessibilityHidden(true)`, content images provide meaningful descriptions

### 13.4 Dynamic Type Support

All text sizes must scale with the system Dynamic Type setting:
- SwiftUI: Use `Font.custom(_:size:relativeTo:)` to map custom fonts to system text styles
- Map: `display-lg` → `.largeTitle`, `headline-md` → `.headline`, `body-md` → `.body`, `caption` → `.caption`, `micro` → `.caption2`
- Set `.minimumScaleFactor(0.75)` on single-line text that may overflow
- Cards should grow vertically (not clip) when text scales up

### 13.5 Reduce Motion

See Section 12.3 for animation alternatives when Reduce Motion is enabled.

---

## 14. Component × Page Usage Matrix

| Component | home | community | volunteer | personal | chat | message | qa | qa_scroll |
|-----------|:----:|:---------:|:---------:|:--------:|:----:|:-------:|:--:|:---------:|
| **Header: Brand** | ✓ | | | | | | | |
| **Header: Page Title** | | ✓ | ✓ | ✓ | | ✓ | ✓ | ✓ |
| **Header: Chat** | | | | | ✓ | | | |
| **Bottom Tab Bar** | ✓ | ✓ | | | | ✓ | | |
| **Primary CTA (Gradient)** | ✓ | ✓ | ✓ | ✓ | ✓ | | | |
| **Secondary Button (Outline)** | | | ✓ | | | | | |
| **Text Button** | | | | ✓ | | | | |
| **Inverted Button (white on gradient)** | | | | | | | ✓ | ✓ |
| **Action Pill** | | | | | ✓ | | | |
| **Tags/Badges (micro)** | ✓ | ✓ | ✓ | | | | ✓ | ✓ |
| **Tags/Badges (skill, small)** | | | ✓ | | | | | |
| **Match % Badge** | | | ✓ | | | | | |
| **Standard Content Card** | ✓ | ✓ | | | | | | |
| **Featured Guide Card (dark)** | ✓ | | | | | | | |
| **CTA Banner Card (gradient)** | | | | | | | ✓ | ✓ |
| **Q&A Post Card** | | | | | | | ✓ | ✓ |
| **Volunteer Hero Card** | | | ✓ | | | | | |
| **Volunteer Match Card** | | | ✓ | | | | | |
| **Help/Opportunity Card** | | ✓ | | | | | | |
| **Message Item** | | | | | | ✓ | | |
| **Chat Bubble** | | | | | ✓ | | | |
| **Shared Context Card** | | | | | ✓ | | | |
| **Quote / Top Answer Block** | | ✓ | | | | | ✓ | ✓ |
| **Tip Card (Warm/Gold)** | | | | ✓ | | | | |
| **Selection Card (Icon)** | | | | ✓ | | | | |
| **Selection Card (Text/Language)** | | | | ✓ | | | | |
| **Chip Picker (Duration)** | | | | ✓ | | | | |
| **Segmented Control** | | ✓ | | | | ✓ | | |
| **Horizontal Category Tabs** | | | | | | | ✓ | ✓ |
| **Search Bar (Hero)** | ✓ | | | | | | | |
| **Service Icon Grid** | ✓ | | | | | | | |
| **Chat Input Area** | | | | | ✓ | | | |
| **Date Separator** | | | | | ✓ | | | |
| **Sticky Footer Bar** | | | | ✓ | | | | |
| **Avatar: Image** | | ✓ | ✓ | | ✓ | ✓ | | |
| **Avatar: Initials** | | | | | | ✓ | ✓ | |
| **Avatar: + Online Dot** | | | | | ✓ | ✓ | | |
| **Location Picker + Map** | | | | ✓ | | | | |
| **Vote Column** | | | | | | | ✓ | ✓ |

**Total unique components: 37**  
**Most reused:** Tags (5 pages), Primary CTA (5 pages), Header: Page Title (6 pages)
