import SwiftUI

// MARK: - QADetailView (qa_scroll.html)
//
// Construct: a single Q&A thread. Renders the original ABQAPost content, the
// ABTopAnswer in an ABQuoteBlock, contextual tags (verified / outdated / source)
// and an inline "Match a volunteer" CTA so the user can escalate to 1-on-1 chat.

struct QADetailView: View {
    let post: ABQAPost

    init(post: ABQAPost = ABMockData.qaPosts[0]) {
        self.post = post
    }

    var body: some View {
        ZStack {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Q&A"))

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
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABSpacing.s8)
                }
            }
        }
    }

    // MARK: - Tag row
    private var tagRow: some View {
        HStack(spacing: ABSpacing.s2) {
            ForEach(post.tags) { tag in
                ABTag(text: tag.text, style: tagStyle(for: tag.type), size: .small)
            }
        }
    }

    // MARK: - Title + meta
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
                Text("•")
                    .foregroundStyle(Color.abOnSurfaceDisabled)
                Text(post.timeAgoString)
                    .font(.abCaption)
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }
        }
    }

    // MARK: - Body
    private var bodyParagraph: some View {
        Text(post.fullContent.isEmpty ? post.preview : post.fullContent)
            .font(.abBodyMd)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .lineSpacing(5)
    }

    // MARK: - Top Answer block
    private func topAnswerBlock(_ answer: ABTopAnswer) -> some View {
        ABQuoteBlock(
            text: answer.excerpt,
            showHeader: true,
            headerText: answer.isVerified ? "Top Answer · Verified" : "Top Answer"
        )
    }

    // MARK: - Stats row (votes / comments)
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

    // MARK: - Match CTA
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
                ) {}
            }
        }
    }
}

// MARK: - Preview

#Preview("Q&A Detail · Verified") {
    QADetailView(post: ABMockData.qaPosts[0])
}

#Preview("Q&A Detail · Outdated") {
    QADetailView(post: ABMockData.qaPosts[1])
}
