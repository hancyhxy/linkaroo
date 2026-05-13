import SwiftUI
import ABDesignSystem

struct HomeTab: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        NavigationStack(path: $appState.homePath) {
            HomeView(
                onSelectCategory: { category in
                    appState.homePath.append(Route.qaList(category: category))
                },
                onSelectFeaturedGuide: { _ in
                    // featured guide 这一轮不接详情页（spec §10.4 之外）
                },
                onSelectGuide: { _ in
                    // recommendation cards 同上
                }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .qaList(let category):
                    QAListView(
                        category: category,
                        onSelectPost: { post in
                            appState.homePath.append(Route.qaDetail(postID: post.id))
                        },
                        onAskQuestion: {
                            // ask-a-question entry — kept inert for v1
                        },
                        onBack: {
                            popHomePath()
                        }
                    )
                case .qaDetail(let postID):
                    if let post = ABMockData.qaPosts.first(where: { $0.id == postID }) {
                        QADetailView(
                            post: post,
                            onMatchVolunteer: { p in
                                appState.captureOriginatingPost(p)
                                appState.homePath.append(Route.volunteerMatch(originatingPostID: p.id))
                            },
                            onBack: {
                                popHomePath()
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
                            // 跨 tab 跳转：切到 Messages tab + 推 Chat
                            appState.pendingVolunteer = volunteer
                            appState.selectedTab = 2
                            // 在 messagesPath 推一个由 mockup 的第一个对话作为占位会话
                            // (真实实现需要根据 volunteer 创建/查找 ABConversation)
                            let conversation = ABMockData.conversations.first ?? ABMockData.conversations[0]
                            appState.messagesPath.append(Route.chat(conversationID: conversation.id))
                        },
                        onBack: {
                            popHomePath()
                        }
                    )
                default:
                    EmptyView()
                }
            }
        }
    }

    private func popHomePath() {
        @Bindable var appState = appState
        if !appState.homePath.isEmpty {
            appState.homePath.removeLast()
        }
    }
}
