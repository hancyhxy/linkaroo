import SwiftUI

// MARK: - QAListView (qa.html)
//
// Construct: Reddit-style Q&A list filtered by category. CTA banner at the top
// invites the user to ask a new question. Each row uses ABQAPostCard with the
// vote column, tags and Top Answer excerpt.

struct QAListView: View {
    @State private var selectedCategoryId: String = "all"
    @State private var selectedTab: ABTab = .community

    var categories: [ABCategoryTabItem] {
        [
            ABCategoryTabItem(id: "all", label: "All", icon: "square.grid.2x2"),
            ABCategoryTabItem(id: "renting", label: "Renting", icon: "house"),
            ABCategoryTabItem(id: "subletting", label: "Subletting"),
            ABCategoryTabItem(id: "utilities", label: "Utilities"),
            ABCategoryTabItem(id: "visa", label: "Visa", icon: "doc.text"),
        ]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Q&A & Guides"))

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s4) {
                        ABCTABanner(
                            title: "Got a question?",
                            bodyText: "Our community of locals and seniors are here to help.",
                            ctaTitle: "Ask a Question"
                        )
                        .padding(.horizontal, ABLayout.pagePadding)

                        ABHorizontalCategoryTabs(
                            items: categories,
                            selectedId: $selectedCategoryId
                        )

                        VStack(spacing: ABSpacing.s3) {
                            ForEach(ABMockData.qaPosts) { post in
                                ABQAPostCard(post: post.toCardData())
                                    .padding(.horizontal, ABLayout.pagePadding)
                            }
                        }
                    }
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            ABTabBar(selectedTab: $selectedTab)
        }
    }
}

// MARK: - Preview

#Preview("Q&A List") {
    QAListView()
}
