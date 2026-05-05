import SwiftUI

// MARK: - QAListView
//
// §4 Q&A List — see docs/spec.md §4.
// Reddit-style Q&A list with category filter + CTA banner.

public struct QAListView: View {
    public init() {}


    // MARK: Parameters (spec §4)
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

    // §4 filter rule [open §11] — show all until specified
    private var filteredPosts: [ABQAPost] {
        ABMockData.qaPosts
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s4) {
                    ABCTABanner(
                        title: "Got a question?",
                        bodyText: "Our community of locals and seniors are here to help.",
                        ctaTitle: "Ask a Question",
                        onCTA: {
                            // §4.A1 [open §11]
                        }
                    )
                    .padding(.horizontal, ABLayout.pagePadding)

                    ABHorizontalCategoryTabs(
                        items: categories,
                        selectedId: $selectedCategoryId
                    )

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

            ABBackBar(title: "Q&A & Guides", onBack: {
                // §4 back navigation [open §11]
            })

            // §10.1: tab bar visibility on §4 [open §11] — showing for now
            VStack {
                Spacer()
                ABTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview("Q&A List") {
    QAListView()
}
