import SwiftUI
import ABDesignSystem

struct OnboardingFlowView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        OnboardingView()
    }
}
