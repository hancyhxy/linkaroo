import SwiftUI

// MARK: - ABPageHero
//
// Editorial page hero living in the content flow — large headline +
// optional subtitle paragraph. Use as the first element inside the
// page's ScrollView, immediately under a `ABBackBar` overlay.
//
// Why a dedicated component:
// - Bottles the headline (`abHeadlineLg` 24pt PublicSans Black) and
//   subtitle (`abBodySm` 14pt Inter Regular muted) typography so spec
//   can write `page hero (headline + subtitle)` and downstream
//   prototypes don't pick tokens themselves (closes the V3 experiment's
//   SPEC GAP TEXT[heroSubtitle] gap).
// - Decouples page title from the back-bar — see Components/ABBackBar
//   for the rationale on why detail pages keep `ABHeader.pageTitle`
//   while editorial / onboarding pages use this pair.

public struct ABPageHero: View {
    public let headline: String
    public var subtitle: String? = nil

    public init(headline: String, subtitle: String? = nil) {
        self.headline = headline
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            Text(headline)
                .font(.abHeadlineLg)
                .foregroundStyle(Color.abOnSurface)
                .fixedSize(horizontal: false, vertical: true)

            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("ABPageHero — with subtitle") {
    ABPageHero(
        headline: "Let's personalize your journey",
        subtitle: "Help us tailor the best experience for you"
    )
    .padding(ABSpacing.s5)
    .background(Color.abSurface)
}

#Preview("ABPageHero — headline only") {
    ABPageHero(headline: "New Question")
        .padding(ABSpacing.s5)
        .background(Color.abSurface)
}
