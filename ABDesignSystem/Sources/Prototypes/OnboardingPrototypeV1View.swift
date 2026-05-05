import SwiftUI

// MARK: - OnboardingPrototypeView
//
// Throwaway sandbox copy that reimplements docs/spec.md §1 Onboarding
// strictly from the spec, alongside the existing Pages/OnboardingView.
// Lives in Sources/Prototypes/ so it shares the same module as the
// design tokens and does NOT require a separate package or public
// exports.
//
//
// Spec coverage:
//   §1 Parameters  →  4 @State vars below
//   §1 Actions     →  §1.A1–§1.A6, in-line comments mark each
//   §1 Layout      →  8 numbered regions (header / hero / language /
//                     status / location / duration / tip / footer)
//
// §1.A5 / §1.A6 navigation targets are still [open §11] in spec —
// kept as empty closures, marked TODO.

struct OnboardingPrototypeV1View: View {

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
                ABHeader(variant: .pageTitle(title: "Personalize your journey"))

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
                    .padding(.top, ABSpacing.s5)
                    .padding(.bottom, 120) // reserve room for sticky footer
                }
            }

            // Layout 8 — Sticky footer overlay
            ABStickyFooter(
                primaryTitle: "Continue",
                skipTitle: "Skip for now",
                onPrimary: {
                    // §1.A5: write ABUser to AppState; → §2 Home
                    // TODO[open §11]: navigation target
                },
                onSkip: {
                    // §1.A6: write default ABUser to AppState; → §2 Home
                    // TODO[open §11]: navigation target
                }
            )
        }
    }

    // MARK: Layout 2 — Hero intro
    private var heroIntro: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s2) {
            Text("Let's set the scene")
                .font(.abDisplayMd)
                .foregroundStyle(Color.abOnSurface)

            Text("A few quick questions help us tailor housing rules, visa info, and Q&A to your situation.")
                .font(.abBodyMd)
                .foregroundStyle(Color.abOnSurfaceVariant)
                .lineSpacing(3)
        }
    }

    // MARK: Layout 3 — Language · single-select card grid (§1.A1)
    private var languageSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Preferred language")

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
            sectionLabel("Current status")

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
            sectionLabel("Where are you based?")
            ABLocationPicker(city: location.city, state: location.state)
            // §1.A3 — ABLocationPicker exposes display only in v1;
            // edit binding [open §11] until picker exposes a write API.
        }
    }

    // MARK: Layout 6 — Duration · single-select chip row (§1.A4)
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("How long have you been here?")
            ABChipPicker(options: ABDuration.allCases, selected: $duration)
            // ABChipPicker writes via the binding above — §1.A4
        }
    }

    // MARK: Layout 7 — Tip card · informational card
    private var tipCard: some View {
        ABTipCard(
            title: "Heads-up",
            bodyText: "We use this only to filter content. You can edit any answer later in Profile."
        )
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.abLabelLg)
            .fontWeight(.semibold)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .textCase(.uppercase)
            .tracking(0.8)
    }
}

#Preview("OnboardingPrototypeV1") {
    OnboardingPrototypeV1View()
}
