import SwiftUI
import ABDesignSystem

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        TabView(selection: $appState.selectedTab) {
            HomeTab()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            CommunityTab()
                .tabItem { Label("Community", systemImage: "person.3.fill") }
                .tag(1)
            MessagesTab()
                .tabItem { Label("Messages", systemImage: "message.fill") }
                .tag(2)
            ProfileTab()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(3)
        }
        .tint(.abPrimaryBright)
    }
}
