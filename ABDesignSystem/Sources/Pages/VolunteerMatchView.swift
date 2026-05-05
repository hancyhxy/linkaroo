import SwiftUI

// MARK: - VolunteerMatchView
//
// §6 Volunteer Match — see docs/spec.md §6.
// M4 — algorithm legibility via visible match reasons.

public struct VolunteerMatchView: View {
    public init() {}


    // MARK: Parameters (spec §6)
    private var matches: [ABMatchResult] { ABMockData.matchResults }

    private var topChoice: ABMatchResult? {
        matches.first(where: { $0.isTopChoice }) ?? matches.first
    }

    private var moreMatches: [ABMatchResult] {
        guard let top = topChoice else { return matches }
        return matches.filter { $0.id != top.id }
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s6) {
                    ABPageHero(
                        headline: "Best Matches for You",
                        subtitle: "Volunteers matched to your profile, needs, and language"
                    )

                    if let top = topChoice {
                        topChoiceSection(top)
                    }
                    moreMatchesSection
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }

            ABBackBar(title: "Volunteer", onBack: {
                // §6.A1 — back to §5 [open §11]
            })
        }
    }

    private func topChoiceSection(_ result: ABMatchResult) -> some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            HStack(spacing: 6) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.abAccentGoldDark)
                Text("THE BEST FIT")
                    .font(.abLabelSm)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.abAccentGoldDark)
                    .tracking(1.2)
            }

            ABVolunteerHeroCard(
                data: ABVolunteerHeroData(
                    name: result.volunteer.user.displayName,
                    role: result.volunteer.role,
                    imageURL: result.volunteer.user.avatarURL,
                    matchPercent: result.matchPercentage,
                    rating: result.volunteer.rating,
                    helpedCount: result.volunteer.peopleHelped,
                    skills: result.volunteer.skills.map {
                        (text: $0.text, style: skillStyle(for: $0.category))
                    },
                    bio: result.volunteer.bio
                ),
                onCTA: {
                    // §6.A2 — → §8 Chat; mount ABSharedContext per §10.3
                    // [open §11 — propagation mechanism]
                }
            )

            if !result.matchReasons.isEmpty {
                matchReasonsCard(result.matchReasons)
            }
        }
    }

    private func matchReasonsCard(_ reasons: [String]) -> some View {
        ABCard(variant: .standard) {
            VStack(alignment: .leading, spacing: ABSpacing.s2) {
                Text("Why she's a match for you")
                    .font(.abLabelLg)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .textCase(.uppercase)
                    .tracking(0.8)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(reasons.enumerated()), id: \.offset) { _, reason in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.abPrimary)
                                .padding(.top, 2)
                            Text(reason)
                                .font(.abBodySm)
                                .foregroundStyle(Color.abOnSurface)
                        }
                    }
                }
            }
        }
    }

    private var moreMatchesSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            Text("More matches")
                .font(.abLabelLg)
                .fontWeight(.semibold)
                .foregroundStyle(Color.abOnSurfaceVariant)
                .textCase(.uppercase)
                .tracking(0.8)

            VStack(spacing: ABSpacing.s4) {
                ForEach(moreMatches) { result in
                    ABVolunteerMatchCard(
                        data: ABVolunteerMatchData(
                            name: result.volunteer.user.displayName,
                            imageURL: result.volunteer.user.avatarURL,
                            matchPercent: result.matchPercentage,
                            skills: result.volunteer.skills.map {
                                (text: $0.text, style: skillStyle(for: $0.category))
                            },
                            bio: result.volunteer.bio
                        ),
                        onCTA: {
                            // §6.A3 — → §8 Chat [open §11]
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Helpers

func skillStyle(for category: ABSkillCategory) -> ABTagStyle {
    switch category {
    case .blue: return .skillBlue
    case .warm: return .skillWarm
    }
}

#Preview("Volunteer Match") {
    VolunteerMatchView()
}
