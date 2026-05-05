import SwiftUI

// MARK: - Shadow Modifiers — per design.md §4 "Tonal Layering & Ambient Light"
// Philosophy: traditional black drop-shadows are too heavy. We use blue-tinted ambient
// shadows (`rgba(0, 30, 47, 0.06)` family) so depth feels atmospheric, not dropped.
// The "Layering Principle" (design.md §4) prefers tonal lift over shadows where possible —
// shadows are reserved for floating / overlay surfaces.

/// Extra-subtle card lift — barely visible, used on most cards
public struct ABShadowXS: ViewModifier {
    public func body(content: Content) -> some View {
        content.shadow(color: Color(hex: "001E2F").opacity(0.04), radius: 1, x: 0, y: 1)
    }
}

/// Subtle card lift, segmented control active tab
public struct ABShadowSm: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: "001E2F").opacity(0.05), radius: 2, x: 0, y: 1)
            .shadow(color: Color(hex: "001E2F").opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

/// Floating headers, sticky bars — primary "ambient" recipe from design.md §4
public struct ABShadowAmbient: ViewModifier {
    public func body(content: Content) -> some View {
        content.shadow(color: Color(hex: "001E2F").opacity(0.06), radius: 16, x: 0, y: 4)
    }
}

/// Primary CTA (gradient button) — Pacific-tinted lift
public struct ABShadowCTA: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: "39ACFF").opacity(0.20), radius: 12, x: 0, y: 8)
            .shadow(color: Color(hex: "39ACFF").opacity(0.20), radius: 4, x: 0, y: 4)
    }
}

/// Hero cards, elevated surfaces (Volunteer Hero Card)
public struct ABShadowCard: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: "001E2F").opacity(0.10), radius: 12, x: 0, y: 8)
            .shadow(color: Color(hex: "001E2F").opacity(0.06), radius: 4, x: 0, y: 3)
    }
}

/// Upward shadow for bottom navigation
public struct ABShadowUpward: ViewModifier {
    public func body(content: Content) -> some View {
        content.shadow(color: Color(hex: "001E2F").opacity(0.06), radius: 16, x: 0, y: -4)
    }
}

// MARK: - View Extensions

extension View {
    public func abShadowXS() -> some View { modifier(ABShadowXS()) }
    public func abShadowSm() -> some View { modifier(ABShadowSm()) }
    public func abShadowAmbient() -> some View { modifier(ABShadowAmbient()) }
    public func abShadowCTA() -> some View { modifier(ABShadowCTA()) }
    public func abShadowCard() -> some View { modifier(ABShadowCard()) }
    public func abShadowUpward() -> some View { modifier(ABShadowUpward()) }
}

// MARK: - Frosted Glass Modifier (design.md §2 "Glass & Gradient Rule")
// `surface` at 80% opacity with 20px backdrop-blur for floating elements.

public struct ABFrostedGlass: ViewModifier {
    public var tintColor: Color = Color(hex: "F7FAFB")
    public var tintOpacity: Double = 0.80

    public func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(tintColor.opacity(tintOpacity))
    }
}

extension View {
    /// Frosted glass effect matching design.md §2 ("`surface` 80% + 20px blur")
    public func abFrostedGlass(tint: Color = Color(hex: "F7FAFB"), opacity: Double = 0.80) -> some View {
        modifier(ABFrostedGlass(tintColor: tint, tintOpacity: opacity))
    }

    /// White frosted glass for bottom navigation and floating bars
    public func abWhiteFrostedGlass() -> some View {
        modifier(ABFrostedGlass(tintColor: .white, tintOpacity: 0.90))
    }
}

// MARK: - Ghost Border Modifier (design.md §4 "Ghost Border Fallback")
// `outline-variant` at 15% opacity. Never 100% opaque borders for section dividers.

public struct ABGhostBorder: ViewModifier {
    public var cornerRadius: CGFloat = ABRadius.xl
    public var color: Color = Color(hex: "41484E")
    public var opacity: Double = 0.15

    public func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color.opacity(opacity), lineWidth: 1)
        )
    }
}

extension View {
    public func abGhostBorder(radius: CGFloat = ABRadius.xl) -> some View {
        modifier(ABGhostBorder(cornerRadius: radius))
    }

    /// Pastel-coloured border for selected-state cards (sky or peach)
    public func abPastelBorder(color: Color, radius: CGFloat = ABRadius.xl, width: CGFloat = 1.5) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: width)
        )
    }
}
