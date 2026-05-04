import SwiftUI

// MARK: - ABCTABanner

/// Gradient banner with title + body + inverted CTA. Used at the top of QA list etc.
struct ABCTABanner: View {
    let title: String
    let bodyText: String
    let ctaTitle: String
    var icon: String = "plus"
    var onCTA: (() -> Void)? = nil

    var body: some View {
        ABCard(variant: .ctaBanner) {
            VStack(spacing: ABSpacing.s3) {
                Text(title)
                    .font(.abTitleLg)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(bodyText)
                    .font(.abBodySm)
                    .foregroundStyle(Color.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)

                ABButton(
                    title: ctaTitle,
                    variant: .inverted,
                    size: .medium,
                    icon: icon
                ) {
                    onCTA?()
                }
                .padding(.top, ABSpacing.s1)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#Preview("CTA Banner") {
    VStack {
        ABCTABanner(
            title: "Got a question?",
            bodyText: "Our community of locals and seniors are here to help.",
            ctaTitle: "Ask a Question"
        )
        .padding()
    }
    .background(Color.abSurface)
}
