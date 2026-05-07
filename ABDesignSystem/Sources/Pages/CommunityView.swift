import SwiftUI

// MARK: - CommunityView
//
// §3 Community — see docs/spec.md §3.
// Single-page Community hub: a horizontal "People You Can Help" carousel
// at the top + a vertical "Questions You Can Answer" list below.
// No internal segmented control — the previous Discussions / Messages
// split was folded into the bottom tab bar (Messages is its own tab now).

public struct CommunityView: View {
    public let onSelectPost: (ABQAPost) -> Void
    public let onSelectHelpRequest: (ABHelpRequest) -> Void

    public init(
        onSelectPost: @escaping (ABQAPost) -> Void = { _ in },
        onSelectHelpRequest: @escaping (ABHelpRequest) -> Void = { _ in }
    ) {
        self.onSelectPost = onSelectPost
        self.onSelectHelpRequest = onSelectHelpRequest
    }

    // MARK: Parameters (spec §3)
    private var qaPosts: [ABQAPost] { ABMockData.qaPosts }
    private var helpRequests: [ABHelpRequest] { ABMockData.helpRequests }

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s6) {
                    peopleYouCanHelpSection
                    questionsYouCanAnswerSection
                }
                .padding(.top, ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Community", showBack: false))
            }
        }
    }

    // MARK: People You Can Help — horizontal carousel
    private var peopleYouCanHelpSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("People You Can Help", level: .section)
                .padding(.horizontal, ABLayout.pagePadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ABSpacing.s3) {
                    ForEach(helpRequests) { req in
                        ABHelpCard(
                            data: ABHelpCardData(
                                name: req.requester.displayName,
                                subtitle: req.subtitle,
                                avatarURL: req.requester.avatarURL,
                                avatar: req.requester.avatarContent,
                                tags: req.tags.map { (text: $0.text, style: tagStyle(for: $0.type)) },
                                quote: req.questionText,
                                achievementText: req.achievement?.text,
                                achievementIcon: req.achievement?.icon ?? "medal",
                                achievementColor: req.achievement?.variant == .cool
                                    ? Color.abPrimary
                                    : Color.abAccentGoldDark,
                                achievementBg: req.achievement?.variant == .cool
                                    ? Color.abAccentSky
                                    : Color.abAccentButter
                            ),
                            onCTA: {
                                onSelectHelpRequest(req)
                            }
                        )
                        .frame(width: 280)
                    }
                }
                .padding(.horizontal, ABLayout.pagePadding)
            }
        }
    }

    // MARK: Questions You Can Answer — vertical list
    private var questionsYouCanAnswerSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Questions You Can Answer", level: .section)
                .padding(.horizontal, ABLayout.pagePadding)

            VStack(spacing: ABSpacing.s3) {
                ForEach(qaPosts) { post in
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
    }
}

#Preview("Community") {
    CommunityView()
}
