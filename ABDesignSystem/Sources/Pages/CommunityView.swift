import SwiftUI

// MARK: - CommunityView (community.html)
//
// Construct: the community discussions hub. Two segments — "Discussions" (Q&A list)
// and "People you can help" (horizontal-scrolling help requests). Uses ABHelpRequest
// + ABQAPost from the Models layer.

enum CommunitySegment: String, CaseIterable, CustomStringConvertible {
    case discussions = "Discussions"
    case peopleYouCanHelp = "People to help"

    var description: String { rawValue }
}

struct CommunityView: View {
    @State private var segment: CommunitySegment = .discussions
    @State private var selectedTab: ABTab = .community

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Community", showBack: false))

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s5) {
                        ABSegmentedControl(options: CommunitySegment.allCases, selected: $segment)
                            .padding(.horizontal, ABLayout.pagePadding)

                        switch segment {
                        case .discussions:
                            discussionsContent
                        case .peopleYouCanHelp:
                            helpRequestsContent
                        }
                    }
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            ABTabBar(selectedTab: $selectedTab)
        }
    }

    // MARK: - Discussions content
    private var discussionsContent: some View {
        VStack(spacing: ABSpacing.s3) {
            ForEach(ABMockData.qaPosts) { post in
                ABQAPostCard(post: post.toCardData())
                    .padding(.horizontal, ABLayout.pagePadding)
            }
        }
    }

    // MARK: - Help-requests content
    private var helpRequestsContent: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s4) {
            Text("People you can help")
                .font(.abTitleMd)
                .foregroundStyle(Color.abOnSurface)
                .padding(.horizontal, ABLayout.pagePadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ABSpacing.s3) {
                    ForEach(ABMockData.helpRequests) { req in
                        ABHelpCard(data: req.toCardData())
                            .frame(width: ABLayout.cardHorizontal)
                    }
                }
                .padding(.horizontal, ABLayout.pagePadding)
            }
        }
    }
}

// MARK: - Adapters: Models → Component data

extension ABQAPost {
    func toCardData() -> ABQAPostData {
        ABQAPostData(
            author: author.username,
            timeAgo: timeAgoString,
            title: title,
            preview: preview,
            tags: tags.map { (text: $0.text, style: tagStyle(for: $0.type)) },
            voteCount: voteCount,
            commentCount: commentCount,
            topAnswer: topAnswer?.excerpt
        )
    }
}

extension ABHelpRequest {
    func toCardData() -> ABHelpCardData {
        ABHelpCardData(
            name: requester.displayName,
            subtitle: subtitle,
            avatarURL: requester.avatarURL,
            tags: tags.map { (text: $0.text, style: tagStyle(for: $0.type)) },
            quote: questionText,
            achievementText: achievement?.text,
            achievementIcon: achievement?.icon ?? "medal",
            achievementColor: achievement?.variant == .cool
                ? Color.abPrimary
                : Color.abAccentGoldDark,
            achievementBg: achievement?.variant == .cool
                ? Color.abAccentSky
                : Color.abAccentButter
        )
    }
}

// MARK: - Preview

#Preview("Community") {
    CommunityView()
}
