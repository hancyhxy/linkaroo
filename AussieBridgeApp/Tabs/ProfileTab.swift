import SwiftUI
import ABDesignSystem

struct ProfileTab: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: ABSpacing.s5) {
                    ABPageHero(
                        headline: "Your Profile",
                        subtitle: "Captured from onboarding"
                    )

                    if let user = appState.currentUser {
                        ProfileRow(label: "Name", value: user.displayName)
                        ProfileRow(label: "Username", value: user.username)
                        ProfileRow(label: "Language", value: "\(user.preferredLanguage.flagIcon)  \(user.preferredLanguage.rawValue)")
                        ProfileRow(label: "Status", value: user.currentStatus.rawValue)
                        if let location = user.location {
                            ProfileRow(label: "Location", value: location.displayString)
                        }
                        ProfileRow(label: "Duration in AU", value: user.durationInAustralia.rawValue)
                    } else {
                        Text("No profile yet — finish onboarding first.")
                            .font(.abBodyMd)
                            .foregroundStyle(Color.abOnSurfaceVariant)
                    }
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.top, ABSpacing.s5)
                .padding(.bottom, ABSpacing.s12)
            }
            .background(Color.abSurface.ignoresSafeArea())
        }
    }
}

private struct ProfileRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s1) {
            Text(label.uppercased())
                .font(.abLabelSm)
                .tracking(0.8)
                .foregroundStyle(Color.abOnSurfaceVariant)
            Text(value)
                .font(.abBodyMd)
                .foregroundStyle(Color.abOnSurface)
        }
    }
}
