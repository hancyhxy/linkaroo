import SwiftUI

// MARK: - Shadow Modifiers — per design.md §4 "Tonal Layering & Ambient Light"
// Philosophy: traditional black drop-shadows are too heavy. We use blue-tinted ambient
// shadows (`rgba(0, 30, 47, 0.06)` family) so depth feels atmospheric, not dropped.
// The "Layering Principle" (design.md §4) prefers tonal lift over shadows where possible —
// shadows are reserved for floating / overlay surfaces.

/// Extra-subtle card lift — barely visible, used on most cards
struct ABShadowXS: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color(hex: "001E2F").opacity(0.04), radius: 1, x: 0, y: 1)
    }
}

/// Subtle card lift, segmented control active tab
struct ABShadowSm: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: "001E2F").opacity(0.05), radius: 2, x: 0, y: 1)
            .shadow(color: Color(hex: "001E2F").opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

/// Floating headers, sticky bars — primary "ambient" recipe from design.md §4
struct ABShadowAmbient: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color(hex: "001E2F").opacity(0.06), radius: 16, x: 0, y: 4)
    }
}

/// Primary CTA (gradient button) — Pacific-tinted lift
struct ABShadowCTA: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: "39ACFF").opacity(0.20), radius: 12, x: 0, y: 8)
            .shadow(color: Color(hex: "39ACFF").opacity(0.20), radius: 4, x: 0, y: 4)
    }
}

/// Hero cards, elevated surfaces (Volunteer Hero Card)
struct ABShadowCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: "001E2F").opacity(0.10), radius: 12, x: 0, y: 8)
            .shadow(color: Color(hex: "001E2F").opacity(0.06), radius: 4, x: 0, y: 3)
    }
}

/// Upward shadow for bottom navigation
struct ABShadowUpward: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color(hex: "001E2F").opacity(0.06), radius: 16, x: 0, y: -4)
    }
}

// MARK: - View Extensions

extension View {
    func abShadowXS() -> some View { modifier(ABShadowXS()) }
    func abShadowSm() -> some View { modifier(ABShadowSm()) }
    func abShadowAmbient() -> some View { modifier(ABShadowAmbient()) }
    func abShadowCTA() -> some View { modifier(ABShadowCTA()) }
    func abShadowCard() -> some View { modifier(ABShadowCard()) }
    func abShadowUpward() -> some View { modifier(ABShadowUpward()) }
}

// MARK: - Frosted Glass Modifier (design.md §2 "Glass & Gradient Rule")
// `surface` at 80% opacity with 20px backdrop-blur for floating elements.

struct ABFrostedGlass: ViewModifier {
    var tintColor: Color = Color(hex: "F7FAFB")
    var tintOpacity: Double = 0.80

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(tintColor.opacity(tintOpacity))
    }
}

extension View {
    /// Frosted glass effect matching design.md §2 ("`surface` 80% + 20px blur")
    func abFrostedGlass(tint: Color = Color(hex: "F7FAFB"), opacity: Double = 0.80) -> some View {
        modifier(ABFrostedGlass(tintColor: tint, tintOpacity: opacity))
    }

    /// White frosted glass for bottom navigation and floating bars
    func abWhiteFrostedGlass() -> some View {
        modifier(ABFrostedGlass(tintColor: .white, tintOpacity: 0.90))
    }
}

// MARK: - Ghost Border Modifier (design.md §4 "Ghost Border Fallback")
// `outline-variant` at 15% opacity. Never 100% opaque borders for section dividers.

struct ABGhostBorder: ViewModifier {
    var cornerRadius: CGFloat = ABRadius.xl
    var color: Color = Color(hex: "41484E")
    var opacity: Double = 0.15

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color.opacity(opacity), lineWidth: 1)
        )
    }
}

extension View {
    func abGhostBorder(radius: CGFloat = ABRadius.xl) -> some View {
        modifier(ABGhostBorder(cornerRadius: radius))
    }

    /// Pastel-coloured border for selected-state cards (sky or peach)
    func abPastelBorder(color: Color, radius: CGFloat = ABRadius.xl, width: CGFloat = 1.5) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: width)
        )
    }
}
