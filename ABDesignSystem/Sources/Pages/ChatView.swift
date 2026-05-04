import SwiftUI

// MARK: - ChatView (chat.html)
//
// Construct: 1-on-1 conversation thread. The Shared Context card pinned to the top
// references the originating ABQAPost, the Action Pills surface ABContextAction
// shortcuts (share profile / suggest call), and the message list renders
// ABChatMessage on either side of the bubble.

struct ChatView: View {
    let conversation: ABConversation
    let messages: [ABChatMessage]
    let actions: [ABContextAction]

    init(
        conversation: ABConversation = ABMockData.conversations[0],
        messages: [ABChatMessage] = ABMockData.chatMessages,
        actions: [ABContextAction] = ABMockData.contextActions
    ) {
        self.conversation = conversation
        self.messages = messages
        self.actions = actions
    }

    @State private var draft: String = ""

    var body: some View {
        ZStack {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                ABHeader(variant: .chat(
                    name: conversation.participant.displayName,
                    avatarURL: conversation.participant.avatarURL,
                    isOnline: conversation.participant.isOnline
                ))

                ScrollView {
                    VStack(spacing: ABSpacing.s3) {
                        sharedContextSection
                        actionPillsSection
                        ABDateSeparator(text: "Today")
                        messagesSection
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s3)
                    .padding(.bottom, ABSpacing.s5)
                }

                ABChatInputArea(
                    text: $draft,
                    placeholder: "Type a message…",
                    onSend: { draft = "" }
                )
            }
        }
    }

    // MARK: - Shared context
    @ViewBuilder
    private var sharedContextSection: some View {
        if let context = conversation.sharedContext ?? ABMockData.chatContext as ABSharedContext? {
            ABSharedContextCard(title: context.title, linkText: context.linkText)
        }
    }

    // MARK: - Action pills
    private var actionPillsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ABSpacing.s2) {
                ForEach(actions) { action in
                    ABActionPill(
                        text: action.text,
                        icon: action.icon,
                        variant: action.variant == .blue ? .blue : .orange
                    )
                }
            }
        }
    }

    // MARK: - Messages
    private var messagesSection: some View {
        VStack(spacing: ABSpacing.s3) {
            ForEach(messages) { message in
                ABChatBubble(
                    text: message.text,
                    timestamp: message.timeString,
                    alignment: message.direction == .incoming ? .incoming : .outgoing,
                    avatarContent: message.direction == .incoming
                        ? .initials(conversation.participant.initials)
                        : nil
                )
            }
        }
    }
}

// MARK: - Preview

#Preview("Chat") {
    ChatView()
}
