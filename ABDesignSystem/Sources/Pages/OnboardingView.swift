import SwiftUI

// MARK: - OnboardingView
//
// §1 Onboarding — see docs/spec.md §1.
// Identity capture form — used both for first-launch (write a fresh ABUser)
// and for §9 Profile edit (re-enter with `prefilledUser` to load existing
// fields). Single-source identity capture, see spec §11.4.

public struct OnboardingView: View {
    public let prefilledUser: ABUser?
    public let onFinish: (ABUser) -> Void
    public let onSkip: () -> Void
    public let onBack: (() -> Void)?

    public init(
        prefilledUser: ABUser? = nil,
        onFinish: @escaping (ABUser) -> Void = { _ in },
        onSkip: @escaping () -> Void = {},
        onBack: (() -> Void)? = nil
    ) {
        self.prefilledUser = prefilledUser
        self.onFinish = onFinish
        self.onSkip = onSkip
        self.onBack = onBack

        // Initialize @State from prefilledUser if present (edit mode).
        _language = State(initialValue: prefilledUser?.preferredLanguage ?? .english)
        _status = State(initialValue: prefilledUser?.currentStatus ?? .immigrantStudent)
        _location = State(initialValue: prefilledUser?.location ?? ABLocation(city: "Sydney", state: "NSW"))
        _duration = State(initialValue: prefilledUser?.durationInAustralia ?? .justLanded)
    }

    private var isEditMode: Bool { prefilledUser != nil }

    // MARK: Parameters (spec §1)
    @State private var language: ABLanguage
    @State private var status: ABUserStatus
    @State private var location: ABLocation
    @State private var duration: ABDuration

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s8) {
                    ABPageHero(
                        headline: isEditMode ? "Update your profile" : "Let's personalize your journey",
                        subtitle: isEditMode ? "Refine your answers — we'll re-rank guides, Q&A, and matches against the new profile." : "Help us tailor the best experience for you"
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

            if let onBack {
                ABBackBar(title: isEditMode ? "Edit Profile" : "Profile Setup", onBack: onBack)
            }

            VStack {
                Spacer()
                ABStickyFooter(
                    primaryTitle: isEditMode ? "Save changes" : "Finish Setup",
                    skipTitle: isEditMode ? "Cancel" : "Skip for now",
                    onPrimary: {
                        // §1.A5 — write/update ABUser to AppState.
                        // In edit mode we preserve the existing displayName/username;
                        // in first-launch we use placeholder values that v2 onboarding
                        // can later prompt for explicitly.
                        let user = ABUser(
                            displayName: prefilledUser?.displayName ?? "You",
                            username: prefilledUser?.username ?? "u/you",
                            preferredLanguage: language,
                            currentStatus: status,
                            location: location,
                            durationInAustralia: duration
                        )
                        onFinish(user)
                    },
                    onSkip: {
                        // §1.A6 — first-launch: skip with default ABUser.
                        //         edit mode: cancel without saving (route back via onSkip closure).
                        onSkip()
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
