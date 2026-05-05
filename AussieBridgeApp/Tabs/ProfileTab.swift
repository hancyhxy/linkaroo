import SwiftUI
import ABDesignSystem

struct ProfileTab: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        NavigationStack(path: $appState.profilePath) {
            ProfileView(
                user: appState.currentUser,
                onEdit: {
                    appState.profilePath.append(Route.editProfile)
                }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .editProfile:
                    OnboardingView(
                        prefilledUser: appState.currentUser,
                        onFinish: { updatedUser in
                            appState.updateUser(updatedUser)
                            popProfilePath()
                        },
                        onSkip: {
                            // edit mode: skip is a no-op; pop back to Profile.
                            popProfilePath()
                        },
                        onBack: {
                            popProfilePath()
                        }
                    )
                default:
                    EmptyView()
                }
            }
        }
    }

    private func popProfilePath() {
        @Bindable var appState = appState
        if !appState.profilePath.isEmpty {
            appState.profilePath.removeLast()
        }
    }
}
