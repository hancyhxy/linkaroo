import SwiftUI

// MARK: - ABBackBar
//
// Back-only sticky bar — semi-transparent overlay holding nothing but a
// back chevron. Use when the page wants its title to live in the
// content flow as a `ABPageHero` rather than crammed into a 64pt
// header bar.
//
// Pairs with `ABPageHero` for editorial / onboarding / multi-step
// flows. Use `ABHeader(variant: .pageTitle)` instead when the page is
// a compact detail view (Q&A Detail, Volunteer Match) that benefits
// from back + title sharing one row.

struct ABBackBar: View {
    var onBack: (() -> Void)? = nil

    /// Slimmer than ABHeader so the page hero below feels editorial.
    /// Mockup `personalization.html` uses py-3 ≈ 56pt total.
    private let height: CGFloat = ABLayout.headerHeight - 8

    var body: some View {
        HStack(spacing: 0) {
            Button(action: { onBack?() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.abOnSurface)
                    .frame(width: 32, height: 32)
            }
            Spacer()
        }
        .padding(.horizontal, ABSpacing.s4)
        .frame(height: height)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.abSurface
                .opacity(0.85)
                .background(.ultraThinMaterial)
        )
    }
}

#Preview("ABBackBar") {
    VStack(spacing: 0) {
        ABBackBar(onBack: {})

        ScrollView {
            VStack(alignment: .leading, spacing: ABSpacing.s4) {
                ForEach(0..<10) { i in
                    Text("Content row \(i)")
                        .font(.abBodyMd)
                        .foregroundStyle(Color.abOnSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.abSurfaceCard)
                        .clipShape(RoundedRectangle(cornerRadius: ABRadius.md))
                }
            }
            .padding(ABSpacing.s5)
        }
    }
    .background(Color.abSurface)
}
