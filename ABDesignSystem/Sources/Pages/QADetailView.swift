import SwiftUI

// MARK: - QADetailView
//
// §5 Q&A Detail — see docs/spec.md §5.
// Single thread + Top Answer + match-volunteer escalation (entry to §6 → §8 flow).

public struct QADetailView: View {

    // MARK: Parameters (spec §5)
    public let post: ABQAPost
    public let onMatchVolunteer: (ABQAPost) -> Void
    public let onBack: () -> Void

    public init(
        post: ABQAPost = ABMockData.qaPosts[0],
        onMatchVolunteer: @escaping (ABQAPost) -> Void = { _ in },
        onBack: @escaping () -> Void = {}
    ) {
        self.post = post
        self.onMatchVolunteer = onMatchVolunteer
        self.onBack = onBack
    }

    private var comments: [ABQAComment] {
        ABMockData.comments(for: post.id)
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s5) {
                    tagRow
                    titleAndMeta
                    bodyParagraph
                    if let answer = post.topAnswer {
                        topAnswerBlock(answer)
                    }
                    statsRow
                    commentsSection
                    matchCTASection
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }

            ABBackBar(title: "Q&A", onBack: onBack)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var tagRow: some View {
        HStack(spacing: ABSpacing.s2) {
            ForEach(post.tags) { tag in
                ABTag(text: tag.text, style: tagStyle(for: tag.type), size: .small)
            }
        }
    }

    private var titleAndMeta: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            Text(post.title)
                .font(.abHeadlineMd)
                .foregroundStyle(Color.abOnSurface)
                .lineSpacing(4)

            HStack(spacing: ABSpacing.s2) {
                Text("Posted by \(post.author.username)")
                    .font(.abCaption)
                    .foregroundStyle(Color.abOnSurfaceDisabled)
                Text("·")
                    .foregroundStyle(Color.abOnSurfaceDisabled)
                Text(post.timeAgoString)
                    .font(.abCaption)
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }
        }
    }

    private var bodyParagraph: some View {
        Text(post.fullContent.isEmpty ? post.preview : post.fullContent)
            .font(.abBodyMd)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .lineSpacing(5)
    }

    private func topAnswerBlock(_ answer: ABTopAnswer) -> some View {
        ABQuoteBlock(
            text: answer.excerpt,
            showHeader: true,
            headerText: answer.isVerified ? "Top Answer · Verified" : "Top Answer"
        )
    }

    private var statsRow: some View {
        HStack(spacing: ABSpacing.s5) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.up.circle.fill")
                Text("\(post.voteCount) votes")
            }
            HStack(spacing: 6) {
                Image(systemName: "bubble.left")
                Text("\(post.commentCount) comments")
            }
            Spacer()
        }
        .font(.abLabelMd)
        .foregroundStyle(Color.abOnSurfaceVariant)
    }

    // §5 step 7 — flat answers list. Section count uses post.commentCount,
    // not comments.count, since the list is paginated by design.
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s4) {
            ABSectionTitle("Answers (\(post.commentCount))", level: .section)

            if comments.isEmpty {
                Text("Be the first to answer.")
                    .font(.abBodySm)
                    .italic()
                    .foregroundStyle(Color.abOnSurfaceDisabled)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, ABSpacing.s4)
            } else {
                VStack(alignment: .leading, spacing: ABSpacing.s4) {
                    ForEach(comments) { comment in
                        CommentCell(comment: comment)
                    }
                }
            }
        }
    }

    private var matchCTASection: some View {
        ABCard(variant: .standard) {
            VStack(alignment: .leading, spacing: ABSpacing.s3) {
                Text("Still confused?")
                    .font(.abTitleSm)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.abOnSurface)
                Text("Talk to a verified senior who's been through this. Average match time: 4 minutes.")
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(2)
                ABButton(
                    title: "Match a volunteer",
                    variant: .primaryGradient,
                    size: .medium,
                    icon: "person.badge.plus",
                    fullWidth: true
                ) {
                    onMatchVolunteer(post)
                }
            }
        }
    }
}

// MARK: - CommentCell (private)
//
// Reddit-style flat comment row. Not promoted to ABDesignSystem/Components
// because (a) used only here, (b) v2 threading/voting/reply will reshape
// the API. See plan: image-1-fake-q-a-rosy-crayon.md §3.

private struct CommentCell: View {
    let comment: ABQAComment

    var body: some View {
        HStack(alignment: .top, spacing: ABSpacing.s3) {
            ABAvatar(content: .initials(comment.author.initials), size: 32)

            VStack(alignment: .leading, spacing: ABSpacing.s2) {
                HStack(spacing: ABSpacing.s2) {
                    Text(comment.author.username)
                        .font(.abLabelMd)
                        .foregroundStyle(Color.abOnSurface)
                    Text("·")
                        .foregroundStyle(Color.abOnSurfaceDisabled)
                    Text(comment.timeAgoString)
                        .font(.abCaption)
                        .foregroundStyle(Color.abOnSurfaceDisabled)
                    if comment.isOPReply {
                        ABTag(text: "OP", style: .contextMatch, size: .micro)
                    }
                    if comment.isVerified {
                        ABTag(text: "Verified", style: .verified, size: .micro, icon: "checkmark.shield.fill")
                    }
                }

                Text(comment.content)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 4) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 11, weight: .semibold))
                    Text("\(comment.voteCount)")
                        .font(.abCaption)
                }
                .foregroundStyle(Color.abOnSurfaceDisabled)
            }
        }
    }
}

#Preview("Q&A Detail · Verified") {
    QADetailView(post: ABMockData.qaPosts[0])
}

#Preview("Q&A Detail · Outdated") {
    QADetailView(post: ABMockData.qaPosts[1])
}

#Preview("Q&A Detail · TikTok") {
    QADetailView(post: ABMockData.qaPosts[2])
}
