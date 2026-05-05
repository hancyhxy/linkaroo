import SwiftUI

// MARK: - QAListView
//
// §4 Q&A List — see docs/spec.md §4.
// Reddit-style Q&A list with category filter + CTA banner.

public struct QAListView: View {
    public let category: ABServiceCategoryType?
    public let onSelectPost: (ABQAPost) -> Void
    public let onAskQuestion: () -> Void
    public let onBack: () -> Void

    public init(
        category: ABServiceCategoryType? = nil,
        onSelectPost: @escaping (ABQAPost) -> Void = { _ in },
        onAskQuestion: @escaping () -> Void = {},
        onBack: @escaping () -> Void = {}
    ) {
        self.category = category
        self.onSelectPost = onSelectPost
        self.onAskQuestion = onAskQuestion
        self.onBack = onBack
    }

    // MARK: Parameters (spec §4)
    @State private var selectedCategoryId: String = "all"

    private var categories: [ABCategoryTabItem] {
        [
            ABCategoryTabItem(id: "all", label: "All", icon: "square.grid.2x2"),
            ABCategoryTabItem(id: "renting", label: "Renting", icon: "house"),
            ABCategoryTabItem(id: "subletting", label: "Subletting"),
            ABCategoryTabItem(id: "utilities", label: "Utilities"),
            ABCategoryTabItem(id: "visa", label: "Visa", icon: "doc.text"),
        ]
    }

    private var filteredPosts: [ABQAPost] {
        if let category {
            let filtered = ABMockData.qaPosts.filter { $0.category == category }
            return filtered.isEmpty ? ABMockData.qaPosts : filtered
        }
        return ABMockData.qaPosts
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
                            onAskQuestion()
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
                                    onSelectPost(post)
                                }
                            )
                            .padding(.horizontal, ABLayout.pagePadding)
                        }
                    }
                }
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }

            ABBackBar(title: titleForCategory, onBack: onBack)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var titleForCategory: String {
        if let category {
            return "\(category.rawValue) Q&A"
        }
        return "Q&A & Guides"
    }
}

#Preview("Q&A List") {
    QAListView()
}
