import SwiftUI

// MARK: - MessageListPrototypeV4View
//
// EXPERIMENT (V4): spec-driven re-derivation of §7 Message List.
// First spec-driven prototype for this page.
//
// What I read to write this file:
//   ✅ docs/spec.md §7 (Overview / Parameters / Actions / Layout)
//   ✅ docs/spec.md §0.4 (`segmented control`, `message row list`)
//   ✅ docs/spec.md §10.3 (Shared Context — re-entry preserves it)
//   ✅ docs/design.md
//   ✅ docs/struct.md §4 (ABConversation, ABSharedContext)
//   ✅ docs/mockups/message.html (real copy + visual prior)
//   ✅ ABColors / ABTypography / ABSpacing / ABLayout tokens
//   ✅ Components/*.swift first ~40 lines (init signatures only)
//   ✅ Models/ABModels.swift + ABMockData.conversations
//
// What I deliberately did NOT read:
//   ❌ Pages/MessageListView.swift (v1)
//   ❌ Component bodies past the init signature
//
// SPEC GAP markers found this round:
//
//   [GAP-24] *** load-bearing *** mockup message.html shows the
//     header as "Community" and the segmented control as
//     "Discussions / Messages" (with unread badge on Messages) —
//     i.e. mockup §7 is the *Messages segment* of §3 Community,
//     not a standalone "Messages" page. spec models §7 standalone.
//     Cross-check with [GAP-16]: same evidence — mockup folds §7
//     into §3 segmented hub, spec keeps them as distinct pages.
//
//     Following spec for this prototype (§7 standalone) but the
//     fact that **two pages worth of mockup share one screen**
//     means the spec model is wrong. Recommend resolving toward
//     mockup: §7 becomes "§3 Community → Messages segment" and
//     gets removed as a standalone page section in spec.md.
//
//   [GAP-25] mockup §7 has NO header back chevron — it's reached
//     as a tab inside Community, not pushed onto a navigation
//     stack. spec models a back-bar with back chevron, [open §11]
//     entry point. Following spec.
//
//   [GAP-26] mockup §7 has bottom tab bar (Home/Community/Profile);
//     spec/v1 has no tab bar. mockup wins.
//

private enum MessageSegmentV4: String, CaseIterable, CustomStringConvertible {
    case all = "All"
    case unread = "Unread"

    var description: String { rawValue }
}

struct MessageListPrototypeV4View: View {

    // MARK: Parameters (spec §7 Feature.Parameters)
    @State private var segment: MessageSegmentV4 = .all
    @State private var selectedTab: ABTab = .community  // [GAP-26] mockup-driven

    private var conversations: [ABConversation] {
        switch segment {
        case .all:    return ABMockData.conversations
        case .unread: return ABMockData.conversations.filter(\.isUnread)
        }
    }

    private var unreadCount: Int {
        ABMockData.conversations.filter(\.isUnread).count
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.abSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                // Layout 1 — Header bar (page-title with back)
                ABHeader(variant: .pageTitle(title: "Messages"), onBack: {
                    // §7.A1 — back [open §11]
                })

                ScrollView {
                    VStack(spacing: ABSpacing.s3) {
                        // Layout 2 — Segment selector (§7.A2)
                        ABSegmentedControl(
                            options: MessageSegmentV4.allCases,
                            selected: $segment,
                            badgeCounts: [.unread: unreadCount]
                        )
                        .padding(.horizontal, ABLayout.pagePadding)

                        // Layout 3 — Conversations list (§7.A3)
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
                                        // §7.A3 — → §8 Chat preserving sharedContext
                                        // [open §11 — propagation mechanism]
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

            // Layout 4 — Bottom tab bar overlay [GAP-26 mockup-driven]
            ABTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview("MessageListPrototypeV4") {
    MessageListPrototypeV4View()
}
