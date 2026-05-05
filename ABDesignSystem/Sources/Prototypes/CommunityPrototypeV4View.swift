import SwiftUI

// MARK: - CommunityPrototypeV4View
//
// EXPERIMENT (V4): spec-driven re-derivation of §3 Community.
// First spec-driven prototype for this page.
//
// What I read to write this file:
//   ✅ docs/spec.md §3 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0.4 (`segmented control`, `horizontal carousel`,
//                        `tab bar`)
//   ✅ docs/design.md
//   ✅ docs/struct.md §2 §3 (ABQAPost, ABHelpRequest*, ABContentTag*)
//   ✅ docs/mockups/community.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABLayout tokens
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift + ABMockData (qaPosts, helpRequests)
//
// What I deliberately did NOT read:
//   ❌ Pages/CommunityView.swift (v1)
//   ❌ Component bodies past the init signature
//
// SPEC GAP markers found this round:
//
//   [GAP-16] *** Big one *** spec/v1 segment names are
//     "Discussions" / "People to help". Mockup community.html shows
//     "Discussions" / "Messages" — Messages tab is a unread-count
//     badge segment. So §3 Community Mockup is actually a 2-segment
//     hub combining Discussions + DM list (§7's territory). spec
//     under-models §3.
//
//     Resolution path A: trust mockup → segment 2 is Messages, §7
//     becomes a sub-segment of §3 (not a standalone page).
//     Resolution path B: trust spec → segment 2 is "People to help",
//     §7 stays standalone (current model).
//     This prototype follows spec (path B) so it stays comparable
//     with v1, but **records the discrepancy**.
//
//   [GAP-17] Mockup section title is "People You Can Help" (case +
//     wording differs from spec's "People to help"). Following mockup
//     for the section heading; segment label follows spec.
//
//   [GAP-18] Mockup §3 "Discussions" segment shows the Q&A list with
//     section title "Questions You Can Answer", not just a flat list.
//     spec says "vertical list of content cards" without a heading.
//     Adding the heading per mockup §0.5b authority.
//
//   [GAP-19] tagStyle helper — same pattern as [GAP-2]/[GAP-9]. Local mirror.
//

private enum CommunitySegmentV4: String, CaseIterable, CustomStringConvertible {
    case discussions = "Discussions"
    case peopleYouCanHelp = "People to help"

    var description: String { rawValue }
}

struct CommunityPrototypeV4View: View {

    // MARK: Parameters (spec §3 Feature.Parameters)
    @State private var segment: CommunitySegmentV4 = .discussions
    @State private var selectedTab: ABTab = .community

    private var qaPosts: [ABQAPost] { ABMockData.qaPosts }
    private var helpRequests: [ABHelpRequest] { ABMockData.helpRequests }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Header bar (page-title variant, no back)
                ABHeader(variant: .pageTitle(title: "Community", showBack: false))

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s5) {
                        // Layout 2 — Segment selector (§3.A1)
                        ABSegmentedControl(
                            options: CommunitySegmentV4.allCases,
                            selected: $segment
                        )
                        .padding(.horizontal, ABLayout.pagePadding)

                        switch segment {
                        case .discussions:
                            discussionsBody     // Layout 3
                        case .peopleYouCanHelp:
                            peopleToHelpBody    // Layout 4
                        }
                    }
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            // Layout 5 — Bottom tab bar overlay (§3.A4)
            ABTabBar(selectedTab: $selectedTab)
        }
    }

    // MARK: Layout 3 — Discussions body
    //
    // [GAP-18] mockup adds a section title "Questions You Can Answer"
    // above the list; spec doesn't. Honoring mockup.
    private var discussionsBody: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Questions You Can Answer", level: .section)
                .padding(.horizontal, ABLayout.pagePadding)

            VStack(spacing: ABSpacing.s3) {
                ForEach(qaPosts) { post in
                    ABQAPostCard(
                        post: ABQAPostData(
                            author: post.author.username,
                            timeAgo: post.timeAgoString,
                            title: post.title,
                            preview: post.preview,
                            tags: post.tags.map { (text: $0.text, style: tagStyle(for: $0.type)) },
                            voteCount: post.voteCount,
                            commentCount: post.commentCount,
                            topAnswer: post.topAnswer?.excerpt
                        ),
                        onTap: {
                            // §3.A2 — → §5 Q&A Detail [open §11]
                        }
                    )
                    .padding(.horizontal, ABLayout.pagePadding)
                }
            }
        }
    }

    // MARK: Layout 4 — People-to-help body
    //
    // Spec: "section title (level: section) + horizontal carousel".
    // [GAP-17] heading copy from mockup: "People You Can Help".
    private var peopleToHelpBody: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("People You Can Help", level: .section)
                .padding(.horizontal, ABLayout.pagePadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ABSpacing.s3) {
                    ForEach(helpRequests) { req in
                        ABHelpCard(
                            data: ABHelpCardData(
                                name: req.requester.displayName,
                                subtitle: req.subtitle,
                                avatarURL: req.requester.avatarURL,
                                tags: req.tags.map { (text: $0.text, style: tagStyle(for: $0.type)) },
                                quote: req.questionText,
                                achievementText: req.achievement?.text,
                                achievementIcon: req.achievement?.icon ?? "medal",
                                achievementColor: req.achievement?.variant == .cool
                                    ? Color.abPrimary
                                    : Color.abAccentGoldDark,
                                achievementBg: req.achievement?.variant == .cool
                                    ? Color.abAccentSky
                                    : Color.abAccentButter
                            ),
                            onCTA: {
                                // §3.A3 — destination [open §11]
                            }
                        )
                        .frame(width: 280) // mockup specifies 280pt fixed width
                    }
                }
                .padding(.horizontal, ABLayout.pagePadding)
            }
        }
    }

    // MARK: - [GAP-19] Local tagStyle helper
    private func tagStyle(for type: ABContentTagType) -> ABTagStyle {
        switch type {
        case .contextMatch: return .contextMatch
        case .verified:     return .verified
        case .newContent:   return .new
        case .warning:      return .warning
        case .error:        return .error
        case .gold:         return .gold
        case .topAdvice:    return .topAdvice
        case .category:     return .contextMatch
        }
    }
}

#Preview("CommunityPrototypeV4") {
    CommunityPrototypeV4View()
}
