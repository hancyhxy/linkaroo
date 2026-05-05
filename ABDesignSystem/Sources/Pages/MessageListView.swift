import SwiftUI

// MARK: - MessageListView
//
// §7 Message List — see docs/spec.md §7.
// Inbox / re-entry surface; preserves ABSharedContext on re-open.

enum MessageSegment: String, CaseIterable, CustomStringConvertible {
    case all = "All"
    case unread = "Unread"

    public var description: String { rawValue }
}

public struct MessageListView: View {
    public init() {}


    // MARK: Parameters (spec §7)
    @State private var segment: MessageSegment = .all
    @State private var selectedTab: ABTab = .community

    private var conversations: [ABConversation] {
        switch segment {
        case .all:    return ABMockData.conversations
        case .unread: return ABMockData.conversations.filter(\.isUnread)
        }
    }

    private var unreadCount: Int {
        ABMockData.conversations.filter(\.isUnread).count
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Messages"), onBack: {
                    // §7.A1 — back [open §11]
                })

                ScrollView {
                    VStack(spacing: ABSpacing.s3) {
                        ABSegmentedControl(
                            options: MessageSegment.allCases,
                            selected: $segment,
                            badgeCounts: [.unread: unreadCount]
                        )
                        .padding(.horizontal, ABLayout.pagePadding)

                        VStack(spacing: 0) {
                            ForEach(conversations) { convo in
                                ABMessageItem(
                                    data: ABMessageItemData(
                                        id: convo.id.uuidString,
                                        name: convo.participant.displayName,
                                        preview: convo.lastMessage,
                                        timeAgo: convo.timeAgoString,
                                        avatarContent: convo.participant.avatarURL == nil
                                            ? .initials(convo.participant.initials)
                                            : .image(convo.participant.avatarURL),
                                        isOnline: convo.participant.isOnline,
                                        isUnread: convo.isUnread
                                    ),
                                    onTap: {
                                        // §7.A3 — → §8 Chat preserving sharedContext [open §11]
                                    }
                                )
                                .padding(.horizontal, ABLayout.pagePadding)

                                if convo.id != conversations.last?.id {
                                    Divider()
                                        .background(Color.abBorderHairline.opacity(0.4))
                                        .padding(.horizontal, ABLayout.pagePadding)
                                }
                            }
                        }
                    }
                    .padding(.top, ABSpacing.s4)
                    .padding(.bottom, ABLayout.tabBarHeight + ABSpacing.s4)
                }
            }

            ABTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview("Message List") {
    MessageListView()
}
