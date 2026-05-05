import SwiftUI

// MARK: - ABChatInputArea

/// Bottom-pinned chat composer wrapping `ABTextInput(.chat)` with safe-area padding
/// and a soft separator to lift it above the message stream.
public struct ABChatInputArea: View {
    @Binding var text: String
    public var placeholder: String = "Type a message..."
    public var onSend: (() -> Void)? = nil
    public var onPlus: (() -> Void)? = nil

    public var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.abBorderHairline.opacity(0.5))
                .frame(height: 1)

            ABTextInput(
                text: $text,
                placeholder: placeholder,
                variant: .chat,
                onSend: onSend,
                onPlus: onPlus
            )
            .padding(.horizontal, ABSpacing.s4)
            .padding(.top, ABSpacing.s2)
            .padding(.bottom, ABSpacing.s5)
        }
        .background(Color.abSurfaceCard)
    }
}

// MARK: - Preview

#Preview("Chat Input Area") {
    @Previewable @State var draft = ""
    VStack {
        Spacer()
        ABChatInputArea(text: $draft)
    }
    .background(Color.abSurface)
}
