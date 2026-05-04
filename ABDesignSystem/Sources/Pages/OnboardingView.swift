import SwiftUI

// MARK: - OnboardingView (personalization.html)
//
// Construct: this page collects the "first context" — language, current status,
// location, and time-in-Australia — so that downstream pages can filter content
// to the user's situation. See ABUser, ABLanguage, ABUserStatus, ABDuration.

struct OnboardingView: View {
    // Local form state
    @State private var language: ABLanguage = .english
    @State private var status: ABUserStatus = .immigrantStudent
    @State private var duration: ABDuration = .justLanded
    @State private var location = ABLocation(city: "Sydney", state: "NSW")

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Personalize your journey"))

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s8) {
                        heroIntro
                        languageSection
                        statusSection
                        locationSection
                        durationSection
                        tipSection
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s5)
                    .padding(.bottom, 120) // Reserve room for sticky footer
                }
            }

            ABStickyFooter(
                primaryTitle: "Continue",
                skipTitle: "Skip for now",
                onPrimary: {},
                onSkip: {}
            )
        }
    }

    // MARK: - Hero
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

    // MARK: - Language
    private var languageSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Preferred language")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: ABSpacing.s3),
                          GridItem(.flexible(), spacing: ABSpacing.s3)],
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

    // MARK: - Status
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Current status")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: ABSpacing.s3),
                          GridItem(.flexible(), spacing: ABSpacing.s3)],
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

    // MARK: - Location
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("Where are you based?")
            ABLocationPicker(city: location.city, state: location.state)
        }
    }

    // MARK: - Duration
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s3) {
            sectionLabel("How long have you been here?")
            ABChipPicker(options: ABDuration.allCases, selected: $duration)
        }
    }

    // MARK: - Tip
    private var tipSection: some View {
        ABTipCard(
            title: "Heads-up",
            bodyText: "We use this only to filter content. You can edit any answer later in Profile."
        )
    }

    // MARK: - Section Label
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.abLabelLg)
            .fontWeight(.semibold)
            .foregroundStyle(Color.abOnSurfaceVariant)
            .textCase(.uppercase)
            .tracking(0.8)
    }
}

// MARK: - ABDuration CustomStringConvertible (for ABChipPicker)

extension ABDuration: CustomStringConvertible {
    public var description: String { rawValue }
}

// MARK: - Preview

#Preview("Onboarding") {
    OnboardingView()
}
