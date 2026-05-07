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
    public let onSelectConversation: (ABConversation) -> Void

    public init(
        onSelectConversation: @escaping (ABConversation) -> Void = { _ in }
    ) {
        self.onSelectConversation = onSelectConversation
    }

    // MARK: Parameters (spec §7)
    @State private var segment: MessageSegment = .all

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
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

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
                                    avatarContent: convo.participant.avatarContent,
                                    isOnline: convo.participant.isOnline,
                                    isUnread: convo.isUnread
                                ),
                                onTap: {
                                    onSelectConversation(convo)
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
                .padding(.bottom, ABSpacing.s8)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Messages", showBack: false))
            }
        }
    }
}

#Preview("Message List") {
    MessageListView()
}
