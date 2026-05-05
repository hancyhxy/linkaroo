import SwiftUI

// MARK: - Section Title Level

/// Three-tier hierarchy for in-page section titles. Pick the level by
/// the section's role on the page, not by visual appeal:
///
/// - `.major`   — top-of-page editorial heading (e.g. Home's "Essential
///                Services" / "Recommend for You"). Reads as a real
///                heading, not a label.
/// - `.section` — form section / region heading inside a page (e.g.
///                Onboarding's "Preferred Language" / "Current Status").
///                Lower weight than `.major`, still title-cased.
/// - `.label`   — tightest fieldset-style label, all-caps with letter
///                tracking (e.g. tiny "Quick filters" above a chip row).
enum ABSectionTitleLevel {
    case major
    case section
    case label
}

// MARK: - ABSectionTitle

/// Single atomic title component. Replaces ad-hoc `sectionLabel(_:)` /
/// `sectionHeading(_:)` helpers each page would otherwise re-invent.
/// Spec.md references this as `section title (level: <case>)` in the
/// §0.4 control vocabulary.
struct ABSectionTitle: View {
    let text: String
    var level: ABSectionTitleLevel = .section

    init(_ text: String, level: ABSectionTitleLevel = .section) {
        self.text = text
        self.level = level
    }

    var body: some View {
        Text(displayText)
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(color)
            .tracking(tracking)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Per-level styling

    private var displayText: String {
        switch level {
        case .label: return text.uppercased()
        case .major, .section: return text
        }
    }

    private var font: Font {
        switch level {
        case .major:   return .abTitleLg     // 18pt Inter Bold
        case .section: return .abLabelLg     // 14pt Inter SemiBold
        case .label:   return .abLabelMd     // 12pt Inter SemiBold
        }
    }

    private var weight: Font.Weight {
        switch level {
        case .major:   return .bold
        case .section: return .semibold
        case .label:   return .semibold
        }
    }

    private var color: Color {
        switch level {
        case .major:   return .abOnSurface          // strong, near-black
        case .section: return .abOnSurface          // strong but smaller
        case .label:   return .abOnSurfaceVariant   // muted, supporting
        }
    }

    private var tracking: CGFloat {
        switch level {
        case .label: return 0.8                     // uppercase needs spacing
        case .major, .section: return 0
        }
    }
}

// MARK: - Preview

#Preview("ABSectionTitle — three levels") {
    VStack(alignment: .leading, spacing: ABSpacing.s6) {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            ABSectionTitle("Essential Services", level: .major)
            Text("Used at editorial heading level — Home page sections.")
                .font(.abBodySm)
                .foregroundStyle(Color.abOnSurfaceVariant)
        }

        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            ABSectionTitle("Preferred Language", level: .section)
            Text("Used as form-section heading — Onboarding regions.")
                .font(.abBodySm)
                .foregroundStyle(Color.abOnSurfaceVariant)
        }

        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            ABSectionTitle("Quick filters", level: .label)
            Text("Used as smallest tracked all-caps label.")
                .font(.abBodySm)
                .foregroundStyle(Color.abOnSurfaceVariant)
        }
    }
    .padding(ABSpacing.s5)
    .background(Color.abSurface)
}
