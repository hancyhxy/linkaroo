import SwiftUI

// MARK: - Spacing Scale (Base: 4px) — with Craft-style breathing room

enum ABSpacing {
    static let s1: CGFloat = 4
    static let s1_5: CGFloat = 6
    static let s2: CGFloat = 8
    static let s3: CGFloat = 12
    static let s4: CGFloat = 16
    static let s5: CGFloat = 20
    static let s6: CGFloat = 24
    static let s8: CGFloat = 32
    static let s10: CGFloat = 40
    static let s12: CGFloat = 48
    static let s16: CGFloat = 64
    static let s20: CGFloat = 80
    static let s24: CGFloat = 96
}

// MARK: - Border Radius Scale — softened for Craft aesthetic

enum ABRadius {
    /// 8pt — tags, small badges (was 6)
    static let sm: CGFloat = 8
    /// 12pt — segmented control buttons, small cards (was 8)
    static let md: CGFloat = 12
    /// 16pt — buttons, input fields, icon containers, tab pills (was 12)
    static let lg: CGFloat = 16
    /// 20pt — cards, modals, bottom nav bar corners (was 16)
    static let xl: CGFloat = 20
    /// 28pt — hero sections, large cards, tip cards (was 24)
    static let xxl: CGFloat = 28
    /// 36pt — extra-large decorative containers (was 32)
    static let xxxl: CGFloat = 36
    /// Capsule / pill shape
    static let full: CGFloat = .infinity
}

// MARK: - Layout Constants

enum ABLayout {
    /// iPhone 14 Pro frame width (design baseline)
    static let phoneFrame: CGFloat = 390
    /// Max content width for responsive scaling
    static let contentMax: CGFloat = 768
    /// Horizontal scroll card width (community "People You Can Help")
    static let cardHorizontal: CGFloat = 280
    /// Standard horizontal page padding
    static let pagePadding: CGFloat = 20
    /// Header height
    static let headerHeight: CGFloat = 64
    /// Bottom tab bar height (including safe area inset)
    static let tabBarHeight: CGFloat = 77
}

// MARK: - Icon Sizes

enum ABIconSize {
    static let xs: CGFloat = 12
    static let sm: CGFloat = 16
    static let md: CGFloat = 20
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Avatar Sizes

enum ABAvatarSize {
    /// Chat micro avatar (inline with bubble)
    static let micro: CGFloat = 28
    /// Small chat avatar
    static let sm: CGFloat = 32
    /// Card header avatar
    static let md: CGFloat = 40
    /// Message list avatar
    static let lg: CGFloat = 48
    /// Large message detail avatar
    static let xl: CGFloat = 56
}

// MARK: - Responsive Padding Modifier

struct ABResponsivePadding: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let padding: CGFloat = switch width {
            case ..<390: 16
            case 390..<429: 20
            case 429..<768: 24
            default: max((width - ABLayout.contentMax) / 2, 24)
            }
            content.padding(.horizontal, padding)
        }
    }
}

extension View {
    func abResponsivePadding() -> some View {
        modifier(ABResponsivePadding())
    }
}
