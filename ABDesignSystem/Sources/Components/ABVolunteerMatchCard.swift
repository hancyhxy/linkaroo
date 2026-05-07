import SwiftUI

// MARK: - Volunteer Match Data

public struct ABVolunteerMatchData {
    public let name: String
    public let imageURL: URL?
    public var avatar: ABAvatarContent? = nil           // overrides imageURL when set
    public var matchPercent: Int = 0
    public var skills: [(text: String, style: ABTagStyle)] = []
    public var bio: String = ""

    public init(
        name: String,
        imageURL: URL? = nil,
        avatar: ABAvatarContent? = nil,
        matchPercent: Int = 0,
        skills: [(text: String, style: ABTagStyle)] = [],
        bio: String = ""
    ) {
        self.name = name
        self.imageURL = imageURL
        self.avatar = avatar
        self.matchPercent = matchPercent
        self.skills = skills
        self.bio = bio
    }
}

// MARK: - ABVolunteerMatchCard

/// Compact volunteer card for "More Matches" section.
public struct ABVolunteerMatchCard: View {
    public let data: ABVolunteerMatchData
    public var ctaTitle: String = "View Profile"
    public var onCTA: (() -> Void)? = nil

    public var body: some View {
        HStack(alignment: .top, spacing: ABSpacing.s3) {
            // Thumbnail — circle, matching every other avatar in the app.
            ABAvatar(content: data.avatar ?? .image(data.imageURL), size: 56)

            // Content
            VStack(alignment: .leading, spacing: ABSpacing.s2) {
                // Name + Match %
                HStack {
                    Text(data.name)
                        .font(.abTitleSm)
                        .foregroundStyle(Color.abOnSurface)
                    Spacer()
                    ABTag(text: "\(data.matchPercent)% Match", style: .matchPercent, size: .badge)
                }

                // Skill tags
                if !data.skills.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(Array(data.skills.enumerated()), id: \.offset) { _, skill in
                            ABTag(text: skill.text, style: skill.style)
                        }
                    }
                }

                // Bio
                if !data.bio.isEmpty {
                    Text(data.bio)
                        .font(.abBodySm)
                        .foregroundStyle(Color.abOnSurfaceVariant)
                        .lineLimit(3)
                }

                // CTA
                ABButton(title: ctaTitle, variant: .secondary, size: .small) {
                    onCTA?()
                }
            }
        }
        .padding(ABSpacing.s4)
        .background(Color.abSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xl))
    }
}

// MARK: - Preview

#Preview("Volunteer Match Cards") {
    VStack(spacing: 12) {
        ABVolunteerMatchCard(data: ABVolunteerMatchData(
            name: "David K.",
            imageURL: nil,
            matchPercent: 82,
            skills: [("Legal Background", .skillBlue), ("Visa Expert", .skillBlue)],
            bio: "Immigration lawyer with 5+ years experience helping skilled workers and students."
        ))

        ABVolunteerMatchCard(data: ABVolunteerMatchData(
            name: "Chen W.",
            imageURL: nil,
            matchPercent: 75,
            skills: [("Former Student", .skillBlue), ("Career Mentor", .skillBlue)],
            bio: "Former international student turned tech professional."
        ))
    }
    .padding()
    .background(Color.abSurface)
}
