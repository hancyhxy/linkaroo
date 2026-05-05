import SwiftUI

// MARK: - OnboardingPrototypeV3View
//
// EXPERIMENT (V3): second spec-driven re-derivation of §1 Onboarding.
//
// V3 vs V2 — what changed in the *spec* between the two runs:
//   • spec.md §0.4 control vocabulary now includes
//     `section title (level: major / section / label)`
//   • spec.md §0.5b Copy authority — mockup HTML > v1 SwiftUI > self
//   • spec.md §1 Layout calibrated against V2 findings (page-title
//     doubles as headline, hero region reduced to "supporting paragraph",
//     primary CTA copy locked to "Finish Setup")
//   • Components/ABSectionTitle.swift exists (3-level title atom)
//   • ABDuration now conforms to CustomStringConvertible at the model
//
// What I read to write this file:
//   ✅ docs/spec.md §1 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0 (conventions, control vocabulary, copy authority)
//   ✅ docs/design.md (visual grammar)
//   ✅ docs/struct.md §1 (Identity layer entities)
//   ✅ docs/mockups/personalization.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABElevation tokens
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift (ABUser / ABLanguage / ABUserStatus /
//                             ABDuration / ABLocation)
//
// What I deliberately did NOT read:
//   ❌ Pages/OnboardingView.swift                        (v1 implementation)
//   ❌ Prototypes/OnboardingPrototypeView.swift          (V1, cheating)
//   ❌ Prototypes/OnboardingPrototypeV2View.swift        (V2, prior spec run)
//   ❌ Component bodies past the init signature (~40 lines each)
//
// Per spec §0.5b Copy authority: copy taken from
// docs/mockups/personalization.html.
//
// SPEC GAP TEXT markers — each Text() that picks a typography token
// without spec direction is annotated `// SPEC GAP TEXT[role]:`.
// These are the inputs for the next round's spec/component decision.
//

struct OnboardingPrototypeV3View: View {

    // MARK: Parameters (spec §1 Feature.Parameters)
    @State private var language: ABLanguage = .english
    @State private var status: ABUserStatus = .immigrantStudent
    @State private var location: ABLocation = ABLocation(city: "Sydney", state: "NSW")
    @State private var duration: ABDuration = .justLanded

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Header bar
                // Spec: "page title (the page-title also serves as the
                // hero headline; no second headline below)"
                ABHeader(variant: .pageTitle(title: "Let's personalize your journey"))

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s8) {
                        heroIntro          // Layout 2
                        languageSection    // Layout 3
                        statusSection      // Layout 4
                        locationSection    // Layout 5
                        durationSection    // Layout 6
                        tipCard            // Layout 7
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABSpacing.s24) // reserve sticky-footer room
                }
            }

            // Layout 8 — Sticky footer overlay
            // Spec locks primary copy to "Finish Setup" (mockup); the
            // navigation target is [open §11].
            ABStickyFooter(
                primaryTitle: "Finish Setup",
                skipTitle: "Skip for now",
                onPrimary: {
                    // §1.A5 — write ABUser to AppState; → §2 Home  [open §11]
                },
                onSkip: {
                    // §1.A6 — write default ABUser to AppState; → §2 Home  [open §11]
                }
            )
        }
    }

    // MARK: Layout 2 — Hero intro
    //
    // Spec §1 Layout-2: "supporting paragraph below the header".
    // Mockup copy: "Help us tailor the best experience for you".
    private var heroIntro: some View {
        // SPEC GAP TEXT[heroSubtitle]:
        // spec says "supporting paragraph" with no role / no token /
        // no color guidance. design.md §3 has both `bodyMd` (16pt)
        // and `bodySm` (14pt). Picking `abBodyMd` because the mockup
        // renders the subtitle one step below page-title size, but
        // this is a self-pick not driven by spec.
        Text("Help us tailor the best experience for you")
            .font(.abBodyMd)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .lineSpacing(3)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Layout 3 — Language · single-select card grid (§1.A1)
    private var languageSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            // Spec: "section title (level: section)".
            // Resolved cleanly via ABSectionTitle.
            ABSectionTitle("Preferred Language", level: .section)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: ABSpacing.s3),
                    GridItem(.flexible(), spacing: ABSpacing.s3)
                ],
                spacing: ABSpacing.s3
            ) {
                ForEach(ABLanguage.allCases) { lang in
                    ABSelectionCard(
                        label: "\(lang.flagIcon)  \(lang.rawValue)",
                        variant: .textCard,
                        isSelected: lang == language
                    ) {
                        language = lang  // §1.A1
                    }
                }
            }
        }
    }

    // MARK: Layout 4 — Status · single-select icon-card grid (§1.A2)
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Current Status", level: .section)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: ABSpacing.s3),
                    GridItem(.flexible(), spacing: ABSpacing.s3)
                ],
                spacing: ABSpacing.s3
            ) {
                ForEach(ABUserStatus.allCases) { st in
                    ABSelectionCard(
                        label: st.rawValue,
                        icon: st.icon,
                        variant: .iconCard,
                        isSelected: st == status
                    ) {
                        status = st  // §1.A2
                    }
                }
            }
        }
    }

    // MARK: Layout 5 — Location · city/state picker (§1.A3)
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Location", level: .section)
            ABLocationPicker(city: location.city, state: location.state)
            // §1.A3 — picker is display-only in v1; edit hook [open §11]
        }
    }

    // MARK: Layout 6 — Duration · single-select chip row (§1.A4)
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Duration in Australia", level: .section)
            ABChipPicker(options: ABDuration.allCases, selected: $duration)
            // ABChipPicker writes via the binding above — §1.A4
            // (ABDuration now conforms to CustomStringConvertible at the
            //  model layer per the previous-round refactor; no extension
            //  needed here.)
        }
    }

    // MARK: Layout 7 — Tip card · informational card (title + body)
    //
    // Spec §1 Layout-7: "informational card (title + body)".
    // ABTipCard takes `title` + `bodyText`. The component bottles the
    // title/body typography internally — but the *role names* spec uses
    // ("title" / "body") have no resolution table:
    //
    // SPEC GAP TEXT[cardTitle], SPEC GAP TEXT[cardBody]:
    // ABTipCard's interior typography is opaque from spec's vantage.
    // Spec says "title + body" but doesn't say what role those are.
    // Component decides; spec has no way to *direct* a different role.
    // (Not picking tokens here because ABTipCard owns them — but a
    // recommendation card with the *same* "title + body" pattern would
    // need separate role guidance; see HomePrototypeV3.)
    private var tipCard: some View {
        ABTipCard(
            title: "Tailored for New Arrivals",
            bodyText: "Based on your profile, we'll prioritize essential settlement guides, student visa resources, and local community connections in Sydney."
        )
    }
}

#Preview("OnboardingPrototypeV3") {
    OnboardingPrototypeV3View()
}
