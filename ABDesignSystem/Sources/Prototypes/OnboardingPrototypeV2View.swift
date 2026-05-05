import SwiftUI

// MARK: - OnboardingPrototypeV2View
//
// EXPERIMENT: spec-driven re-derivation of §1 Onboarding.
//
// What I read to write this file:
//   ✅ docs/spec.md §1 (Overview / Parameters / Actions / Layout)
//   ✅ docs/design.md (visual grammar)
//   ✅ docs/struct.md §1 (data model)
//   ✅ docs/mockups/personalization.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing (design tokens)
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift (ABUser / ABLanguage / ABUserStatus / ABDuration / ABLocation)
//
// What I deliberately did NOT read:
//   ❌ Pages/OnboardingView.swift (the v1 implementation — the "answer")
//   ❌ Prototypes/OnboardingPrototypeView.swift (my earlier cheating prototype)
//   ❌ Component bodies past the init signature
//
// Copy source: docs/mockups/personalization.html. The mockup uses
// "Let's personalize your journey" / "Finish Setup" / "Tailored for
// New Arrivals" — these are the design-stage copy decisions and take
// precedence over the v1 SwiftUI strings (a divergence to flag in §11).
//
// Spec coverage:
//   §1 Parameters  →  4 @State vars (language / status / location / duration)
//   §1 Actions     →  §1.A1 - §1.A6, comments mark each
//   §1 Layout      →  8 numbered regions (header / hero / language /
//                     status / location / duration / tip / sticky footer)
//

struct OnboardingPrototypeV2View: View {

    // MARK: Parameters (spec §1 Feature.Parameters)
    @State private var language: ABLanguage = .english
    @State private var status: ABUserStatus = .immigrantStudent
    @State private var location: ABLocation = ABLocation(city: "Sydney", state: "NSW")
    @State private var duration: ABDuration = .justLanded

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Header bar (page title)
                ABHeader(variant: .pageTitle(title: "Let's personalize your journey"))

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s8) {
                        heroIntro          // Layout 2
                        languageSection    // Layout 3
                        statusSection      // Layout 4
                        locationSection    // Layout 5
                        durationSection    // Layout 6
                        tipSection         // Layout 7
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABSpacing.s24) // reserve room for sticky footer
                }
            }

            // Layout 8 — Sticky footer overlay
            ABStickyFooter(
                primaryTitle: "Finish Setup",
                skipTitle: "Skip for now",
                onPrimary: {
                    // §1.A5: write ABUser to AppState; → §2 Home
                    // [open §11] navigation target
                },
                onSkip: {
                    // §1.A6: write default ABUser to AppState; → §2 Home
                    // [open §11] navigation target
                }
            )
        }
    }

    // MARK: Layout 2 — Hero intro
    // Spec says "hero block (headline + supporting paragraph)".
    // Copy from mockup: page title doubles as headline; subtitle is
    // "Help us tailor the best experience for you".
    private var heroIntro: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            Text("Help us tailor the best experience for you")
                .font(.abBodyMd)
                .foregroundStyle(Color.abOnSurfaceVariant)
                .lineSpacing(3)
        }
    }

    // MARK: Layout 3 — Language · single-select card grid (§1.A1)
    // Spec: "single-select card grid (6 options, 2 cols; each card: flag + language name)"
    // 6 options match ABLanguage.allCases (english/mandarin/spanish/arabic/hindi/other).
    // Component: ABSelectionCard(variant: .textCard) — text-card variant
    // since spec says "flag + language name" (compact horizontal label).
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
    // Spec: "single-select icon-card grid (4 options, 2 cols; each card: icon + label)"
    // ABSelectionCard variant .iconCard takes a `label + icon` pair.
    // The icon comes from ABUserStatus.icon (SF Symbol name) — defined
    // on the model itself per struct.md.
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
    // ABLocationPicker takes city + state literal strings; v1 component
    // is display-only (no write API exposed in init signature). §1.A3's
    // "edit city/state" effect is therefore [open §11] until the picker
    // grows a write hook.
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Location", level: .section)
            ABLocationPicker(city: location.city, state: location.state)
        }
    }

    // MARK: Layout 6 — Duration · single-select chip row (§1.A4)
    // Spec: "single-select chip row (5 options, wraps)" — 5 matches
    // ABDuration.allCases. ABChipPicker generic over `Hashable &
    // CustomStringConvertible` and binds via `@Binding selected`.
    // ABDuration's String rawValue gives us the description text for free
    // (extension required to satisfy CustomStringConvertible — usually
    // declared once at model layer).
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Duration in Australia", level: .section)
            ABChipPicker(options: ABDuration.allCases, selected: $duration)
            // Binding above implements §1.A4 directly.
        }
    }

    // MARK: Layout 7 — Tip card · informational card
    // Copy from mockup: title "Tailored for New Arrivals", body explains
    // what the profile drives. ABTipCard(title:bodyText:) signature.
    private var tipSection: some View {
        ABTipCard(
            title: "Tailored for New Arrivals",
            bodyText: "Based on your profile, we'll prioritize essential settlement guides, student visa resources, and local community connections in Sydney."
        )
    }

    // Section labels now use ABSectionTitle (added to Components/ as
    // part of the spec calibration round). No local helper needed.
}

#Preview("OnboardingPrototypeV2") {
    OnboardingPrototypeV2View()
}
