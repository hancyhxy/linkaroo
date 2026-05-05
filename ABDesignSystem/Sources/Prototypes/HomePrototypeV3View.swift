import SwiftUI

// MARK: - HomePrototypeV3View
//
// EXPERIMENT (V3): second spec-driven re-derivation of §2 Home.
//
// V3 vs V2 — what changed in the *spec* between the two runs:
//   • spec.md §2 Layout-2 specifies "dark hero panel" with
//     `abPrimaryGradientEditorial`, brand-font centered greeting,
//     frosted search input.
//   • spec.md §2 Layout-3/4/5 — section title now level: major.
//   • spec.md §2 Parameters.services — derived from
//     ABServiceCategoryType.allCases (not hardcoded ABServiceItem.defaults).
//   • spec.md §2 Layout-5 — recommendation card: "tag chip (first tag of
//     ABGuide.tags, style mapped per design.md) + title + description +
//     read-time caption".
//   • Components/ABSectionTitle.swift exists.
//
// What I read to write this file:
//   ✅ docs/spec.md §2 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0 (control vocabulary, copy authority)
//   ✅ docs/design.md
//   ✅ docs/struct.md (ABServiceCategoryType, ABGuide, ABContentTag)
//   ✅ docs/mockups/homepage.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABElevation tokens
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift (relevant entities) + ABMockData.guides
//
// What I deliberately did NOT read:
//   ❌ Pages/HomeView.swift                              (v1 implementation)
//   ❌ Prototypes/HomePrototypeView.swift                (V1, cheating)
//   ❌ Prototypes/HomePrototypeV2View.swift              (V2, prior spec run)
//   ❌ Component bodies past the init signature (~40 lines each)
//
// Per spec §0.5b Copy authority: copy taken from
// docs/mockups/homepage.html.
//
// SPEC GAP TEXT markers — Home is the bigger gap surface because each
// recommendation card has 3 nested text roles (title, description,
// read-time) none of which spec gives a resolution rule for.
//

struct HomePrototypeV3View: View {

    // MARK: Parameters (spec §2 Feature.Parameters)
    @State private var searchText: String = ""
    @State private var selectedTab: ABTab = .home

    private var featuredGuide: ABGuide { ABMockData.guides[0] }
    private var recommendations: [ABGuide] { Array(ABMockData.guides.dropFirst()) }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Brand header
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
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            // Layout 6 — Bottom tab bar overlay (§2.A5)
            ABTabBar(selectedTab: $selectedTab)
        }
    }

    // MARK: Layout 2 — Search hero · dark hero panel (§2.A1)
    //
    // Spec: "dark hero panel — centered brand-font greeting on
    // `abPrimaryGradientEditorial`; frosted search input below".
    // This is one of the calibrated bullets — every concrete element
    // (gradient token, brand font, frosted variant, centered) is
    // spec-directed. No SPEC GAP TEXT here because the spec is now
    // explicit enough to drive this region.
    private var searchHero: some View {
        VStack(alignment: .center, spacing: ABSpacing.s4) {
            Text("G'day, Welcome Home.")
                .font(.abBrand)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            ABSearchBar(text: $searchText, variant: .hero)
            // §2.A1 — submit target [open §11]
            //
            // SPEC GAP TEXT[searchPlaceholder]:
            // ABSearchBar has a default placeholder "Search services,
            // guides, Q&A...". Mockup shows the same string. Spec doesn't
            // say whether to override or accept the default — accepting.
        }
        .padding(.vertical, ABSpacing.s8)
        .padding(.horizontal, ABSpacing.s5)
        .frame(maxWidth: .infinity)
        .background(LinearGradient.abPrimaryGradientEditorial)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xxl))
    }

    // MARK: Layout 3 — Services grid · 10 categories (§2.A2)
    //
    // Spec: "section title (level: major) + horizontal-flowing icon
    // grid (10 items derived from ABServiceCategoryType.allCases;
    // label below each icon)".
    // Cleanly resolved — no SPEC GAP TEXT.
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
    // Spec: "section title (level: major) + hero card (title +
    // description)".
    // ABFeaturedGuideCard's `title` and `description` map directly,
    // and the component owns its interior typography. Same pattern as
    // ABTipCard in §1 — spec uses role names "title" and "description"
    // with no resolution rule, but here the component absorbs that
    // decision so the gap doesn't surface as a self-pick.
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
    // tag chip (first tag of ABGuide.tags, style mapped per design.md) +
    // title + description + read-time caption".
    //
    // *** This is the heaviest SPEC GAP TEXT region in V3. ***
    // The card has 3 distinct text roles ("title", "description",
    // "read-time caption") and ABCard(variant: .standard) does NOT bottle
    // any interior typography (it's a container, not a content card).
    // So *every* text inside has to pick a font/color token from
    // design.md without spec direction.
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
                    // Spec: "first tag of ABGuide.tags, style mapped per
                    // design.md". design.md doesn't actually define a
                    // tag-style mapping for non-QA contexts. Self-pick
                    // `.contextMatch` because most recommendation tags
                    // signal context match in mockup.
                    //
                    // SPEC GAP[tagStyleMapping]:
                    // No design.md table maps ABContentTagType →
                    // ABTagStyle outside QA Detail.
                    ABTag(text: firstTag.text, style: .contextMatch, size: .small)
                }

                // SPEC GAP TEXT[cardTitle]:
                // spec says "title" inside content card — no role/token.
                // Picking `abTitleSm` (14pt Inter Bold) because it's the
                // smallest title-class token, matching mockup's
                // `text-sm font-bold` for recommendation card titles.
                Text(guide.title)
                    .font(.abTitleSm)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.abOnSurface)

                // SPEC GAP TEXT[cardBody]:
                // spec says "description" — no role/token. Picking
                // `abBodySm` (14pt Inter Regular) for the body line in
                // a compact card; mockup shows `text-xs` which would be
                // ~12pt → there is no `abBodyXs`, closest is
                // `abLabelMd` (12pt SemiBold) or `abBodySm` (14pt). Going
                // with `abBodySm` because Regular weight matters more
                // than precise size for body text.
                Text(guide.description)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(2)

                // SPEC GAP TEXT[meta]:
                // spec says "read-time caption" — no role/token. Picking
                // `abCaption` (10pt Inter Regular) because the token name
                // matches the spec word "caption".
                Text(guide.readTimeString)
                    .font(.abCaption)
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }
        }
    }
}

#Preview("HomePrototypeV3") {
    HomePrototypeV3View()
}
