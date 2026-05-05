import SwiftUI

// MARK: - Font Constants — per design.md §3 "Editorial Authority"
// Display/Headline → Public Sans (geometric, authoritative clarity)
// Body/Label → Inter (world-class legibility at small scales)
// Brand wordmark → Liberation Serif italic (editorial moments)
// Token names preserved for backward compatibility.

extension Font {
    // Public Sans — Display & Headlines (editorial wow-moments, "wayfinding")
    public static let abDisplayLg = Font.custom("PublicSans-Black", size: 36, relativeTo: .largeTitle)
    public static let abDisplayMd = Font.custom("PublicSans-ExtraBold", size: 30, relativeTo: .title)
    public static let abHeadlineLg = Font.custom("PublicSans-Black", size: 24, relativeTo: .title2)
    public static let abHeadlineMd = Font.custom("PublicSans-Bold", size: 20, relativeTo: .title3)

    // Inter — Titles (UI-leaning, scannable at card-density)
    public static let abTitleLg = Font.custom("Inter-Bold", size: 18, relativeTo: .headline)
    public static let abTitleMd = Font.custom("Inter-Bold", size: 16, relativeTo: .headline)
    public static let abTitleSm = Font.custom("Inter-Bold", size: 14, relativeTo: .subheadline)

    // Inter — Body & Labels (1.6× line-height per design.md §3, applied via lineSpacing below)
    public static let abBodyLg = Font.custom("Inter-Regular", size: 18, relativeTo: .body)
    public static let abBodyMd = Font.custom("Inter-Regular", size: 16, relativeTo: .body)
    public static let abBodySm = Font.custom("Inter-Regular", size: 14, relativeTo: .subheadline)
    public static let abLabelLg = Font.custom("Inter-SemiBold", size: 14, relativeTo: .subheadline)
    public static let abLabelMd = Font.custom("Inter-SemiBold", size: 12, relativeTo: .caption)
    public static let abLabelSm = Font.custom("Inter-SemiBold", size: 10, relativeTo: .caption2)
    public static let abCaption = Font.custom("Inter-Regular", size: 10, relativeTo: .caption2)
    public static let abMicro = Font.custom("Inter-Bold", size: 9, relativeTo: .caption2)

    // Liberation Serif italic — brand wordmark ("AussieBridge" header)
    public static let abBrand = Font.custom("LiberationSerif-Italic", size: 22, relativeTo: .title3)
}

// MARK: - Text Style ViewModifiers
// Bundle font + color + tracking + line spacing (1.6× ratios per design.md §3).
// Usage: `Text("Hello").modifier(ABTextStyle.displayLg())` or `.abTextStyle(.bodyMd())`

public struct ABTextStyle: ViewModifier {
    public let font: Font
    public let color: Color
    public let tracking: CGFloat
    public let lineSpacing: CGFloat

    public func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
            .lineSpacing(lineSpacing)
    }
}

public extension ABTextStyle {
    /// 36px Public Sans Black — hero headings ("wayfinding moments")
    public static func displayLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abDisplayLg, color: color, tracking: -0.9, lineSpacing: 9)
    }

    /// 30px Public Sans ExtraBold — major section titles
    public static func displayMd(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abDisplayMd, color: color, tracking: -0.75, lineSpacing: 7.5)
    }

    /// 24px Public Sans Black — page hero text, brand wayfinding
    public static func headlineLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abHeadlineLg, color: color, tracking: -0.6, lineSpacing: 8)
    }

    /// 20px Public Sans Bold — section headers
    public static func headlineMd(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abHeadlineMd, color: color, tracking: -0.5, lineSpacing: 8)
    }

    /// 18px Inter Bold — card titles, volunteer names
    public static func titleLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abTitleLg, color: color, tracking: 0, lineSpacing: 10)
    }

    /// 16px Inter Bold — Q&A titles, sub-headers
    public static func titleMd(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abTitleMd, color: color, tracking: 0, lineSpacing: 8)
    }

    /// 14px Inter Bold — recommendation titles, message preview bold
    public static func titleSm(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abTitleSm, color: color, tracking: 0, lineSpacing: 6)
    }

    /// 18px Inter Regular — hero subtitle paragraphs (1.625× line-height for L2 readers)
    public static func bodyLg(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abBodyLg, color: color, tracking: 0, lineSpacing: 11)
    }

    /// 16px Inter Regular — card descriptions, form options
    public static func bodyMd(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abBodyMd, color: color, tracking: 0, lineSpacing: 8)
    }

    /// 14px Inter Regular — Q&A preview, community posts, chat messages
    public static func bodySm(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abBodySm, color: color, tracking: 0, lineSpacing: 6)
    }

    /// 14px Inter SemiBold — button text, tab labels
    public static func labelLg(color: Color = .abOnSurface) -> ABTextStyle {
        ABTextStyle(font: .abLabelLg, color: color, tracking: 0, lineSpacing: 6)
    }

    /// 12px Inter SemiBold — comments count, share text
    public static func labelMd(color: Color = .abOnSurfaceVariant) -> ABTextStyle {
        ABTextStyle(font: .abLabelMd, color: color, tracking: 0, lineSpacing: 4)
    }

    /// 10px Inter SemiBold — tab bar labels, bottom nav, badge text
    public static func labelSm(color: Color = .abOnSurfaceDisabled) -> ABTextStyle {
        ABTextStyle(font: .abLabelSm, color: color, tracking: 0.5, lineSpacing: 5)
    }

    /// 10px Inter Regular — timestamps, "Posted by" text
    public static func caption(color: Color = .abOnSurfaceDisabled) -> ABTextStyle {
        ABTextStyle(font: .abCaption, color: color, tracking: 0, lineSpacing: 5)
    }

    /// 9px Inter Bold uppercase — tag text (STUDENT MATCH, etc.)
    public static func micro(color: Color = .abTagContextText) -> ABTextStyle {
        ABTextStyle(font: .abMicro, color: color, tracking: 0.9, lineSpacing: 4.5)
    }
}

// MARK: - View Extension for Convenience

extension View {
    public func abTextStyle(_ style: ABTextStyle) -> some View {
        modifier(style)
    }
}
