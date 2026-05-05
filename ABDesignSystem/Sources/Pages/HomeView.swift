import SwiftUI

// MARK: - HomeView
//
// §2 Home — see docs/spec.md §2.
// Profile-driven push hub: search + 10 services + Featured Guide + recommendations.

public struct HomeView: View {
    public let onSelectCategory: (ABServiceCategoryType) -> Void
    public let onSelectFeaturedGuide: (ABGuide) -> Void
    public let onSelectGuide: (ABGuide) -> Void

    public init(
        onSelectCategory: @escaping (ABServiceCategoryType) -> Void = { _ in },
        onSelectFeaturedGuide: @escaping (ABGuide) -> Void = { _ in },
        onSelectGuide: @escaping (ABGuide) -> Void = { _ in }
    ) {
        self.onSelectCategory = onSelectCategory
        self.onSelectFeaturedGuide = onSelectFeaturedGuide
        self.onSelectGuide = onSelectGuide
    }

    // MARK: Parameters (spec §2)
    @State private var searchText: String = ""

    private var featuredGuide: ABGuide { ABMockData.guides[0] }
    private var recommendations: [ABGuide] { Array(ABMockData.guides.dropFirst()) }

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s8) {
                    searchHero
                    servicesGrid
                    featuredSection
                    recommendationsSection
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ABHeader(variant: .brand)
            }
        }
    }

    // MARK: §2.A1 — Search hero
    private var searchHero: some View {
        VStack(alignment: .center, spacing: ABSpacing.s4) {
            Text("G'day, Welcome Home.")
                .font(.abBrand)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            ABSearchBar(text: $searchText, variant: .hero, onSubmit: {
                // §2.A1 search submit (kept local for now)
            })
        }
        .padding(.vertical, ABSpacing.s8)
        .padding(.horizontal, ABSpacing.s5)
        .frame(maxWidth: .infinity)
        .background(LinearGradient.abPrimaryGradientEditorial)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xxl))
    }

    // MARK: §2.A2 — Services grid
    private var servicesGrid: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Essential Services", level: .major)

            ABServiceIconGrid(
                items: ABServiceCategoryType.allCases.map { type in
                    ABServiceItem(id: type.rawValue, label: type.rawValue, icon: type.icon)
                },
                onTap: { item in
                    if let category = ABServiceCategoryType(rawValue: item.id) {
                        onSelectCategory(category)
                    }
                }
            )
        }
    }

    // MARK: §2.A3 — Featured
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Featured for You", level: .major)

            ABFeaturedGuideCard(
                title: featuredGuide.title,
                description: featuredGuide.description,
                onTap: {
                    onSelectFeaturedGuide(featuredGuide)
                }
            )
        }
    }

    // MARK: §2.A4 — Recommendations
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Recommend for You", level: .major)

            VStack(spacing: ABSpacing.s3) {
                ForEach(recommendations) { guide in
                    Button {
                        onSelectGuide(guide)
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
}

// MARK: - Helpers (shared across Pages)

func tagStyle(for type: ABContentTagType) -> ABTagStyle {
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

#Preview("Home") {
    HomeView()
}
