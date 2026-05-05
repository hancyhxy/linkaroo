import SwiftUI

// MARK: - QADetailPrototypeV4View
//
// EXPERIMENT (V4): spec-driven re-derivation of §5 Q&A Detail.
// First spec-driven prototype for this page (no V1/V2/V3 baseline).
//
// What I read to write this file:
//   ✅ docs/spec.md §5 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0 (control vocabulary, copy authority)
//   ✅ docs/spec.md §10.3 (Shared Context mounting — origin point lives here)
//   ✅ docs/design.md (typography / elevation tokens)
//   ✅ docs/struct.md §2 (ABQAPost, ABTopAnswer, ABContentTag*, ABVerificationStatus, ABContentSource)
//   ✅ ABColors / ABTypography / ABSpacing / ABElevation / ABLayout
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift + ABMockData.qaPosts[0]
//
// What I deliberately did NOT read:
//   ❌ Pages/QADetailView.swift (v1 implementation — would defeat the experiment)
//   ❌ Component bodies past the init signature
//
// SPEC GAP / MOCKUP GAP markers found this round:
//
//   [GAP-1] No mockup covers §5.
//     `docs/mockups/qa_scroll.html` is a Q&A *list* scroll snapshot,
//     not the detail page. So §0.5b's primary copy authority (mockup)
//     is missing for §5. spec.md §5 is the only authority — copy is
//     either (a) action-typed (button/link names already in spec
//     Layout) or (b) self-authored placeholder for region demos.
//
//   [GAP-2] `tagStyle(for: ABContentTagType)` helper has no public
//     home in Components/. v1 defined it as a free function inside
//     Pages/HomeView.swift, which is off-limits for this experiment.
//     Declared a local mirror — should graduate to the Components
//     layer, or absorb into ABTag's init.
//
//   [GAP-3] §5 Layout-3 says "section title (level: section) headline
//     + caption row (author username · time-ago)" — but `section title
//     (level: section)` per §0.4 maps to ABSectionTitle, which is a
//     form-section heading style, not a Q&A *headline*. The Q&A title
//     in v1 mockup feel is closer to `abHeadlineMd` (20pt, body-section
//     headline). Resolved by self-picking abHeadlineMd; spec language
//     should probably read "headline (medium)" not section title.
//
//   [GAP-4] §5.A2 effect: spec says "post is captured as the
//     originating ABQAPost for downstream §10.3 mounting" but doesn't
//     name the mechanism (route param / shared store / callback).
//     Marked `[open §11]`.
//

struct QADetailPrototypeV4View: View {

    // MARK: Parameters (spec §5 Feature.Parameters)
    let post: ABQAPost

    init(post: ABQAPost = ABMockData.qaPosts[0]) {
        self.post = post
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s5) {
                    tagRow              // Layout 2
                    titleAndMeta        // Layout 3
                    bodyParagraph       // Layout 4
                    if let answer = post.topAnswer {
                        topAnswerBlock(answer)  // Layout 5
                    }
                    statsRow            // Layout 6
                    matchCTASection     // Layout 7
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s8)
            }

            // Layout 1 — Back bar overlay
            // Spec §5 Layout-1 calls for "header bar (page-title variant,
            // with back) — title 'Q&A'". §0.4 vocabulary now distinguishes
            // back bar (slim 56pt) from header bar (taller 64pt one-row).
            // Spec literally says "header bar"; honoring that — using
            // ABBackBar with title would be the editorial pair, but spec
            // is explicit so use ABHeader.pageTitle here.
            //
            // [GAP-5] §5 description "compact 64pt header" + §0.4 "Pick
            // ABHeader.pageTitle for compact detail pages (Q&A Detail,
            // Volunteer Match)" — these are aligned. No drift.
            ABHeader(variant: .pageTitle(title: "Q&A"))
        }
    }

    // MARK: Layout 2 — Tag row (§5)
    //
    // Spec: "horizontal row of tag chips (one per `post.tags`; styles
    // drive credibility legibility — verified / unverified / outdated /
    // source / contextMatch)". Concrete tag → style mapping comes from
    // ABContentTagType cases (struct.md). [GAP-2] helper duplicated
    // locally because no public Components-layer version exists.
    private var tagRow: some View {
        HStack(spacing: ABSpacing.s2) {
            ForEach(post.tags) { tag in
                ABTag(text: tag.text, style: tagStyle(for: tag.type), size: .small)
            }
        }
    }

    // MARK: Layout 3 — Title + meta (§5)
    private var titleAndMeta: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            // [GAP-3] spec said "section title (level: section)" but
            // that token is for form headings; Q&A headline wants
            // `abHeadlineMd` (20pt). Self-picking.
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

    // MARK: Layout 4 — Body paragraph (§5)
    //
    // Spec: "paragraph rendering `post.fullContent` (falls back to
    // `post.preview` when empty)". Cleanly resolved.
    private var bodyParagraph: some View {
        Text(post.fullContent.isEmpty ? post.preview : post.fullContent)
            .font(.abBodyMd)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .lineSpacing(5)
    }

    // MARK: Layout 5 — Top Answer block (§5)
    //
    // Spec: 'header text "Top Answer · Verified" when
    // `topAnswer.isVerified`, else "Top Answer"'. The strings are
    // action-typed (semantic header) so they live in spec/here.
    private func topAnswerBlock(_ answer: ABTopAnswer) -> some View {
        ABQuoteBlock(
            text: answer.excerpt,
            showHeader: true,
            headerText: answer.isVerified ? "Top Answer · Verified" : "Top Answer"
        )
    }

    // MARK: Layout 6 — Stats row (§5)
    //
    // Spec: "caption row (vote count · comment count)". `abLabelMd` is
    // a tighter inline label tier than `abCaption` — picking it because
    // stats row sits next to a CTA card and needs to feel weight-equivalent
    // to button labels, not as light as the meta row above the title.
    //
    // [GAP-6] spec says "caption row" but stats role is heavier than
    // meta caption. Token name "caption" misleads here. Vocab might want
    // a `stats row` term distinct from `caption row`.
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

    // MARK: Layout 7 — Match CTA (§5.A2)
    //
    // Spec: 'informational card (title + body + primary button "Match
    // a volunteer" (§5.A2))'. The button title is action-typed copy
    // (allowed in spec). Title + body inside the card are NOT
    // action-typed — they are decorative microcopy, so they would
    // normally come from a mockup, but [GAP-1] there is no §5 mockup.
    // Self-authored placeholder strings, marked TODO so they're grep-able.
    private var matchCTASection: some View {
        ABCard(variant: .standard) {
            VStack(alignment: .leading, spacing: ABSpacing.s3) {
                // TODO: copy — no §5 mockup; placeholder driving demo
                Text("Still confused?")
                    .font(.abTitleSm)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.abOnSurface)
                // TODO: copy — no §5 mockup; placeholder driving demo
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
                    // §5.A2 — capture `post` as originating ABQAPost
                    // and navigate → §6 Volunteer Match.
                    // Mechanism [open §11].
                }
            }
        }
    }

    // MARK: - [GAP-2] Local tagStyle helper
    //
    // Mirror of the free function defined in Pages/HomeView.swift,
    // re-declared here because Pages/ is off-limits for this experiment.
    // Should graduate to Components layer (e.g. extension on ABTag, or
    // a public helper module).
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

#Preview("QADetailPrototypeV4 · Verified") {
    QADetailPrototypeV4View(post: ABMockData.qaPosts[0])
}

#Preview("QADetailPrototypeV4 · Outdated") {
    QADetailPrototypeV4View(post: ABMockData.qaPosts[1])
}
