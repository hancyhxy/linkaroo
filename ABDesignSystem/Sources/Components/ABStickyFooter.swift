import SwiftUI

// MARK: - ABStickyFooter

/// Bottom-pinned action bar with optional skip text-button + a primary CTA.
/// Used at the bottom of onboarding-style flows.
public struct ABStickyFooter: View {
    public let primaryTitle: String
    public var skipTitle: String? = "Skip for now"
    public var isPrimaryDisabled: Bool = false
    public var onPrimary: (() -> Void)? = nil
    public var onSkip: (() -> Void)? = nil

    public var body: some View {
        HStack(spacing: ABSpacing.s4) {
            if let skipTitle {
                ABButton(title: skipTitle, variant: .text, size: .medium) {
                    onSkip?()
                }
            }

            ABButton(
                title: primaryTitle,
                variant: .primaryGradient,
                size: .medium,
                fullWidth: true,
                isDisabled: isPrimaryDisabled
            ) {
                onPrimary?()
            }
        }
        .padding(.horizontal, ABSpacing.s5)
        .padding(.top, ABSpacing.s3)
        .padding(.bottom, ABSpacing.s5)
        .frame(maxWidth: .infinity)
        .background(
            Color.abSurface
                .opacity(0.95)
                .background(.ultraThinMaterial)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.abBorderHairline.opacity(0.6))
                .frame(height: 1)
        }
    }
}

// MARK: - Preview

#Preview("Sticky Footer") {
    VStack {
        Spacer()
        ABStickyFooter(primaryTitle: "Continue")
    }
    .background(Color.abSurface)
}
