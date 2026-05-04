import SwiftUI

// MARK: - Font Constants — per design.md §3 "Editorial Authority"
// Display/Headline → Public Sans (geometric, authoritative clarity)
// Body/Label → Inter (world-class legibility at small scales)
// Brand wordmark → Liberation Serif italic (editorial moments)
// Token names preserved for backward compatibility.

extension Font {
    // Public Sans — Display & Headlines (editorial wow-moments, "wayfinding")
    static let abDisplayLg = Font.custom("PublicSans-Black", size: 36, relativeTo: .largeTitle)
    static let abDisplayMd = Font.custom("PublicSans-ExtraBold", size: 30, relativeTo: .title)
    static let abHeadlineLg = Font.custom("PublicSans-Black", size: 24, relativeTo: .title2)
    static let abHeadlineMd = Font.custom("PublicSans-Bold", size: 20, relativeTo: .title3)

    // Inter — Titles (UI-leaning, scannable at card-density)
    static let abTitleLg = Font.custom("Inter-Bold", size: 18, relativeTo: .headline)
    static let abTitleMd = Font.custom("Inter-Bold", size: 16, relativeTo: .headline)
    static let abTitleSm = Font.custom("Inter-Bold", size: 14, relativeTo: .subheadline)

    // Inter — Body & Labels (1.6× line-height per design.md §3, applied via lineSpacing below)
    static let abBodyLg = Font.custom("Inter-Regular", size: 18, relativeTo: .body)
    static let abBodyMd = Font.custom("Inter-Regular", size: 16, relativeTo: .body)
    static let abBodySm = Font.custom("Inter-Regular", size: 14, relativeTo: .subheadline)
    static let abLabelLg = Font.custom("Inter-SemiBold", size: 14, relativeTo: .subheadline)
    static let abLabelMd = Font.custom("Inter-SemiBold", size: 12, relativeTo: .caption)
    static let abLabelSm = Font.custom("Inter-SemiBold", size: 10, relativeTo: .caption2)
    static let abCaption = Font.custom("Inter-Regular", size: 10, relativeTo: .caption2)
    static let abMicro = Font.custom("Inter-Bold", size: 9, relativeTo: .caption2)

    // Liberation Serif italic — brand wordmark ("AussieBridge" header)
    static let abBrand = Font.custom("LiberationSerif-Italic", size: 22, relativeTo: .title3)
}

// MARK: - Text Style ViewModifiers
// Bundle font + color + tracking + line spacing (1.6× ratios per design.md §3).
// Usage: `Text("Hello").modifier(ABTextStyle.displayLg())` or `.abTextStyle(.bodyMd())`

struct ABTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let tracking: CGFloat
    let lineSpacing: CGFloat

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
            .lineSpacing(lineSpacing)
    }
}

extension ABTextStyle {
    /// 36px Public Sans Black — hero headings ("wayfinding moments")
    static func displayLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abDisplayLg, color: color, tracking: -0.9, lineSpacing: 9)
    }

    /// 30px Public Sans ExtraBold — major section titles
    static func displayMd(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abDisplayMd, color: color, tracking: -0.75, lineSpacing: 7.5)
    }

    /// 24px Public Sans Black — page hero text, brand wayfinding
    static func headlineLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abHeadlineLg, color: color, tracking: -0.6, lineSpacing: 8)
    }

    /// 20px Public Sans Bold — section headers
    static func headlineMd(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abHeadlineMd, color: color, tracking: -0.5, lineSpacing: 8)
    }

    /// 18px Inter Bold — card titles, volunteer names
    static func titleLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abTitleLg, color: color, tracking: 0, lineSpacing: 10)
    }

    /// 16px Inter Bold — Q&A titles, sub-headers
    static func titleMd(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abTitleMd, color: color, tracking: 0, lineSpacing: 8)
    }

    /// 14px Inter Bold — recommendation titles, message preview bold
    static func titleSm(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abTitleSm, color: color, tracking: 0, lineSpacing: 6)
    }

    /// 18px Inter Regular — hero subtitle paragraphs (1.625× line-height for L2 readers)
    static func bodyLg(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abBodyLg, color: color, tracking: 0, lineSpacing: 11)
    }

    /// 16px Inter Regular — card descriptions, form options
    static func bodyMd(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abBodyMd, color: color, tracking: 0, lineSpacing: 8)
    }

    /// 14px Inter Regular — Q&A preview, community posts, chat messages
    static func bodySm(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abBodySm, color: color, tracking: 0, lineSpacing: 6)
    }

    /// 14px Inter SemiBold — button text, tab labels
    static func labelLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abLabelLg, color: color, tracking: 0, lineSpacing: 6)
    }

    /// 12px Inter SemiBold — comments count, share text
    static func labelMd(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abLabelMd, color: color, tracking: 0, lineSpacing: 4)
    }

    /// 10px Inter SemiBold — tab bar labels, bottom nav, badge text
    static func labelSm(color: Color = .abOnSurfaceDisabled) -> ABTextStyle {
        ABTextStyle(font: .abLabelSm, color: color, tracking: 0.5, lineSpacing: 5)
    }

    /// 10px Inter Regular — timestamps, "Posted by" text
    static func caption(color: Color = .abOnSurfaceDisabled) -> ABTextStyle {
        ABTextStyle(font: .abCaption, color: color, tracking: 0, lineSpacing: 5)
    }

    /// 9px Inter Bold uppercase — tag text (STUDENT MATCH, etc.)
    static func micro(color: Color = .abTagContextText) -> ABTextStyle {
        ABTextStyle(font: .abMicro, color: color, tracking: 0.9, lineSpacing: 4.5)
    }
}

// MARK: - View Extension for Convenience

extension View {
    func abTextStyle(_ style: ABTextStyle) -> some View {
        modifier(style)
    }
}
