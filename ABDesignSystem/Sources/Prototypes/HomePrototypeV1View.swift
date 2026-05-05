import SwiftUI

// MARK: - HomePrototypeView
//
// Throwaway sandbox reimplementation of docs/spec.md §2 Home alongside
// the existing Pages/HomeView. Lives in Sources/Prototypes/ so it
// shares the same module as design tokens and mock data.
//
//
// Spec coverage:
//   §2 Parameters  →  searchText / selectedTab / featuredGuide / recommendations
//   §2 Actions     →  §2.A1–§2.A5, in-line comments mark each
//   §2 Layout      →  6 numbered regions (header / hero / services /
//                     featured / recommendations / tab bar overlay)

struct HomePrototypeV1View: View {

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
                    VStack(spacing: ABSpacing.s6) {
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

    // MARK: Layout 2 — Search hero (§2.A1)
    private var searchHero: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            Text("Hi, Amara")
                .font(.abDisplayMd)
                .foregroundStyle(Color.abOnSurface)

            Text("What can we help you settle today?")
                .font(.abBodyMd)
                .foregroundStyle(Color.abOnSurfaceVariant)

            // §2.A1 — submit target [open §11]
            ABSearchBar(text: $searchText, placeholder: "Search services, guides, Q&A…")
                .padding(.top, ABSpacing.s2)
        }
    }

    // MARK: Layout 3 — Services grid · 10 categories (§2.A2)
    private var servicesGrid: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Essential services")
            ABServiceIconGrid(items: ABServiceItem.defaults)
            // §2.A2 — tap target [open §11]; ABServiceIconGrid v1
            // does not expose an onTap binding.
        }
    }

    // MARK: Layout 4 — Featured · hero card (§2.A3)
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Featured for newcomers")

            ABFeaturedGuideCard(
                title: featuredGuide.title,
                description: featuredGuide.description
            )
            // §2.A3 — tap target [open §11]
        }
    }

    // MARK: Layout 5 — Recommendations · vertical list (§2.A4)
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Recommended for you")

            VStack(spacing: ABSpacing.s3) {
                ForEach(recommendations) { guide in
                    recommendationCard(guide)
                    // §2.A4 — tap target [open §11]
                }
            }
        }
    }

    private func recommendationCard(_ guide: ABGuide) -> some View {
        ABCard(variant: .standard) {
            VStack(alignment: .leading, spacing: ABSpacing.s2) {
                if let firstTag = guide.tags.first {
                    ABTag(
                        text: firstTag.text,
                        style: tagStyleFromContentTag(firstTag.type),
                        size: .small
                    )
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

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.abLabelLg)
            .fontWeight(.semibold)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .textCase(.uppercase)
            .tracking(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Local tag-style mapper to keep this file self-contained. If the
    // canonical Pages/HomeView changes its mapping, mirror here.
    private func tagStyleFromContentTag(_ type: ABContentTagType) -> ABTagStyle {
        switch type {
        case .contextMatch: return .contextMatch
        case .verified:     return .verified
        case .newContent:   return .new
        case .warning:      return .warning
        case .error:        return .error
        case .gold:         return .gold
        case .topAdvice:    return .topAdvice
        case .category:     return .skillBlue
        }
    }
}

#Preview("HomePrototypeV1") {
    HomePrototypeV1View()
}
