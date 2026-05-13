import SwiftUI
import ABDesignSystem

struct MessagesTab: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        NavigationStack(path: $appState.messagesPath) {
            MessageListView(
                onSelectConversation: { convo in
                    appState.messagesPath.append(Route.chat(conversationID: convo.id))
                }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .chat(let conversationID):
                    if let convo = ABMockData.conversations.first(where: { $0.id == conversationID }) {
                        ChatView(
                            conversation: convo,
                            onBack: {
                                popMessagesPath()
                            },
                            onOpenSharedContext: { postID in
                                // 跨 tab 跳回 Home tab + push QA detail
                                appState.selectedTab = 0
                                appState.homePath.append(Route.qaDetail(postID: postID))
                            }
                        )
                    }
                default:
                    EmptyView()
                }
            }
        }
    }

    private func popMessagesPath() {
        @Bindable var appState = appState
        if !appState.messagesPath.isEmpty {
            appState.messagesPath.removeLast()
        }
    }
}
