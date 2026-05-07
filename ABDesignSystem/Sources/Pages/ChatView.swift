import SwiftUI

// MARK: - ChatView
//
// §8 Chat — see docs/spec.md §8.
// Context-aware 1-on-1 chat. Originating ABQAPost mounts as ABSharedContext
// at the top, persists across re-entries (§10.3).

public struct ChatView: View {

    // MARK: Parameters (spec §8)
    public let conversation: ABConversation
    public let messages: [ABChatMessage]
    public let actions: [ABContextAction]
    public let onBack: () -> Void
    public let onOpenSharedContext: ((UUID) -> Void)?

    @State private var draft: String = ""

    public init(
        conversation: ABConversation = ABMockData.conversations[0],
        messages: [ABChatMessage] = ABMockData.chatMessages,
        actions: [ABContextAction] = ABMockData.contextActions,
        onBack: @escaping () -> Void = {},
        onOpenSharedContext: ((UUID) -> Void)? = nil
    ) {
        self.conversation = conversation
        self.messages = messages
        self.actions = actions
        self.onBack = onBack
        self.onOpenSharedContext = onOpenSharedContext
    }

    private var sharedContext: ABSharedContext? {
        conversation.sharedContext ?? ABMockData.chatContext
    }

    public var body: some View {
        ZStack {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(
                    variant: .chat(
                        name: conversation.participant.displayName,
                        avatar: conversation.participant.avatarContent,
                        isOnline: conversation.participant.isOnline
                    ),
                    onBack: {
                        onBack()
                    },
                    onMenu: {
                        // chat header overflow menu — kept inert
                    }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s3) {
                        if let context = sharedContext {
                            ABSharedContextCard(
                                title: context.title,
                                linkText: context.linkText,
                                onTap: {
                                    onOpenSharedContext?(context.relatedPostID)
                                }
                            )
                        }

                        actionPillRow

                        ABDateSeparator(text: "Today")

                        messagesStream
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s3)
                    .padding(.bottom, ABSpacing.s5)
                }

                ABChatInputArea(
                    text: $draft,
                    placeholder: "Type a message…",
                    onSend: {
                        // §8.A5 — append outgoing ABChatMessage [open §11 — needs message store]
                        draft = ""
                    },
                    onPlus: {
                        // attachment [open §11]
                    }
                )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var actionPillRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ABSpacing.s2) {
                ForEach(actions) { action in
                    ABActionPill(
                        text: action.text,
                        icon: action.icon,
                        variant: action.variant == .blue ? .blue : .orange,
                        onTap: {
                            // §8.A3 — context action handler [open §11]
                        }
                    )
                }
            }
        }
    }

    private var messagesStream: some View {
        VStack(spacing: ABSpacing.s3) {
            ForEach(messages) { message in
                ABChatBubble(
                    text: message.text,
                    timestamp: message.timeString,
                    alignment: message.direction == .incoming ? .incoming : .outgoing,
                    avatarContent: message.direction == .incoming
                        ? conversation.participant.avatarContent
                        : nil
                )
            }
        }
    }
}

#Preview("Chat") {
    ChatView()
}
