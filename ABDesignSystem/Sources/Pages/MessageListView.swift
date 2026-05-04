import SwiftUI

// MARK: - MessageListView (message.html)
//
// Construct: list of ABConversation grouped by an "All / Unread" segment.
// Each row is rendered through ABMessageItem, with avatar online-state and
// unread badge driven by `ABConversation.isUnread` and `participant.isOnline`.

enum MessageSegment: String, CaseIterable, CustomStringConvertible {
    case all = "All"
    case unread = "Unread"

    var description: String { rawValue }
}

struct MessageListView: View {
    @State private var segment: MessageSegment = .all

    var conversations: [ABConversation] {
        switch segment {
        case .all: return ABMockData.conversations
        case .unread: return ABMockData.conversations.filter(\.isUnread)
        }
    }

    var unreadCount: Int { ABMockData.conversations.filter(\.isUnread).count }

    var body: some View {
        ZStack {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .pageTitle(title: "Messages"))

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
                                ABMessageItem(data: convo.toItemData())
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
            }
        }
    }
}

// MARK: - Adapter

extension ABConversation {
    func toItemData() -> ABMessageItemData {
        ABMessageItemData(
            id: id.uuidString,
            name: participant.displayName,
            preview: lastMessage,
            timeAgo: timeAgoString,
            avatarContent: participant.avatarURL == nil
                ? .initials(participant.initials)
                : .image(participant.avatarURL),
            isOnline: participant.isOnline,
            isUnread: isUnread
        )
    }
}

// MARK: - Preview

#Preview("Message List") {
    MessageListView()
}
