import SwiftUI

// MARK: - Chat Bubble Alignment

public enum ABChatAlignment {
    case incoming
    case outgoing
}

// MARK: - ABChatBubble

public struct ABChatBubble: View {
    public let text: String
    public let timestamp: String
    public var alignment: ABChatAlignment = .incoming
    public var avatarContent: ABAvatarContent? = nil

    public var body: some View {
        HStack(alignment: .bottom, spacing: ABSpacing.s2) {
            if alignment == .incoming {
                incomingLayout
            } else {
                outgoingLayout
            }
        }
        .padding(.bottom, ABSpacing.s1)
    }

    // MARK: - Incoming (left-aligned)

    private var incomingLayout: some View {
        HStack(alignment: .bottom, spacing: ABSpacing.s2) {
            if let avatar = avatarContent {
                ABAvatar(content: avatar, size: ABAvatarSize.micro)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurface)
                    .padding(.horizontal, ABSpacing.s4)
                    .padding(.vertical, ABSpacing.s3)
                    .background(Color.abSurfaceCard)
                    .clipShape(ChatBubbleShape(alignment: .incoming))

                Text(timestamp)
                    .font(.abCaption)
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }

            Spacer(minLength: 60)
        }
    }

    // MARK: - Outgoing (right-aligned)

    private var outgoingLayout: some View {
        HStack(alignment: .bottom, spacing: ABSpacing.s2) {
            Spacer(minLength: 60)

            VStack(alignment: .trailing, spacing: 4) {
                Text(text)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurface)
                    .padding(.horizontal, ABSpacing.s4)
                    .padding(.vertical, ABSpacing.s3)
                    .background(Color.abChatOutgoing)
                    .clipShape(ChatBubbleShape(alignment: .outgoing))

                Text(timestamp)
                    .font(.abCaption)
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }
        }
    }
}

// MARK: - Custom Bubble Shape with Asymmetric Corners

struct ChatBubbleShape: Shape {
    public let alignment: ABChatAlignment
    public let cornerRadius: CGFloat = 16
    public let flatCorner: CGFloat = 6

    public func path(in rect: CGRect) -> Path {
        let tl: CGFloat
        let tr: CGFloat
        let bl: CGFloat
        let br: CGFloat

        switch alignment {
        case .incoming:
            tl = cornerRadius
            tr = cornerRadius
            bl = flatCorner     // flat bottom-left for incoming
            br = cornerRadius
        case .outgoing:
            tl = cornerRadius
            tr = cornerRadius
            bl = cornerRadius
            br = flatCorner     // flat bottom-right for outgoing
        }

        return Path { path in
            path.move(to: CGPoint(x: tl, y: 0))
            path.addLine(to: CGPoint(x: rect.width - tr, y: 0))
            path.addArc(tangent1End: CGPoint(x: rect.width, y: 0),
                        tangent2End: CGPoint(x: rect.width, y: tr),
                        radius: tr)
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - br))
            path.addArc(tangent1End: CGPoint(x: rect.width, y: rect.height),
                        tangent2End: CGPoint(x: rect.width - br, y: rect.height),
                        radius: br)
            path.addLine(to: CGPoint(x: bl, y: rect.height))
            path.addArc(tangent1End: CGPoint(x: 0, y: rect.height),
                        tangent2End: CGPoint(x: 0, y: rect.height - bl),
                        radius: bl)
            path.addLine(to: CGPoint(x: 0, y: tl))
            path.addArc(tangent1End: CGPoint(x: 0, y: 0),
                        tangent2End: CGPoint(x: tl, y: 0),
                        radius: tl)
        }
    }
}

// MARK: - Preview

#Preview("Chat Bubbles") {
    VStack(spacing: 12) {
        ABChatBubble(
            text: "Hello! I see you're looking into renting rights in Sydney. How can I help?",
            timestamp: "10:24 AM",
            alignment: .incoming,
            avatarContent: .initials("SL")
        )

        ABChatBubble(
            text: "Thanks Sarah! I'm specifically worried about the 90-day notice period.",
            timestamp: "10:25 AM",
            alignment: .outgoing
        )
    }
    .padding()
    .background(Color.abSurface)
}
