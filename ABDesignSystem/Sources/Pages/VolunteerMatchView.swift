import SwiftUI

// MARK: - VolunteerMatchView (volunteer.html)
//
// Construct: hierarchical volunteer matching. The first ABMatchResult marked
// `isTopChoice` is rendered as a hero card with match-percentage and the
// "why she's a match for you" reasons. Subsequent matches use the compact
// ABVolunteerMatchCard.

struct VolunteerMatchView: View {
    var matches: [ABMatchResult] { ABMockData.matchResults }

    var topChoice: ABMatchResult? { matches.first(where: { $0.isTopChoice }) ?? matches.first }
    var moreMatches: [ABMatchResult] {
        guard let top = topChoice else { return matches }
        return matches.filter { $0.id != top.id }
    }

    var body: some View {
        ZStack {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Best matches for you"))

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s6) {
                        if let top = topChoice {
                            heroSection(top)
                        }
                        moreMatchesSection
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABSpacing.s8)
                }
            }
        }
    }

    // MARK: - Hero section
    private func heroSection(_ result: ABMatchResult) -> some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            HStack(spacing: 6) {
                ABTag(text: "TOP CHOICE", style: .gold, size: .small)
                ABTag(text: "\(result.matchPercentage)% Match",
                      style: .matchPercent,
                      size: .badge)
            }

            ABVolunteerHeroCard(data: result.toHeroData())

            if !result.matchReasons.isEmpty {
                whyMatchBlock(result.matchReasons)
            }
        }
    }

    private func whyMatchBlock(_ reasons: [String]) -> some View {
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

    // MARK: - More matches section
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
                    ABVolunteerMatchCard(data: result.toMatchData())
                }
            }
        }
    }
}

// MARK: - Adapters: Models → Component data

extension ABMatchResult {
    func toHeroData() -> ABVolunteerHeroData {
        ABVolunteerHeroData(
            name: volunteer.user.displayName,
            role: volunteer.role,
            imageURL: volunteer.user.avatarURL,
            matchPercent: matchPercentage,
            rating: volunteer.rating,
            helpedCount: volunteer.peopleHelped,
            skills: volunteer.skills.map {
                (text: $0.text, style: skillStyle(for: $0.category))
            },
            bio: volunteer.bio
        )
    }

    func toMatchData() -> ABVolunteerMatchData {
        ABVolunteerMatchData(
            name: volunteer.user.displayName,
            imageURL: volunteer.user.avatarURL,
            matchPercent: matchPercentage,
            skills: volunteer.skills.map {
                (text: $0.text, style: skillStyle(for: $0.category))
            },
            bio: volunteer.bio
        )
    }
}

func skillStyle(for category: ABSkillCategory) -> ABTagStyle {
    switch category {
    case .blue: return .skillBlue
    case .warm: return .skillWarm
    }
}

// MARK: - Preview

#Preview("Volunteer Match") {
    VolunteerMatchView()
}
