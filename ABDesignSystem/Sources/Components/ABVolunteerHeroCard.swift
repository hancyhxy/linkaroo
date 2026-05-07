import SwiftUI

// MARK: - Volunteer Hero Data

public struct ABVolunteerHeroData {
    public let name: String
    public let role: String
    public let imageURL: URL?
    public var avatar: ABAvatarContent? = nil           // overrides imageURL when set
    public var matchPercent: Int = 0
    public var rating: Double = 0
    public var helpedCount: Int = 0
    public var skills: [(text: String, style: ABTagStyle)] = []
    public var bio: String = ""

    public init(
        name: String,
        role: String,
        imageURL: URL? = nil,
        avatar: ABAvatarContent? = nil,
        matchPercent: Int = 0,
        rating: Double = 0,
        helpedCount: Int = 0,
        skills: [(text: String, style: ABTagStyle)] = [],
        bio: String = ""
    ) {
        self.name = name
        self.role = role
        self.imageURL = imageURL
        self.avatar = avatar
        self.matchPercent = matchPercent
        self.rating = rating
        self.helpedCount = helpedCount
        self.skills = skills
        self.bio = bio
    }
}

// MARK: - ABVolunteerHeroCard

/// Full-width hero card for the "Best Fit" volunteer match.
public struct ABVolunteerHeroCard: View {
    public let data: ABVolunteerHeroData
    public var ctaTitle: String = "View Full Profile & Message"
    public var onCTA: (() -> Void)? = nil

    public var body: some View {
        VStack(spacing: 0) {
            // Image section
            ZStack(alignment: .bottom) {
                imageSection
                frostedOverlay
            }
            .frame(height: 208)

            // Content section
            contentSection
        }
        .background(Color.abSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xxl))
        .abShadowCard()
    }

    // MARK: - Image Section
    //
    // Two layers:
    //   1. Background — same photo, blown up + heavily blurred + tinted, fills the
    //      whole 208pt banner. Avoids hard edges when the source photo is square
    //      and the banner is landscape.
    //   2. Foreground — the photo at native aspect ratio, fitted (not filled) into
    //      a centered square frame so the face is never cropped.
    //
    // When no photo is available we fall back to a neutral container with a
    // person icon, identical to the legacy behavior.

    @ViewBuilder
    private var imageSection: some View {
        if let avatar = data.avatar {
            ZStack {
                // Blurred background layer — same image, scaled to fill, blurred.
                avatarImage(for: avatar)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 208)
                    .clipped()
                    .blur(radius: 24)
                    .overlay(Color.black.opacity(0.18))

                // Foreground square — fits face fully, centered, rounded corners.
                avatarImage(for: avatar)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 176, height: 176)
                    .clipShape(RoundedRectangle(cornerRadius: ABRadius.xl))
                    .shadow(color: Color.black.opacity(0.22), radius: 16, x: 0, y: 6)
            }
        } else if let url = data.imageURL {
            // Legacy URL path — same blur-bg + centered-square treatment.
            ZStack {
                AsyncImage(url: url) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.abSurfaceContainer
                }
                .frame(maxWidth: .infinity, maxHeight: 208)
                .clipped()
                .blur(radius: 24)
                .overlay(Color.black.opacity(0.18))

                AsyncImage(url: url) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.abSurfaceContainer
                }
                .frame(width: 176, height: 176)
                .clipShape(RoundedRectangle(cornerRadius: ABRadius.xl))
                .shadow(color: Color.black.opacity(0.22), radius: 16, x: 0, y: 6)
            }
        } else {
            Color.abSurfaceContainer
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.abOnSurfaceDisabled)
                )
        }
    }

    /// Resolve an ABAvatarContent into a SwiftUI Image (resizable but not yet
    /// constrained to an aspect ratio — caller decides .fit vs .fill).
    @ViewBuilder
    private func avatarImage(for content: ABAvatarContent) -> some View {
        switch content {
        case .asset(let name):
            if let img = ABAvatar.loadBundleImage(named: name) {
                img.resizable()
            } else {
                Color.abSurfaceContainer
            }
        case .image(let url):
            if let url {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.abSurfaceContainer
                }
            } else {
                Color.abSurfaceContainer
            }
        case .initials:
            // Hero card with initials only — degrade to neutral background;
            // the initials/letter avatar is too small for hero scale.
            LinearGradient.abAvatarFallback
        }
    }

    // MARK: - Frosted Overlay (match % + badge)

    private var frostedOverlay: some View {
        HStack {
            Text("\(data.matchPercent)% Context Match")
                .font(.abLabelMd)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.black.opacity(0.4))
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

            Spacer()

            ABTag(text: "Top Choice", style: .gold, size: .badge)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }

    // MARK: - Content Section

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            // Name + Role
            Text(data.name)
                .font(.abTitleLg)
                .foregroundStyle(Color.abOnSurface)
            Text(data.role)
                .font(.abBodySm)
                .foregroundStyle(Color.abOnSurfaceVariant)

            // Rating + Stats
            HStack(spacing: ABSpacing.s3) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.abAccentGoldDark)
                    Text(String(format: "%.1f", data.rating))
                        .font(.abTitleSm)
                        .foregroundStyle(Color.abOnSurface)
                }

                HStack(spacing: 4) {
                    Image(systemName: "person.2")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.abOnSurfaceVariant)
                    Text("\(data.helpedCount) people helped")
                        .font(.abBodySm)
                        .foregroundStyle(Color.abOnSurfaceVariant)
                }
            }

            // Skill Tags
            if !data.skills.isEmpty {
                FlowLayout(spacing: 6) {
                    ForEach(Array(data.skills.enumerated()), id: \.offset) { _, skill in
                        ABTag(text: skill.text, style: skill.style, size: .small)
                    }
                }
            }

            // Bio
            if !data.bio.isEmpty {
                Text(data.bio)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(4)
            }

            // CTA
            ABButton(
                title: ctaTitle,
                variant: .primaryGradient,
                size: .large,
                fullWidth: true
            ) {
                onCTA?()
            }
            .padding(.top, ABSpacing.s2)
        }
        .padding(ABSpacing.s5)
    }
}

// MARK: - Simple FlowLayout

/// Horizontal wrapping layout for tags/chips.
struct FlowLayout: Layout {
    public var spacing: CGFloat = 6

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x - spacing)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}

// MARK: - Preview

#Preview("Volunteer Hero Card") {
    ScrollView {
        ABVolunteerHeroCard(data: ABVolunteerHeroData(
            name: "Sarah L.",
            role: "Senior Community Advisor",
            imageURL: nil,
            matchPercent: 98,
            rating: 4.9,
            helpedCount: 142,
            skills: [
                ("UNSW Alumna", .skillBlue),
                ("Fluent in Mandarin", .skillBlue),
                ("NSW Renting Specialist", .skillWarm)
            ],
            bio: "I moved to Sydney from Shanghai 8 years ago as a student. Now I help newcomers navigate housing, visa processes, and settling in."
        ))
        .padding()
    }
    .background(Color.abSurface)
}
