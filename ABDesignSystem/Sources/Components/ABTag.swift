import SwiftUI

// MARK: - Tag Style

public enum ABTagStyle {
    /// Blue — STUDENT MATCH, SENIOR MATCH
    case contextMatch
    /// Green solid — GOVERNMENT VERIFIED
    case verified
    /// Light green — NEW, NEWCOMER
    case new
    /// Amber — UNVERIFIED, SOURCE: TIKTOK
    case warning
    /// Red with strikethrough — OLD LAW
    case error
    /// Gray muted — outdated info
    case outdated
    /// Gold solid — FEATURED GUIDE, TOP CHOICE
    case gold
    /// Light blue — UNSW Alumna, Legal Background
    case skillBlue
    /// Warm orange — NSW Renting Specialist
    case skillWarm
    /// Amber — Top Advice
    case topAdvice
    /// Match percentage badge
    case matchPercent

    public var backgroundColor: Color {
        switch self {
        case .contextMatch, .skillBlue, .matchPercent: return .abTagContextBg
        case .verified: return .abTagVerifiedBg
        case .new: return .abTagNewBg
        case .warning, .topAdvice: return .abTagWarningBg
        case .error: return .abTagErrorBg
        case .outdated: return .abTagOutdatedBg
        case .gold: return .abTagGoldBg
        case .skillWarm: return .abTagSkillWarmBg
        }
    }

    public var textColor: Color {
        switch self {
        case .contextMatch, .skillBlue, .matchPercent: return .abTagContextText
        case .verified: return .abTagVerifiedText
        case .new: return .abTagNewText
        case .warning, .topAdvice: return .abTagWarningText
        case .error: return .abTagErrorText
        case .outdated: return .abTagOutdatedText
        case .gold: return .abTagGoldText
        case .skillWarm: return .abTagSkillWarmText
        }
    }

    public var hasStrikethrough: Bool {
        self == .error
    }
}

// MARK: - Tag Size

public enum ABTagSize {
    /// 9px — STUDENT MATCH, OLD LAW, GOVERNMENT VERIFIED
    case micro
    /// 10px — skill tags, category tags
    case small
    /// 12px — TOP CHOICE, FEATURED GUIDE, match percentage
    case badge

    public var font: Font {
        switch self {
        case .micro: return .abMicro
        case .small: return .abLabelSm
        case .badge: return .abLabelMd
        }
    }

    public var horizontalPadding: CGFloat {
        switch self {
        case .micro: return 8
        case .small: return 8
        case .badge: return 12
        }
    }

    public var verticalPadding: CGFloat {
        switch self {
        case .micro: return 3
        case .small: return 2
        case .badge: return 5
        }
    }

    public var tracking: CGFloat {
        switch self {
        case .micro: return 0.9
        case .small: return 0.5
        case .badge: return 0.5
        }
    }
}

// MARK: - ABTag View

public struct ABTag: View {
    public let text: String
    public var style: ABTagStyle = .contextMatch
    public var size: ABTagSize = .micro
    public var icon: String? = nil

    public var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: size == .micro ? 9 : 11))
                    .foregroundStyle(style.textColor)
            }
            Text(text.uppercased())
                .font(size.font)
                .tracking(size.tracking)
                .foregroundStyle(style.textColor)
                .strikethrough(style.hasStrikethrough, color: style.textColor)
        }
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(style.backgroundColor)
        .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview("Tag Styles") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            ABTag(text: "Student Match", style: .contextMatch)
            ABTag(text: "Government Verified", style: .verified, icon: "checkmark.shield.fill")
            ABTag(text: "Newcomer", style: .new)
            ABTag(text: "Unverified", style: .warning)
            ABTag(text: "Old Law", style: .error)
            ABTag(text: "Outdated", style: .outdated)
            ABTag(text: "Featured Guide", style: .gold, size: .badge)
            ABTag(text: "UNSW Alumna", style: .skillBlue, size: .small)
            ABTag(text: "NSW Renting Specialist", style: .skillWarm, size: .small)
            ABTag(text: "Top Advice", style: .topAdvice, size: .badge)
            ABTag(text: "82% Match", style: .matchPercent, size: .badge)
        }
        .padding()
    }
}
