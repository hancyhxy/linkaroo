import SwiftUI

// MARK: - QAListPrototypeV4View
//
// EXPERIMENT (V4): spec-driven re-derivation of §4 Q&A List.
// First spec-driven prototype for this page.
//
// What I read to write this file:
//   ✅ docs/spec.md §4 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0.4 (`CTA banner`, `horizontal category tabs`)
//   ✅ docs/design.md
//   ✅ docs/struct.md §2 (ABQAPost, ABContentTag*, ABServiceCategoryType)
//   ✅ docs/mockups/qa.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABLayout tokens
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift + ABMockData.qaPosts
//
// What I deliberately did NOT read:
//   ❌ Pages/QAListView.swift (v1)
//   ❌ Component bodies past the init signature
//
// SPEC GAP markers found this round:
//
//   [GAP-20] mockup qa.html title is "Housing" not "Q&A & Guides"
//     (the mockup is a category-specific scoped view; spec models
//     this as a generic "Q&A & Guides" page with a category filter
//     row). Resolution: spec is more general (covers all categories),
//     mockup shows a single-category snapshot. Honoring spec for
//     header title; honoring mockup for category-tab content
//     (Renting, Subletting, Utilities, Flatmates).
//
//   [GAP-21] mockup category tabs: Renting / Subletting / Utilities /
//     Flatmates (4 items, no "All" or "Visa"). spec/v1 uses
//     All / Renting / Subletting / Utilities / Visa (5 items).
//     Honoring spec category set because mockup is category-scoped
//     (the page is *already* under "Housing" so a Visa tab would be
//     out of scope). Spec's category set is valid in the generic
//     model.
//
//   [GAP-22] mockup CTA banner sits *between* the category tabs and
//     the post list, not above the tabs. spec puts it above the tabs.
//     Honoring spec ordering — it makes the CTA more prominent on
//     first scroll, aligning with §4 Overview "framing the list as a
//     participation surface".
//
//   [GAP-23] tagStyle helper — same pattern. Local mirror.
//

struct QAListPrototypeV4View: View {

    // MARK: Parameters (spec §4 Feature.Parameters)
    @State private var selectedCategoryId: String = "all"
    @State private var selectedTab: ABTab = .community

    private var categories: [ABCategoryTabItem] {
        [
            ABCategoryTabItem(id: "all", label: "All", icon: "square.grid.2x2"),
            ABCategoryTabItem(id: "renting", label: "Renting", icon: "house"),
            ABCategoryTabItem(id: "subletting", label: "Subletting"),
            ABCategoryTabItem(id: "utilities", label: "Utilities"),
            ABCategoryTabItem(id: "visa", label: "Visa", icon: "doc.text"),
        ]
    }

    // [GAP-21] filter rule [open §11] — until resolved, show all.
    private var filteredPosts: [ABQAPost] {
        ABMockData.qaPosts
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s4) {
                    // Layout 2 — CTA banner (§4.A1)
                    ABCTABanner(
                        title: "Got a question?",
                        bodyText: "Our community of locals and seniors are here to help.",
                        ctaTitle: "Ask a Question",
                        onCTA: {
                            // §4.A1 — author flow [open §11]
                        }
                    )
                    .padding(.horizontal, ABLayout.pagePadding)

                    // Layout 3 — Horizontal category tabs (§4.A2)
                    ABHorizontalCategoryTabs(
                        items: categories,
                        selectedId: $selectedCategoryId
                    )

                    // Layout 4 — Posts list (§4.A3)
                    VStack(spacing: ABSpacing.s3) {
                        ForEach(filteredPosts) { post in
                            ABQAPostCard(
                                post: ABQAPostData(
                                    author: post.author.username,
                                    timeAgo: post.timeAgoString,
                                    title: post.title,
                                    preview: post.preview,
                                    tags: post.tags.map { (text: $0.text, style: tagStyle(for: $0.type)) },
                                    voteCount: post.voteCount,
                                    commentCount: post.commentCount,
                                    topAnswer: post.topAnswer?.excerpt
                                ),
                                onTap: {
                                    // §4.A3 — → §5 Q&A Detail [open §11]
                                }
                            )
                            .padding(.horizontal, ABLayout.pagePadding)
                        }
                    }
                }
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
            }

            // Layout 1 — Back bar overlay
            // Spec says "header bar (page-title variant, with back) —
            // title 'Q&A & Guides'". Picking ABBackBar with title
            // for V4 visual continuity (frosted slim bar).
            ABBackBar(title: "Q&A & Guides", onBack: {
                // §4 back navigation [open §11]
            })

            // Layout 5 — Bottom tab bar overlay (§4.A4)
            // Spec §10.1: visibility on §4 is [open §11]. Showing.
            VStack {
                Spacer()
                ABTabBar(selectedTab: $selectedTab)
            }
        }
    }

    // MARK: - [GAP-23] Local tagStyle helper
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

#Preview("QAListPrototypeV4") {
    QAListPrototypeV4View()
}
