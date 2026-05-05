import SwiftUI

// MARK: - Help Card Data

public struct ABHelpCardData {
    public let name: String
    public let subtitle: String
    public let avatarURL: URL?
    public var tags: [(text: String, style: ABTagStyle)] = []
    public var quote: String = ""
    public var achievementText: String? = nil
    public var achievementIcon: String = "medal"
    public var achievementColor: Color = Color.abTagTopAdviceText
    public var achievementBg: Color = Color.abAccentButter
    public var ctaTitle: String = "Answer"
}

// MARK: - ABHelpCard

/// Horizontal scroll card for community "People You Can Help" section.
/// Fixed width at 280pt.
public struct ABHelpCard: View {
    public let data: ABHelpCardData
    public var onCTA: (() -> Void)? = nil

    public var body: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            // Header
            HStack(spacing: ABSpacing.s3) {
                ABAvatar(content: .image(data.avatarURL), size: ABAvatarSize.md)
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.name)
                        .font(.abTitleSm)
                        .foregroundStyle(Color.abOnSurface)
                    Text(data.subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.abOnSurfaceDisabled)
                }
            }

            // Tags
            if !data.tags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(Array(data.tags.enumerated()), id: \.offset) { _, tag in
                        ABTag(text: tag.text, style: tag.style)
                    }
                }
            }

            // Quote
            if !data.quote.isEmpty {
                Text(data.quote)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(4)
                    .lineLimit(3)
            }

            // Achievement badge
            if let text = data.achievementText {
                HStack(spacing: 6) {
                    Image(systemName: data.achievementIcon)
                        .font(.system(size: 14))
                        .foregroundStyle(data.achievementColor)
                    Text(text)
                        .font(.abCaption)
                        .foregroundStyle(data.achievementColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(data.achievementBg)
                .clipShape(RoundedRectangle(cornerRadius: ABRadius.lg))
            }

            // CTA
            ABButton(
                title: "\(data.ctaTitle) \(data.name.components(separatedBy: " ").first ?? "")",
                variant: .primaryGradient,
                size: .small,
                fullWidth: true
            ) {
                onCTA?()
            }
        }
        .padding(ABSpacing.s4)
        .frame(width: ABLayout.cardHorizontal)
        .background(Color.abSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xl))
    }
}

// MARK: - Preview

#Preview("Help Cards") {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
            ABHelpCard(data: ABHelpCardData(
                name: "Mei Lin",
                subtitle: "Just arrived in Sydney",
                avatarURL: nil,
                tags: [("Student Match", .contextMatch), ("Newcomer", .new)],
                quote: "\"Can someone explain the Student Visa work hour limits?\"",
                achievementText: "You helped 3 others with Student Visas this month"
            ))

            ABHelpCard(data: ABHelpCardData(
                name: "David O.",
                subtitle: "First year Engineering",
                avatarURL: nil,
                tags: [("University Life", .contextMatch), ("UNSW", .contextMatch)],
                quote: "\"Looking for affordable student housing near UNSW.\"",
                achievementText: "You both attend UNSW Sydney",
                achievementIcon: "building.columns",
                achievementColor: .abPrimary,
                achievementBg: Color.abAccentSky
            ))
        }
        .padding(.horizontal)
    }
    .background(Color.abSurface)
}
