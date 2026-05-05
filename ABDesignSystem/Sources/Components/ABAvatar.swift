import SwiftUI

// MARK: - Avatar Content Type

public enum ABAvatarContent {
    /// Remote or local image
    case image(URL?)
    /// Fallback initials with gradient background
    case initials(String)
}

// MARK: - ABAvatar View

public struct ABAvatar: View {
    public let content: ABAvatarContent
    public var size: CGFloat = ABAvatarSize.md
    public var showOnline: Bool = false

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarImage
                .frame(width: size, height: size)
                .clipShape(Circle())

            if showOnline {
                onlineIndicator
            }
        }
    }

    // MARK: - Avatar Image

    @ViewBuilder
    private var avatarImage: some View {
        switch content {
        case .image(let url):
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        fallbackView
                    case .empty:
                        shimmerPlaceholder
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                fallbackView
            }

        case .initials(let text):
            ZStack {
                LinearGradient.abAvatarFallback
                Text(text.prefix(2).uppercased())
                    .font(.system(size: initialsFontSize, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: - Online Indicator

    private var onlineIndicator: some View {
        let indicatorSize: CGFloat = size >= ABAvatarSize.lg ? 14 : 10
        return Circle()
            .fill(Color.abStatusOnline)
            .frame(width: indicatorSize, height: indicatorSize)
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
    }

    // MARK: - Helpers

    private var initialsFontSize: CGFloat {
        switch size {
        case ..<32: return 9
        case 32..<48: return 12
        case 48..<56: return 14
        default: return 18
        }
    }

    private var fallbackView: some View {
        ZStack {
            Color.abSurfaceContainer
            Image(systemName: "person.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(Color.abOnSurfaceDisabled)
        }
    }

    private var shimmerPlaceholder: some View {
        Color.abSurfaceContainer
    }
}

// MARK: - Preview

#Preview("Avatar Variants") {
    HStack(spacing: 16) {
        // Image avatar with online dot
        ABAvatar(content: .image(nil), size: ABAvatarSize.lg, showOnline: true)

        // Initials avatar
        ABAvatar(content: .initials("RK"), size: ABAvatarSize.lg)

        // Small avatar
        ABAvatar(content: .initials("ML"), size: ABAvatarSize.sm)

        // Micro avatar (chat)
        ABAvatar(content: .initials("S"), size: ABAvatarSize.micro)
    }
    .padding()
}
