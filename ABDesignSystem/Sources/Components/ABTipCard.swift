import SwiftUI

// MARK: - ABTipCard

/// Warm peach tip card — used for advisory/contextual hints (e.g. profile completion).
struct ABTipCard: View {
    let title: String
    let bodyText: String
    var icon: String = "lightbulb.fill"

    var body: some View {
        ABCard(variant: .tip) {
            HStack(alignment: .top, spacing: ABSpacing.s4) {
                ZStack {
                    Circle()
                        .fill(Color.abAccentGoldDark.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.abAccentGoldDark)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.abTitleSm)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.abAccentGoldDark)

                    Text(bodyText)
                        .font(.abBodySm)
                        .foregroundStyle(Color.abAccentGoldDark.opacity(0.85))
                        .lineSpacing(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// MARK: - Preview

#Preview("Tip Card") {
    VStack {
        ABTipCard(
            title: "Heads-up",
            bodyText: "We use this to filter housing rules to your state and visa type. You can edit it anytime in Profile."
        )
        .padding()
    }
    .background(Color.abSurface)
}
