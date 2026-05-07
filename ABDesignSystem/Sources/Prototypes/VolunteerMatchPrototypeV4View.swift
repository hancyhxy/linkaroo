import SwiftUI

// MARK: - VolunteerMatchPrototypeV4View
//
// EXPERIMENT (V4): spec-driven re-derivation of §6 Volunteer Match.
// First spec-driven prototype for this page.
//
// What I read to write this file:
//   ✅ docs/spec.md §6 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0.4 (`match-reasons list`, `match-percent badge`)
//   ✅ docs/spec.md §10.3 (Shared Context downstream consumer)
//   ✅ docs/design.md
//   ✅ docs/struct.md §3 (ABVolunteer, ABMatchResult, ABSkillTag*)
//   ✅ docs/mockups/volunteer.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABLayout tokens
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift + ABMockData.matchResults
//
// What I deliberately did NOT read:
//   ❌ Pages/VolunteerMatchView.swift (v1)
//   ❌ Component bodies past the init signature
//
// SPEC GAP markers found this round:
//
//   [GAP-7] Mockup says "THE BEST FIT" + crown icon, spec/struct say
//     "TOP CHOICE" + gold tag. v1 follows spec, mockup is authority
//     per §0.5b. Honoring mockup string here.
//
//   [GAP-8] Mockup hero shows "98% Context Match" overlaid on the
//     volunteer photo with frosted glass — that overlay treatment
//     belongs to ABVolunteerHeroCard (component-internal). spec says
//     "tag-chip pair" for a separate row above the card; mockup has
//     it inside the card. Resolved: trust ABVolunteerHeroCard's
//     internal frosted overlay (it already renders matchPercent +
//     TOP CHOICE inline) and skip an external badge row. spec needs
//     to drop the "tag-chip pair" external bullet.
//
//   [GAP-9] `skillStyle(for: ABSkillCategory)` helper — same pattern
//     as [GAP-2] tagStyle: free function in Pages/, off-limits.
//     Local mirror declared.
//
//   [GAP-10] §6 mockup shows secondary CTA "View Profile" on More
//     match cards (border style, secondary), not "View Full Profile
//     & Message" (primary). ABVolunteerMatchCard already has
//     `ctaTitle: "View Profile"` default — aligned. No fix needed.
//

struct VolunteerMatchPrototypeV4View: View {

    // MARK: Parameters (spec §6 Feature.Parameters)
    private var matches: [ABMatchResult] { ABMockData.matchResults }

    private var topChoice: ABMatchResult? {
        matches.first(where: { $0.isTopChoice }) ?? matches.first
    }

    private var moreMatches: [ABMatchResult] {
        guard let top = topChoice else { return matches }
        return matches.filter { $0.id != top.id }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s6) {
                    // Layout 2 — Page hero (compact: just headline + subtitle)
                    // Mockup includes a hero text block above the cards;
                    // spec doesn't mention it but mockup wins (§0.5b).
                    ABPageHero(
                        headline: "Best Matches for You",
                        subtitle: "Volunteers matched to your profile, needs, and language"
                    )

                    if let top = topChoice {
                        topChoiceSection(top)  // Layout 3
                    }
                    moreMatchesSection         // Layout 4
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }

            // Layout 1 — Back bar overlay
            // §0.4 says detail pages use ABHeader.pageTitle; but to keep
            // visual continuity with V4 prototypes (frosted slim bar) and
            // since ABHeader.pageTitle's background was just changed to
            // inherit page surface, either works. Picking ABBackBar
            // because mockup has no title in the bar — just a back chevron
            // (volunteer.html line 18-21 shows "Volunteer" label, but the
            // page hero already carries the page identity).
            //
            // [GAP-11] mockup shows "Volunteer" in the bar and ALSO has
            // "Best Matches for You" as page hero — two title roles, same
            // pattern as Onboarding's "Profile Setup" + headline. So
            // honoring mockup → ABBackBar(title: "Volunteer").
            ABBackBar(title: "Volunteer", onBack: {
                // §6.A1 — back to §5 [open §11]
            })
        }
    }

    // MARK: Layout 3 — Top Choice section (§6.A2)
    //
    // Spec: "tag-chip pair (style: gold "TOP CHOICE" + match-percent
    // badge) + hero card (volunteer hero) + match-reasons list".
    // [GAP-8] the tag-chip pair lives inside the hero card's frosted
    // overlay per mockup, so the external pair is redundant. Just
    // render hero + match reasons.
    private func topChoiceSection(_ result: ABMatchResult) -> some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            // [GAP-7] mockup uses "THE BEST FIT" + crown icon, not
            // "TOP CHOICE". Honoring mockup.
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
                    avatar: result.volunteer.user.avatarContent,
                    matchPercent: result.matchPercentage,
                    rating: result.volunteer.rating,
                    helpedCount: result.volunteer.peopleHelped,
                    skills: result.volunteer.skills.map {
                        (text: $0.text, style: skillStyle(for: $0.category))
                    },
                    bio: result.volunteer.bio
                ),
                onCTA: {
                    // §6.A2 — → §8 Chat with `result.volunteer`,
                    // mount originating ABQAPost as ABSharedContext
                    // [open §11 — propagation mechanism unspecified]
                }
            )

            if !result.matchReasons.isEmpty {
                matchReasonsCard(result.matchReasons)
            }
        }
    }

    // MARK: match-reasons list — M4 algorithm legibility
    //
    // Spec §0.4: "checkmark-prefixed bulleted list sitting inside an
    // ABCard(.standard) directly under the volunteer hero". Self-pick
    // header copy because spec doesn't dictate it and mockup has no
    // dedicated reasons block (the reasons are implied by skill tags
    // alone in mockup — but the M4 thesis says reasons should be
    // explicit, so we render them as a separate card).
    //
    // [GAP-12] mockup volunteer.html does NOT render an explicit
    // matchReasons list — the algorithm legibility lives implicitly
    // in skill tags + role + bio. Spec/struct.md adds matchReasons
    // as a first-class field; rendering it explicitly is a product
    // decision spec made beyond what mockup shows. Honoring spec
    // here because matchReasons is the load-bearing M4 mechanism.
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

    // MARK: Layout 4 — More matches section (§6.A3)
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
                            avatar: result.volunteer.user.avatarContent,
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

    // MARK: - [GAP-9] Local skillStyle helper
    private func skillStyle(for category: ABSkillCategory) -> ABTagStyle {
        switch category {
        case .blue: return .skillBlue
        case .warm: return .skillWarm
        }
    }
}

#Preview("VolunteerMatchPrototypeV4") {
    VolunteerMatchPrototypeV4View()
}
