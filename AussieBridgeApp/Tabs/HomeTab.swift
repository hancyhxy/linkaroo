import SwiftUI
import ABDesignSystem

struct HomeTab: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        NavigationStack(path: $appState.homePath) {
            HomeView()
        }
    }
}
