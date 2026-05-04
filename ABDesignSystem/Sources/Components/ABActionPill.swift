import SwiftUI

// MARK: - Action Pill Variant

enum ABActionPillVariant {
    case blue
    case orange
}

// MARK: - ABActionPill

/// Horizontal-scroll pill with leading icon. Used in chat for context actions
/// (e.g. "Share My Profile Tags", "Suggest a 5-min call").
struct ABActionPill: View {
    let text: String
    let icon: String
    var variant: ABActionPillVariant = .blue
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                Text(text)
                    .font(.abLabelMd)
                    .fontWeight(.medium)
            }
            .foregroundStyle(textColor)
            .padding(.horizontal, ABSpacing.s3)
            .padding(.vertical, ABSpacing.s2)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(ABPressStyle())
    }

    private var backgroundColor: Color {
        switch variant {
        case .blue: return Color.abActionPillBlueBg
        case .orange: return Color.abActionPillOrangeBg
        }
    }

    private var textColor: Color {
        switch variant {
        case .blue: return Color.abPrimary
        case .orange: return Color.abAccentOrangeDark
        }
    }

    private var borderColor: Color {
        switch variant {
        case .blue: return Color.abSelectedBorder
        case .orange: return Color.abAccentOrange
        }
    }
}

// MARK: - Preview

#Preview("Action Pill") {
    HStack(spacing: 8) {
        ABActionPill(text: "Share My Profile Tags", icon: "person.text.rectangle")
        ABActionPill(text: "Suggest a 5-min call", icon: "phone.fill", variant: .orange)
    }
    .padding()
    .background(Color.abSurface)
}
