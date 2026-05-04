import SwiftUI

// MARK: - ABFeaturedGuideCard

/// Dark editorial card for the home page "Featured Guide" — gold badge + title + description + CTA.
struct ABFeaturedGuideCard: View {
    let title: String
    let description: String
    var badgeText: String = "FEATURED GUIDE"
    var ctaTitle: String = "Start Reading"
    var onTap: (() -> Void)? = nil

    var body: some View {
        ABCard(variant: .featured) {
            VStack(alignment: .leading, spacing: ABSpacing.s3) {
                ABTag(text: badgeText, style: .gold, size: .small)

                Text(title)
                    .font(.abTitleLg)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)

                Text(description)
                    .font(.abBodySm)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .lineSpacing(3)

                Button(action: { onTap?() }) {
                    HStack(spacing: 6) {
                        Text(ctaTitle)
                            .font(.abLabelLg)
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, ABSpacing.s4)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
                }
                .buttonStyle(ABPressStyle())
                .padding(.top, ABSpacing.s1)
            }
        }
    }
}

// MARK: - Preview

#Preview("Featured Guide Card") {
    VStack {
        ABFeaturedGuideCard(
            title: "The First 7 Days Checklist",
            description: "Everything you need to do in your first week in Australia — from getting a phone number to opening a bank account."
        )
        .padding()
    }
    .background(Color.abSurface)
}
