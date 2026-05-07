import SwiftUI

// MARK: - ChatPrototypeV4View
//
// EXPERIMENT (V4): spec-driven re-derivation of §8 Chat.
// First spec-driven prototype for this page.
//
// What I read to write this file:
//   ✅ docs/spec.md §8 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0.4 (`shared context card`, `action pill row`,
//                        `chat thread`, `chat input area`)
//   ✅ docs/spec.md §10.3 (Shared Context mounting — consumer endpoint)
//   ✅ docs/design.md
//   ✅ docs/struct.md §4 (ABConversation, ABChatMessage, ABMessageDirection,
//                        ABSharedContext, ABContextAction*, ABTranslation)
//   ✅ docs/mockups/chat.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABLayout tokens
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift + ABMockData (conversations, chatMessages,
//                                          contextActions, chatContext)
//
// What I deliberately did NOT read:
//   ❌ Pages/ChatView.swift (v1)
//   ❌ Component bodies past the init signature
//
// SPEC GAP markers found this round:
//
//   [GAP-13] Spec §8 Layout-1 says "header bar (chat variant)". §0.4
//     vocabulary doesn't list `chat variant` — only `back bar`,
//     `header bar` are in there. Resolved by reading ABHeader.swift's
//     enum: `.chat(name, avatar, isOnline)` is a real variant.
//     spec needs to add "chat variant" to its vocabulary, or use the
//     §0.4 standard term explicitly.
//
//   [GAP-14] Spec §8 says chat input area is "pinned to bottom,
//     sibling to (not inside) the scroll view". Confirmed by reading
//     ABChatInputArea — it has a hairline + abSurfaceCard background
//     and expects to live below the ScrollView in a VStack. Wired
//     accordingly.
//
//   [GAP-15] §8.A2 spec says "tap shared context card → return to
//     §5 Q&A Detail by relatedPostID". ABSharedContextCard already
//     has `onTap`; mechanism still [open §11].
//

struct ChatPrototypeV4View: View {

    // MARK: Parameters (spec §8 Feature.Parameters)
    let conversation: ABConversation
    let messages: [ABChatMessage]
    let actions: [ABContextAction]

    @State private var draft: String = ""

    init(
        conversation: ABConversation = ABMockData.conversations[0],
        messages: [ABChatMessage] = ABMockData.chatMessages,
        actions: [ABContextAction] = ABMockData.contextActions
    ) {
        self.conversation = conversation
        self.messages = messages
        self.actions = actions
    }

    private var sharedContext: ABSharedContext? {
        conversation.sharedContext ?? ABMockData.chatContext
    }

    var body: some View {
        ZStack {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Header bar (chat variant)
                ABHeader(variant: .chat(
                    name: conversation.participant.displayName,
                    avatar: conversation.participant.avatarContent,
                    isOnline: conversation.participant.isOnline
                ),
                onBack: {
                    // §8.A1 — back [open §11]
                },
                onMenu: {
                    // mockup shows ellipsis menu in chat header
                })

                ScrollView {
                    VStack(alignment: .leading, spacing: ABSpacing.s3) {
                        // Layout 2 — Shared context section
                        if let context = sharedContext {
                            ABSharedContextCard(
                                title: context.title,
                                linkText: context.linkText,
                                onTap: {
                                    // §8.A2 — return to §5 by relatedPostID [open §11]
                                }
                            )
                        }

                        // Layout 3 — Action pill row
                        actionPillRow

                        // Layout 4 — Date separator
                        ABDateSeparator(text: "Today")

                        // Layout 5 — Chat thread bubble stream
                        messagesStream
                    }
                    .padding(.horizontal, ABLayout.pagePadding)
                    .padding(.top, ABSpacing.s3)
                    .padding(.bottom, ABSpacing.s5)
                }

                // Layout 6 — Chat input area pinned to bottom
                ABChatInputArea(
                    text: $draft,
                    placeholder: "Type a message…",
                    onSend: {
                        // §8.A5 — append outgoing ABChatMessage
                        // (omitted in this prototype — would need
                        // mutable @State [ABChatMessage])
                        draft = ""
                    },
                    onPlus: {
                        // mockup shows attachment button [open §11]
                    }
                )
            }
        }
    }

    // MARK: Layout 3 — Action pill row (§8.A3)
    //
    // Spec: "horizontal scroll of ABActionPill items — variant maps to
    // blue / orange". ABContextAction.variant is `.blue / .orange`,
    // ABActionPill takes `.blue / .orange` — direct mapping.
    private var actionPillRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ABSpacing.s2) {
                ForEach(actions) { action in
                    ABActionPill(
                        text: action.text,
                        icon: action.icon,
                        variant: action.variant == .blue ? .blue : .orange,
                        onTap: {
                            // §8.A3 — per-pill effect [open §11]
                        }
                    )
                }
            }
        }
    }

    // MARK: Layout 5 — Bubble stream
    //
    // Spec: "alignment driven by `direction`; incoming bubbles render
    // avatar fallback initials". Direct.
    private var messagesStream: some View {
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

#Preview("ChatPrototypeV4") {
    ChatPrototypeV4View()
}
