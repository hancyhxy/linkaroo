import SwiftUI

// MARK: - Message Item Data

public struct ABMessageItemData: Identifiable {
    public let id: String
    public let name: String
    public let preview: String
    public let timeAgo: String
    public var avatarContent: ABAvatarContent = .initials("?")
    public var isOnline: Bool = false
    public var isUnread: Bool = false
}

// MARK: - ABMessageItem

public struct ABMessageItem: View {
    public let data: ABMessageItemData
    public var onTap: (() -> Void)? = nil

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: ABSpacing.s3) {
                // Avatar
                ABAvatar(
                    content: data.avatarContent,
                    size: ABAvatarSize.lg,
                    showOnline: data.isOnline
                )

                // Content
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(data.name)
                            .font(data.isUnread ? .abTitleSm : .abBodySm)
                            .fontWeight(data.isUnread ? .bold : .medium)
                            .foregroundStyle(data.isUnread ? Color.abOnSurface : Color.abOnSurfaceVariant)

                        Spacer()

                        Text(data.timeAgo)
                            .font(.abCaption)
                            .foregroundStyle(Color.abOnSurfaceDisabled)
                    }

                    Text(data.preview)
                        .font(.abBodySm)
                        .foregroundStyle(data.isUnread ? .abOnSurfaceVariant : Color.abOnSurfaceDisabled)
                        .lineLimit(1)
                }

                // Unread dot
                if data.isUnread {
                    Circle()
                        .fill(Color.abStatusUnread)
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.horizontal, ABSpacing.s2)
            .padding(.vertical, ABSpacing.s3)
            .background(
                data.isUnread
                    ? Color.abAccentSky.opacity(0.4)
                    : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: ABRadius.lg))
        }
        .buttonStyle(ABPressStyle())
    }
}

// MARK: - Preview

#Preview("Message Items") {
    VStack(spacing: 4) {
        ABMessageItem(data: ABMessageItemData(
            id: "1", name: "David O.",
            preview: "Thanks for the engineering intern...",
            timeAgo: "2 min ago",
            avatarContent: .initials("DO"),
            isOnline: true, isUnread: true
        ))
        ABMessageItem(data: ABMessageItemData(
            id: "2", name: "Rahul K.",
            preview: "Can you send me the link for that ...",
            timeAgo: "45 min ago",
            avatarContent: .initials("RK"),
            isUnread: true
        ))
        ABMessageItem(data: ABMessageItemData(
            id: "3", name: "Sarah M.",
            preview: "The winter tips you gave last year are ...",
            timeAgo: "Yesterday",
            avatarContent: .initials("SM")
        ))
    }
    .padding()
    .background(Color.abSurface)
}
