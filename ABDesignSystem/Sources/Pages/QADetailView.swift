import SwiftUI

// MARK: - QADetailView
//
// §5 Q&A Detail — see docs/spec.md §5.
// Single thread + Top Answer + match-volunteer escalation (entry to §6 → §8 flow).

struct QADetailView: View {

    // MARK: Parameters (spec §5)
    public let post: ABQAPost

    public init(post: ABQAPost = ABMockData.qaPosts[0]) {
        self.post = post
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
                    matchCTASection
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }

            ABBackBar(title: "Q&A", onBack: {
                // §5.A1 — back to §3 / §4 [open §11]
            })
        }
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
                    // §5.A2 — capture `post` as originating ABQAPost; → §6
                    // ABSharedContext propagation [open §11]
                }
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
