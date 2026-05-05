import SwiftUI

// MARK: - QA Post Data

public struct ABQAPostData {
    public let author: String
    public let timeAgo: String
    public let title: String
    public let preview: String
    public var tags: [(text: String, style: ABTagStyle)] = []
    public var voteCount: Int = 0
    public var commentCount: Int = 0
    public var topAnswer: String? = nil
}

// MARK: - ABQAPostCard

public struct ABQAPostCard: View {
    public let post: ABQAPostData
    public var onVoteUp: (() -> Void)? = nil
    public var onVoteDown: (() -> Void)? = nil
    public var onTap: (() -> Void)? = nil

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(alignment: .top, spacing: ABSpacing.s3) {
                // Vote Column
                voteColumn

                // Content Column
                contentColumn
            }
            .padding(ABSpacing.s4)
            .background(Color.abSurfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: ABRadius.xl))
        }
        .buttonStyle(ABPressStyle())
    }

    // MARK: - Vote Column

    private var voteColumn: some View {
        VStack(spacing: ABSpacing.s1) {
            Button(action: { onVoteUp?() }) {
                Image(systemName: "chevron.up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Text("\(post.voteCount)")
                .font(.abTitleSm)
                .foregroundStyle(Color.abPrimaryBright)

            Button(action: { onVoteDown?() }) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .frame(width: 32)
    }

    // MARK: - Content Column

    private var contentColumn: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            // Tags
            if !post.tags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(Array(post.tags.enumerated()), id: \.offset) { _, tag in
                        ABTag(text: tag.text, style: tag.style)
                    }
                }
            }

            // Meta line
            Text("u/\(post.author) • \(post.timeAgo)")
                .font(.abCaption)
                .foregroundStyle(Color.abOnSurfaceDisabled)

            // Title
            Text(post.title)
                .font(.abTitleMd)
                .foregroundStyle(Color.abOnSurface)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            // Preview
            Text(post.preview)
                .font(.abBodySm)
                .foregroundStyle(Color.abOnSurfaceVariant)
                .lineLimit(2)

            // Top Answer
            if let topAnswer = post.topAnswer {
                ABQuoteBlock(text: topAnswer, showHeader: true)
            }

            // Action bar
            HStack(spacing: ABSpacing.s4) {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 14))
                    Text("\(post.commentCount) Comments")
                        .font(.abLabelMd)
                }
                .foregroundStyle(Color.abOnSurfaceDisabled)

                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14))
                    Text("Share")
                        .font(.abLabelMd)
                }
                .foregroundStyle(Color.abOnSurfaceDisabled)
            }
            .padding(.top, ABSpacing.s1)
        }
    }
}

// MARK: - Preview

#Preview("Q&A Post Card") {
    ScrollView {
        VStack(spacing: 12) {
            ABQAPostCard(post: ABQAPostData(
                author: "SydneySilver",
                timeAgo: "4h ago",
                title: "What are the best suburbs for seniors in Sydney with good public transport?",
                preview: "I'm looking for a suburb that has easy access to trains and buses, ideally with some parks nearby...",
                tags: [
                    ("Senior Match", .contextMatch),
                    ("Government Verified", .verified)
                ],
                voteCount: 142,
                commentCount: 32,
                topAnswer: "\"Chatswood and Hurstville are great options - both have train stations and parks.\""
            ))

            ABQAPostCard(post: ABQAPostData(
                author: "LegalEagle_AU",
                timeAgo: "8h ago",
                title: "Rights when a landlord wants to sell the senior-living unit?",
                preview: "My landlord just told me they plan to sell the property...",
                tags: [
                    ("Old Law", .error),
                    ("Unverified", .warning)
                ],
                voteCount: 89,
                commentCount: 15
            ))
        }
        .padding()
    }
    .background(Color.abSurface)
}
