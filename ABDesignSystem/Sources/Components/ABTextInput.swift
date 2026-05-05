import SwiftUI

// MARK: - Input Variant

public enum ABTextInputVariant {
    /// Chat message input — rounded pill with plus and send buttons
    case chat
    /// Standard form input — rounded rectangle with optional leading icon
    case form
}

// MARK: - ABTextInput

public struct ABTextInput: View {
    @Binding var text: String
    public var placeholder: String = "Type a message..."
    public var variant: ABTextInputVariant = .form
    public var leadingIcon: String? = nil
    public var onSend: (() -> Void)? = nil
    public var onPlus: (() -> Void)? = nil

    public var body: some View {
        switch variant {
        case .chat:
            chatInput
        case .form:
            formInput
        }
    }

    // MARK: - Chat Input

    private var chatInput: some View {
        HStack(spacing: ABSpacing.s3) {
            // Plus button
            Button(action: { onPlus?() }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }

            // Text field
            HStack {
                TextField(placeholder, text: $text)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurface)
            }
            .padding(.horizontal, ABSpacing.s4)
            .padding(.vertical, 10)
            .background(Color.abSurfaceContainer)
            .clipShape(Capsule())

            // Send button
            Button(action: { onSend?() }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient.abPrimaryGradient)
                        .frame(width: 36, height: 36)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - Form Input

    private var formInput: some View {
        HStack(spacing: 8) {
            if let leadingIcon {
                Image(systemName: leadingIcon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.abOnSurfaceDisabled)
            }

            TextField(placeholder, text: $text)
                .font(.abBodyMd)
                .fontWeight(.medium)
                .foregroundStyle(Color.abOnSurface)
        }
        .padding(.horizontal, ABSpacing.s6)
        .padding(.vertical, ABSpacing.s5)
        .background(Color.abSurfaceContainer)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xl))
    }
}

// MARK: - Preview

#Preview("Text Inputs") {
    VStack(spacing: 24) {
        ABTextInput(text: .constant(""), variant: .chat)

        ABTextInput(
            text: .constant(""),
            placeholder: "Search location...",
            variant: .form,
            leadingIcon: "mappin"
        )

        ABTextInput(
            text: .constant("Sydney, NSW"),
            placeholder: "Location",
            variant: .form,
            leadingIcon: "mappin.and.ellipse"
        )
    }
    .padding()
    .background(Color.abSurface)
}
