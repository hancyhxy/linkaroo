import SwiftUI

// MARK: - Button Style

public enum ABButtonVariant {
    /// Gradient fill (primary-gradient), white text, blue shadow
    case primaryGradient
    /// White bg, primary-bright border, primary text
    case secondary
    /// Transparent bg, muted text
    case text
    /// White bg on gradient background (inverted CTA)
    case inverted
}

// MARK: - Button Size

public enum ABButtonSize {
    /// 56-64pt height — hero CTAs, main actions
    case large
    /// 48pt height — standard buttons
    case medium
    /// 36pt height — compact actions, inline
    case small

    public var verticalPadding: CGFloat {
        switch self {
        case .large: return 16
        case .medium: return 12
        case .small: return 8
        }
    }

    public var horizontalPadding: CGFloat {
        switch self {
        case .large: return 40
        case .medium: return 24
        case .small: return 16
        }
    }

    public var font: Font {
        switch self {
        case .large: return .abLabelLg
        case .medium: return .abLabelLg
        case .small: return .abLabelMd
        }
    }
}

// MARK: - ABButton View

public struct ABButton: View {
    public let title: String
    public var variant: ABButtonVariant = .primaryGradient
    public var size: ABButtonSize = .medium
    public var icon: String? = nil
    public var iconPosition: IconPosition = .leading
    public var fullWidth: Bool = false
    public var isDisabled: Bool = false
    public let action: () -> Void

    public enum IconPosition {
        case leading, trailing
    }

    @State private var isPressed = false

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon, iconPosition == .leading {
                    Image(systemName: icon)
                        .font(.system(size: size == .small ? 12 : 16))
                }
                Text(title)
                    .font(size.font)
                if let icon, iconPosition == .trailing {
                    Image(systemName: icon)
                        .font(.system(size: size == .small ? 12 : 16))
                }
            }
            .foregroundStyle(foregroundColor)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(backgroundView)
            .clipShape(clipShape)
            .overlay(borderOverlay)
        }
        .buttonStyle(ABPressStyle())
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
        .modifier(shadowModifier)
    }

    // MARK: - Computed Properties

    private var foregroundColor: Color {
        switch variant {
        case .primaryGradient: return .abOnPrimary
        case .secondary: return .abPrimary
        case .text: return .abOnSurfaceVariant
        case .inverted: return .abPrimary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primaryGradient:
            LinearGradient.abPrimaryGradient
        case .secondary:
            Color.abSurfaceCard
        case .text:
            Color.clear
        case .inverted:
            Color.white
        }
    }

    private var clipShape: some Shape {
        switch variant {
        case .primaryGradient, .inverted:
            RoundedRectangle(cornerRadius: size == .large ? ABRadius.full : ABRadius.lg)
        case .secondary:
            RoundedRectangle(cornerRadius: ABRadius.full)
        case .text:
            RoundedRectangle(cornerRadius: ABRadius.lg)
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .secondary:
            RoundedRectangle(cornerRadius: ABRadius.full)
                .stroke(Color.abSelectedBorder, lineWidth: 1)
        default:
            EmptyView()
        }
    }

    private var shadowModifier: some ViewModifier {
        switch variant {
        case .primaryGradient:
            return AnyViewModifier { $0.abShadowCTA() }
        default:
            return AnyViewModifier { $0 }
        }
    }
}

// MARK: - Press Animation Style

public struct ABPressStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Type-erased ViewModifier helper

private struct AnyViewModifier: ViewModifier {
    public let transform: (AnyView) -> AnyView

    init<V: View>(_ transform: @escaping (AnyView) -> V) {
        self.transform = { AnyView(transform($0)) }
    }

    public func body(content: Content) -> some View {
        transform(AnyView(content))
    }
}

// MARK: - Preview

#Preview("Button Variants") {
    VStack(spacing: 20) {
        ABButton(title: "View Full Profile & Message", variant: .primaryGradient, size: .large, fullWidth: true) {}
        ABButton(title: "View Profile", variant: .secondary, size: .medium) {}
        ABButton(title: "Skip for now", variant: .text) {}
        ABButton(title: "Ask a Question", variant: .inverted, icon: "plus") {}
        ABButton(title: "Start Reading", variant: .primaryGradient, size: .medium, icon: "arrow.right", iconPosition: .trailing) {}
        ABButton(title: "Disabled", variant: .primaryGradient, isDisabled: true) {}
    }
    .padding()
    .background(Color.abSurface)
}
