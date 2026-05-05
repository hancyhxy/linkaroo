import SwiftUI

// MARK: - HomePrototypeV2View
//
// EXPERIMENT: spec-driven re-derivation of §2 Home.
//
// What I read to write this file:
//   ✅ docs/spec.md §2 (Overview / Parameters / Actions / Layout)
//   ✅ docs/design.md
//   ✅ docs/struct.md (ABServiceCategoryType, ABGuide)
//   ✅ docs/mockups/homepage.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift (relevant entities) + ABMockData.guides
//
// What I deliberately did NOT read:
//   ❌ Pages/HomeView.swift (the v1 implementation)
//   ❌ Prototypes/HomePrototypeView.swift (earlier cheating prototype)
//
// Mockup divergence flags (real copy → v1 SwiftUI):
//   "G'day, Welcome Home."       (mockup, used here)  vs "Hi, Amara"  (v1)
//   "Recommend for you"          (mockup, used here)  vs "Recommended for you"
//   No subtitle paragraph in mockup; spec says "supporting paragraph"
//   under the greeting — kept a minimal one as placeholder. Strict
//   mockup interpretation would drop it, but spec dominates here.
//

struct HomePrototypeV2View: View {

    // MARK: Parameters (spec §2 Feature.Parameters)
    @State private var searchText: String = ""
    @State private var selectedTab: ABTab = .home

    // featuredGuide / recommendations resolution per spec §2 default
    private var featuredGuide: ABGuide { ABMockData.guides[0] }
    private var recommendations: [ABGuide] { Array(ABMockData.guides.dropFirst()) }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Brand header (brand variant)
                ABHeader(variant: .brand)

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s8) {
                        searchHero             // Layout 2
                        servicesGrid           // Layout 3
                        featuredSection        // Layout 4
                        recommendationsSection // Layout 5
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s4)
                    // Reserve room for tab bar overlay (Layout 6) so the
                    // last recommendation isn't covered.
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            // Layout 6 — Bottom tab bar overlay (§2.A5)
            ABTabBar(selectedTab: $selectedTab)
        }
    }

    // MARK: Layout 2 — Search hero (§2.A1)
    //
    // Spec: "hero block (greeting line + supporting paragraph + search
    // input below)". Mockup shows the hero as a dark gradient panel
    // with white centered greeting and a frosted search underneath.
    // Implementation choice: use `abPrimaryGradientEditorial` from
    // design.md §2 ("Glass & Gradient Rule") as the hero background;
    // search bar uses ABSearchBar(variant: .hero) per its enum case
    // explicitly named for "frosted glass overlay on hero images".
    private var searchHero: some View {
        VStack(alignment: .center, spacing: ABSpacing.s4) {
            Text("G'day, Welcome Home.")
                .font(.abBrand)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            ABSearchBar(text: $searchText, variant: .hero)
                // §2.A1 — submit target [open §11]
        }
        .padding(.vertical, ABSpacing.s8)
        .padding(.horizontal, ABSpacing.s5)
        .frame(maxWidth: .infinity)
        .background(LinearGradient.abPrimaryGradientEditorial)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xxl))
    }

    // MARK: Layout 3 — Services grid · 10 categories (§2.A2)
    //
    // Spec: "horizontal-flowing icon grid (10 items, label below each
    // icon)". ABServiceIconGrid takes [ABServiceItem] and an optional
    // onTap. Build the 10 items from ABServiceCategoryType.allCases —
    // struct.md §2 establishes that the type's rawValue is the display
    // name and `.icon` returns an SF Symbol name.
    private var servicesGrid: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Essential Services", level: .major)

            ABServiceIconGrid(
                items: ABServiceCategoryType.allCases.map { type in
                    ABServiceItem(id: type.rawValue, label: type.rawValue, icon: type.icon)
                },
                onTap: { _ in
                    // §2.A2 — navigation target [open §11]
                }
            )
        }
    }

    // MARK: Layout 4 — Featured section · hero card (§2.A3)
    //
    // Spec: "hero card (title + description)". ABFeaturedGuideCard takes
    // title + description and a tap closure. Mockup shows it as a dark
    // editorial card with a "FEATURED GUIDE" gold tag and a "Start
    // Reading" CTA — the component renders both by default per its init
    // signature defaults.
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Featured for You", level: .major)

            ABFeaturedGuideCard(
                title: featuredGuide.title,
                description: featuredGuide.description,
                onTap: {
                    // §2.A3 — navigation target [open §11]
                }
            )
        }
    }

    // MARK: Layout 5 — Recommendations · vertical list of content cards (§2.A4)
    //
    // Spec: "vertical list of content cards; each card contains
    // tag chip + title + description + read-time caption".
    // ABCard(variant: .standard) provides the surface; we compose the
    // four-element interior ourselves following the spec's order.
    // Tag style mapping: spec doesn't dictate; design.md §5 says tags
    // signal credibility, but on a recommendation card the first tag
    // typically encodes context — pick `.contextMatch` style for any
    // first tag the guide carries. (Spec gap: tag → style mapping
    // outside the QA Detail page is unspecified.)
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Recommend for You", level: .major)

            VStack(spacing: ABSpacing.s3) {
                ForEach(recommendations) { guide in
                    Button {
                        // §2.A4 — navigation target [open §11]
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
                    ABTag(text: firstTag.text, style: .contextMatch, size: .small)
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

    // Section headings now use ABSectionTitle(level: .major) — added
    // to Components/ during the spec calibration round.
}

#Preview("HomePrototypeV2") {
    HomePrototypeV2View()
}
