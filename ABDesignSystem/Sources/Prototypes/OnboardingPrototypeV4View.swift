import SwiftUI

// MARK: - OnboardingPrototypeV4View
//
// EXPERIMENT (V4): structural calibration of §1 Onboarding header
// region.
//
// V4 vs V3 — what changed in the spec/components between the two runs:
//   • New component `ABBackBar` — slim frosted overlay holding only
//     the back chevron. Replaces the role ABHeader.pageTitle was
//     stretched into.
//   • New component `ABPageHero` — content-flow hero (24pt headline
//     + 14pt subtitle), bottles the typography decisions so subtitle
//     no longer requires SPEC GAP TEXT[heroSubtitle] self-pick.
//   • spec.md §0.4 control vocabulary now includes
//     `back bar` and `page hero (headline + subtitle)`.
//   • spec.md §1 Layout reordered:
//       1. Back bar overlay (frosted)
//       2. Page hero (headline + subtitle)        ← was Header bar + Hero intro
//       3-6. (form sections, unchanged)
//       7. Tip card
//       8. Sticky footer overlay
//
// V3 kept as-is — it is the "structure mismatch" snapshot that
// motivated this round; V4 is what the calibrated spec produces.
//
// What I read to write this file:
//   ✅ docs/spec.md §1 (calibrated Layout, §0.4 vocabulary)
//   ✅ docs/design.md (typography/elevation tokens)
//   ✅ docs/struct.md §1 (Identity layer entities)
//   ✅ docs/mockups/personalization.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABElevation
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Components/ABBackBar.swift, Components/ABPageHero.swift (new this round)
//   ✅ Models/ABModels.swift
//
// What I deliberately did NOT read:
//   ❌ Pages/OnboardingView.swift                        (v1 implementation)
//   ❌ Prototypes/OnboardingPrototypeView.swift          (V1, cheating)
//   ❌ Prototypes/OnboardingPrototypeV2View.swift        (V2)
//   ❌ Prototypes/OnboardingPrototypeV3View.swift        (V3)
//   ❌ Component bodies past the init signature
//

struct OnboardingPrototypeV4View: View {

    // MARK: Parameters (spec §1 Feature.Parameters)
    @State private var language: ABLanguage = .english
    @State private var status: ABUserStatus = .immigrantStudent
    @State private var location: ABLocation = ABLocation(city: "Sydney", state: "NSW")
    @State private var duration: ABDuration = .justLanded

    var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s8) {
                    // Layout 2 — Page hero (headline + subtitle)
                    // Resolved by ABPageHero; no SPEC GAP TEXT here
                    // because the component bottles the subtitle
                    // typography (was a V3 GAP, now closed).
                    ABPageHero(
                        headline: "Let's personalize your journey",
                        subtitle: "Help us tailor the best experience for you"
                    )

                    languageSection    // Layout 3
                    statusSection      // Layout 4
                    locationSection    // Layout 5
                    durationSection    // Layout 6
                    tipCard            // Layout 7
                }
                .padding(.horizontal, ABLayout.pagePadding)
                // Top padding: clear the back-bar overlay (≈56pt) +
                // a bit of breathing room before the hero.
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s24) // reserve sticky-footer room
            }

            // Layout 1 — Back bar overlay
            // Title "Profile Setup" is the short nav-context label
            // (mockup `personalization.html` line 20). The long
            // welcome headline "Let's personalize your journey"
            // belongs to ABPageHero below — two distinct title roles.
            ABBackBar(title: "Profile Setup", onBack: {
                // [open §11] navigation target — Onboarding back behavior
            })

            // Layout 8 — Sticky footer overlay
            VStack {
                Spacer()
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
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    // MARK: Layout 3 — Language · single-select card grid (§1.A1)
    private var languageSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
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
            // §1.A4 — write via the binding above
        }
    }

    // MARK: Layout 7 — Tip card · informational card
    private var tipCard: some View {
        ABTipCard(
            title: "Tailored for New Arrivals",
            bodyText: "Based on your profile, we'll prioritize essential settlement guides, student visa resources, and local community connections in Sydney."
        )
    }
}

#Preview("OnboardingPrototypeV4") {
    OnboardingPrototypeV4View()
}
