import SwiftUI

// MARK: - Hex Color Initializer

extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Primary Palette — "Anchored Horizon" (per design.md §2)
// Deep, stable Pacific blues. Authority + welcome — the "high-end editorial" feel
// described in design.md §1. Used for CTA fills, navigation, accent borders.

extension Color {
    /// Deep ocean — primary CTA fills, brand wordmark, navigation accent
    public static let abPrimary = Color(hex: "003955")

    /// Mid-tone Pacific — gradient end, hover states, secondary accents
    public static let abPrimaryBright = Color(hex: "005177")
}

// MARK: - Surface Hierarchy (the "fine paper stack" model, design.md §2)
// Treat the UI as a physical stack of fine paper. Tonal lift via background shift, never via 1px border.

extension Color {
    /// Page base — sun-drenched coast, the airy expansive light
    public static let abSurface = Color(hex: "F7FAFB")

    /// Interactive cards, modals, input lifted state — pure white pop
    public static let abSurfaceCard = Color.white

    /// Secondary section block (sits on `abSurface`)
    public static let abSurfaceContainer = Color(hex: "F1F4F5")

    /// Dark editorial sections (Featured Guide Card, dark panels)
    public static let abSurfaceDark = Color(hex: "181C1D")
}

// MARK: - Text Colors (design.md §3 "Tonal Hierarchy")

extension Color {
    /// Headlines, primary body text — deep editorial near-black
    public static let abOnSurface = Color(hex: "181C1D")

    /// Subtitles, secondary descriptors — clear information scent
    public static let abOnSurfaceVariant = Color(hex: "41484E")

    /// Placeholder text, inactive labels, timestamps
    public static let abOnSurfaceDisabled = Color(hex: "9CA3AF")

    /// Text on primary (deep blue) buttons
    public static let abOnPrimary = Color.white

    /// Text on dark surfaces
    public static let abOnDark = Color(hex: "EDF1F8")
}

// MARK: - LEGACY Pastel Card Accents
// Retained for backward compatibility with components built during the v1 (Craft) iteration.
// New components SHOULD prefer surface-container hierarchy + primary gradient per design.md.
// Marked for deprecation; do not extend.

extension Color {
    /// LEGACY — Cream / default document cards
    public static let abAccentCream = Color(hex: "F5F2E8")

    /// LEGACY — Peach / warm topics. Retained for `ABTipCard` etc.
    public static let abAccentPeach = Color(hex: "FDE5D4")

    /// LEGACY — Sky / tutorial / guidance
    public static let abAccentSky = Color(hex: "D8E5F5")

    /// LEGACY — Butter / reflective topics
    public static let abAccentButter = Color(hex: "FFF5D6")

    /// LEGACY — Sage / success / growth
    public static let abAccentSage = Color(hex: "D4E5D8")

    /// LEGACY — Lavender / community / social
    public static let abAccentLavender = Color(hex: "E0DCEE")
}

// MARK: - Border Accents

extension Color {
    /// Selected-state card border — ice-blue (echoes Pacific palette)
    public static let abBorderSky = Color(hex: "B8D4F0")

    /// LEGACY — soft peach border
    public static let abBorderPeach = Color(hex: "F2C9A8")

    /// Subtle ghost borders (per design.md §4 "outline-variant at 15% opacity")
    public static let abBorderHairline = Color(hex: "E5E3DD")
}

// MARK: - Semantic Tag Colors (per design.md §5 spec)

extension Color {
    // Context match (STUDENT MATCH, SENIOR MATCH) — light Pacific blue
    public static let abTagContextBg = Color(hex: "E0F2FE")
    public static let abTagContextText = Color(hex: "0369A1")

    // Verified (GOVERNMENT VERIFIED) — institutional green, solid
    public static let abTagVerifiedBg = Color(hex: "059669")
    public static let abTagVerifiedText = Color.white

    // New (NEW, NEWCOMER) — fresh green
    public static let abTagNewBg = Color(hex: "DCFCE7")
    public static let abTagNewText = Color(hex: "16A34A")

    // Warning (UNVERIFIED, SOURCE: TIKTOK) — amber
    public static let abTagWarningBg = Color(hex: "FEF3C7")
    public static let abTagWarningText = Color(hex: "D97706")

    // Error / Outdated (OLD LAW) — muted red with strikethrough
    public static let abTagErrorBg = Color(hex: "FEE2E2")
    public static let abTagErrorText = Color(hex: "DC2626")

    // Outdated (muted gray)
    public static let abTagOutdatedBg = Color(hex: "F1F5F9")
    public static let abTagOutdatedText = Color(hex: "64748B")

    // Gold (FEATURED GUIDE, TOP CHOICE) — warm sun on dark
    public static let abTagGoldBg = Color(hex: "C4983F")
    public static let abTagGoldText = Color.white

    // Skill blue (UNSW Alumna, Legal Background)
    public static let abTagSkillBlueBg = Color(hex: "CEE5FF")
    public static let abTagSkillBlueText = Color(hex: "001D33")

    // Skill warm (NSW Renting Specialist) — tertiary sun-warmth (design.md §5)
    public static let abTagSkillWarmBg = Color(hex: "FFDDB7")
    public static let abTagSkillWarmText = Color(hex: "2A1700")

    // Top Advice — amber, calmer than warning
    public static let abTagTopAdviceBg = Color(hex: "FEF3C7")
    public static let abTagTopAdviceText = Color(hex: "D97706")
}

// MARK: - Accent & Status Colors

extension Color {
    /// Tip card warm fill — sun-warmth, not pastel (design.md §5 "tertiary")
    public static let abAccentGold = Color(hex: "FFDDB7")
    /// Gold badge text on warm backgrounds
    public static let abAccentGoldDark = Color(hex: "855400")

    /// Orange accent for call-to-action pills
    public static let abAccentOrange = Color(hex: "F97316")
    /// Orange accent darker variant
    public static let abAccentOrangeDark = Color(hex: "EA580C")

    /// Online indicator dot — fresh green
    public static let abStatusOnline = Color(hex: "22C55E")
    /// Online label text
    public static let abStatusOnlineText = Color(hex: "16A34A")
    /// Unread badge, notification dots
    public static let abStatusUnread = Color(hex: "EF4444")
    /// Selected option background — light Pacific tint
    public static let abSelected = Color(hex: "E6F4FF")
    /// 2px border on selected items — bright Pacific
    public static let abSelectedBorder = Color(hex: "39ACFF")

    /// Outgoing chat bubble background — light Pacific tint
    public static let abChatOutgoing = Color(hex: "DBEAFE")
    /// Action pill blue background (chat)
    public static let abActionPillBlueBg = Color(hex: "F0F8FF")
    /// Action pill orange background (chat)
    public static let abActionPillOrangeBg = Color(hex: "FFF7ED")
}

// MARK: - Gradients (design.md §2 "Glass & Gradient Rule")

extension LinearGradient {
    /// Primary CTA — Pacific gradient adds "soul" beyond flat hex (design.md §2)
    public static let abPrimaryGradient = LinearGradient(
        colors: [Color(hex: "003955"), Color(hex: "005177")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Editorial variant — alternate gradient angle for hero sections
    public static let abPrimaryGradientEditorial = LinearGradient(
        colors: [Color(hex: "003955"), Color(hex: "39ACFF")],
        startPoint: .top,
        endPoint: .bottomTrailing
    )

    /// Hero image overlay — preserves photo legibility under headlines
    public static let abHeroOverlay = LinearGradient(
        colors: [
            Color.black.opacity(0.20),
            Color.black.opacity(0.55)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Avatar fallback — warm orange (initial-based avatars)
    public static let abAvatarFallback = LinearGradient(
        colors: [Color(hex: "F97316"), Color(hex: "EA580C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Frosted Glass Helpers (design.md §2 "Glass & Gradient Rule")

extension ShapeStyle where Self == Color {
    /// Surface frosted — for headers (`surface` at 85% with backdrop blur)
    public static var abSurfaceFrosted: Color {
        Color(hex: "F7FAFB").opacity(0.85)
    }

    /// White frosted — for bottom nav, floating action bars
    public static var abWhiteFrosted: Color {
        Color.white.opacity(0.90)
    }
}
