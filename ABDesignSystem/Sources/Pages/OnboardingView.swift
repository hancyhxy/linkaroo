import SwiftUI

// MARK: - OnboardingView
//
// §1 Onboarding — see docs/spec.md §1.
// First-launch identity capture. Captured ABUser drives all downstream filtering.

public struct OnboardingView: View {
    public init() {}


    // MARK: Parameters (spec §1)
    @State private var language: ABLanguage = .english
    @State private var status: ABUserStatus = .immigrantStudent
    @State private var location: ABLocation = ABLocation(city: "Sydney", state: "NSW")
    @State private var duration: ABDuration = .justLanded

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s8) {
                    ABPageHero(
                        headline: "Let's personalize your journey",
                        subtitle: "Help us tailor the best experience for you"
                    )

                    languageSection
                    statusSection
                    locationSection
                    durationSection
                    tipCard
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, (ABLayout.headerHeight - 8) + ABSpacing.s4)
                .padding(.bottom, ABSpacing.s24)
            }

            ABBackBar(title: "Profile Setup", onBack: {
                // §1 back navigation [open §11]
            })

            VStack {
                Spacer()
                ABStickyFooter(
                    primaryTitle: "Finish Setup",
                    skipTitle: "Skip for now",
                    onPrimary: {
                        // §1.A5 — write ABUser to AppState; → §2 Home [open §11]
                    },
                    onSkip: {
                        // §1.A6 — write default ABUser to AppState; → §2 Home [open §11]
                    }
                )
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    // MARK: §1.A1 — Language
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
                        language = lang
                    }
                }
            }
        }
    }

    // MARK: §1.A2 — Status
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
                        status = st
                    }
                }
            }
        }
    }

    // MARK: §1.A3 — Location
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Location", level: .section)
            ABLocationPicker(city: location.city, state: location.state)
            // §1.A3 — picker is display-only in v1; edit hook [open §11]
        }
    }

    // MARK: §1.A4 — Duration
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            ABSectionTitle("Duration in Australia", level: .section)
            ABChipPicker(options: ABDuration.allCases, selected: $duration)
        }
    }

    private var tipCard: some View {
        ABTipCard(
            title: "Tailored for New Arrivals",
            bodyText: "Based on your profile, we'll prioritize essential settlement guides, student visa resources, and local community connections in Sydney."
        )
    }
}

#Preview("Onboarding") {
    OnboardingView()
}
