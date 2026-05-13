import SwiftUI
import ABDesignSystem

struct CommunityTab: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        NavigationStack(path: $appState.communityPath) {
            CommunityView(
                onSelectPost: { post in
                    appState.communityPath.append(Route.qaDetail(postID: post.id))
                },
                onSelectHelpRequest: { _ in
                    // §3.A3 — help-request CTA: kept inert in v1 (would route to help-thread)
                }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .qaDetail(let postID):
                    if let post = ABMockData.qaPosts.first(where: { $0.id == postID }) {
                        QADetailView(
                            post: post,
                            onMatchVolunteer: { p in
                                appState.captureOriginatingPost(p)
                                appState.communityPath.append(Route.volunteerMatch(originatingPostID: p.id))
                            },
                            onBack: {
                                popCommunityPath()
                            }
                        )
                    }
                case .volunteerMatch(let originatingPostID):
                    let originating = originatingPostID.flatMap { id in
                        ABMockData.qaPosts.first(where: { $0.id == id })
                    } ?? appState.originatingPost
                    VolunteerMatchView(
                        originatingPost: originating,
                        onStartChat: { volunteer in
                            appState.pendingVolunteer = volunteer
                            appState.selectedTab = 2
                            let conversation = ABMockData.conversations.first ?? ABMockData.conversations[0]
                            appState.messagesPath.append(Route.chat(conversationID: conversation.id))
                        },
                        onBack: {
                            popCommunityPath()
                        }
                    )
                default:
                    EmptyView()
                }
            }
        }
    }

    private func popCommunityPath() {
        @Bindable var appState = appState
        if !appState.communityPath.isEmpty {
            appState.communityPath.removeLast()
        }
    }
}
