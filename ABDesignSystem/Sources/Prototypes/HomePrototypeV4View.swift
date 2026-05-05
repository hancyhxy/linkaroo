import SwiftUI

// MARK: - HomePrototypeV4View
//
// EXPERIMENT (V4): structural calibration of §2 Home, completing the
// V4 page-set snapshot. Carries over V3's spec-derived structure and
// adds visual continuity with the rest of V4 (header background now
// inherits page surface via the ABHeader fix).
//
// V4 vs V3 — what changed since the V3 run:
//   • ABHeader.pageTitle / .chat backgrounds now inherit `Color.abSurface`
//     (was `Color.abSurfaceCard` solid white) — affects Home only via
//     the brand variant which still uses frosted glass; documenting
//     here for cross-page continuity.
//   • spec.md §3-§8 are now filled, but §2 spec is unchanged from V3.
//     This file is essentially a V3 recompilation against the calibrated
//     §0.4 vocabulary; behavior identical, name normalized to V4.
//
// What I read to write this file:
//   ✅ docs/spec.md §2 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0.4 (calibrated vocabulary)
//   ✅ docs/design.md
//   ✅ docs/struct.md §2 §6 (ABServiceCategoryType, ABGuide, ABContentTag)
//   ✅ docs/mockups/homepage.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABLayout / ABElevation
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift + ABMockData.guides
//
// What I deliberately did NOT read:
//   ❌ Pages/HomeView.swift (v1)
//   ❌ Prototypes/HomePrototypeView.swift (V1, cheating)
//   ❌ Prototypes/HomePrototypeV2View.swift (V2)
//   ❌ Prototypes/HomePrototypeV3View.swift (V3 — would be near-copy)
//   ❌ Component bodies past the init signature
//
// SPEC GAP markers carried over from V3 (still unresolved):
//
//   [GAP-A] §2 Layout-5 recommendation card — 3 nested text roles
//     (title / description / read-time) without resolution rules.
//     Self-picking abTitleSm / abBodySm / abCaption.
//
//   [GAP-B] §2 Featured Guide selection rule [open §11].
//
//   [GAP-C] tagStyle helper — same pattern. Local mirror.
//
//   [GAP-D] mockup homepage.html hero shows a Sydney Opera House image
//     under a dark overlay; spec §2 calls for `dark hero panel` using
//     `abPrimaryGradientEditorial` (gradient, no image). Honoring spec
//     because the prototype focuses on structural calibration, not
//     image asset wiring.
//

struct HomePrototypeV4View: View {

    // MARK: Parameters (spec §2 Feature.Parameters)
    @State private var searchText: String = ""
    @State private var selectedTab: ABTab = .home

    private var featuredGuide: ABGuide { ABMockData.guides[0] }
    private var recommendations: [ABGuide] { Array(ABMockData.guides.dropFirst()) }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Brand header (frosted glass, kept untouched)
                ABHeader(variant: .brand)

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s8) {
                        searchHero               // Layout 2
                        servicesGrid             // Layout 3
                        featuredSection          // Layout 4
                        recommendationsSection   // Layout 5
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            // Layout 6 — Bottom tab bar overlay (§2.A5)
            ABTabBar(selectedTab: $selectedTab)
        }
    }

    // MARK: Layout 2 — Search hero · dark hero panel (§2.A1)
    private var searchHero: some View {
        VStack(alignment: .center, spacing: ABSpacing.s4) {
            Text("G'day, Welcome Home.")
                .font(.abBrand)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            ABSearchBar(text: $searchText, variant: .hero, onSubmit: {
                // §2.A1 [open §11]
            })
        }
        .padding(.vertical, ABSpacing.s8)
        .padding(.horizontal, ABSpacing.s5)
        .frame(maxWidth: .infinity)
        .background(LinearGradient.abPrimaryGradientEditorial)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xxl))
    }

    // MARK: Layout 3 — Services grid (§2.A2)
    private var servicesGrid: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Essential Services", level: .major)

            ABServiceIconGrid(
                items: ABServiceCategoryType.allCases.map { type in
                    ABServiceItem(id: type.rawValue, label: type.rawValue, icon: type.icon)
                },
                onTap: { _ in
                    // §2.A2 [open §11]
                }
            )
        }
    }

    // MARK: Layout 4 — Featured section (§2.A3)
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Featured for You", level: .major)

            ABFeaturedGuideCard(
                title: featuredGuide.title,
                description: featuredGuide.description,
                onTap: {
                    // §2.A3 [open §11]
                }
            )
        }
    }

    // MARK: Layout 5 — Recommendations (§2.A4)
    //
    // [GAP-A] 3 nested text roles, self-picking tokens.
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Recommend for You", level: .major)

            VStack(spacing: ABSpacing.s3) {
                ForEach(recommendations) { guide in
                    Button {
                        // §2.A4 [open §11]
                    } label: {
                        recommendationCard(guide)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func recommendationCard(_ guide: ABGuide) -> some View {
        ABCard(variant: .standard) {
            VStack(alignment: .leading, spacing: ABSpacing.s2) {
                if let firstTag = guide.tags.first {
                    ABTag(text: firstTag.text,
                          style: tagStyle(for: firstTag.type),
                          size: .small)
                }

                Text(guide.title)
                    .font(.abTitleSm)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.abOnSurface)

                Text(guide.description)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(2)

                Text(guide.readTimeString)
                    .font(.abCaption)
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }
        }
    }

    // MARK: - [GAP-C] Local tagStyle helper
    private func tagStyle(for type: ABContentTagType) -> ABTagStyle {
        switch type {
        case .contextMatch: return .contextMatch
        case .verified:     return .verified
        case .newContent:   return .new
        case .warning:      return .warning
        case .error:        return .error
        case .gold:         return .gold
        case .topAdvice:    return .topAdvice
        case .category:     return .contextMatch
        }
    }
}

#Preview("HomePrototypeV4") {
    HomePrototypeV4View()
}
