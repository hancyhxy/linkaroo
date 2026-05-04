import SwiftUI

// MARK: - HomeView (homepage.html)
//
// Construct: the contextual home hub. Shows a search hero, the 10 service categories,
// a Featured Guide tuned to the user's "first 30 days" context, and a "Recommended for You"
// list filtered by the onboarding profile (`ABUser`, `ABServiceCategory`, `ABGuide`).

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedTab: ABTab = .home

    var featuredGuide: ABGuide { ABMockData.guides[0] }
    var recommendations: [ABGuide] { Array(ABMockData.guides.dropFirst()) }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .brand)

                ScrollView {
                    VStack(spacing: ABSpacing.s6) {
                        searchHero
                        servicesGrid
                        featuredSection
                        recommendationsSection
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            ABTabBar(selectedTab: $selectedTab)
        }
    }

    // MARK: - Search hero
    private var searchHero: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            Text("Hi, Amara")
                .font(.abDisplayMd)
                .foregroundStyle(Color.abOnSurface)

            Text("What can we help you settle today?")
                .font(.abBodyMd)
                .foregroundStyle(Color.abOnSurfaceVariant)

            ABSearchBar(text: $searchText, placeholder: "Search services, guides, Q&A…")
                .padding(.top, ABSpacing.s2)
        }
    }

    // MARK: - Services grid
    private var servicesGrid: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Essential services")
            ABServiceIconGrid(items: ABServiceItem.defaults)
        }
    }

    // MARK: - Featured Guide
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Featured for newcomers")

            ABFeaturedGuideCard(
                title: featuredGuide.title,
                description: featuredGuide.description
            )
        }
    }

    // MARK: - Recommendations
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Recommended for you")

            VStack(spacing: ABSpacing.s3) {
                ForEach(recommendations) { guide in
                    recommendationCard(guide)
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
                        style: tagStyle(for: firstTag.type),
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

    // MARK: - Section Label
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.abLabelLg)
            .fontWeight(.semibold)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .textCase(.uppercase)
            .tracking(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Tag Style Helper

func tagStyle(for type: ABContentTagType) -> ABTagStyle {
    switch type {
    case .contextMatch: return .contextMatch
    case .verified: return .verified
    case .newContent: return .new
    case .warning: return .warning
    case .error: return .error
    case .gold: return .gold
    case .topAdvice: return .topAdvice
    case .category: return .skillBlue
    }
}

// MARK: - Preview

#Preview("Home") {
    HomeView()
}
