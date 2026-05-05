import SwiftUI

// MARK: - ABDateSeparator

/// Centered pill separator used in chat for date dividers (e.g., "TODAY").
public struct ABDateSeparator: View {
    public let text: String

    public var body: some View {
        HStack {
            Spacer()
            Text(text.uppercased())
                .font(.abLabelSm)
                .foregroundStyle(Color.abOnSurfaceDisabled)
                .padding(.horizontal, ABSpacing.s4)
                .padding(.vertical, ABSpacing.s1)
                .background(Color.abSurfaceContainer)
                .clipShape(Capsule())
            Spacer()
        }
        .padding(.vertical, ABSpacing.s5)
    }
}

// MARK: - Preview

#Preview("Date Separator") {
    VStack {
        ABDateSeparator(text: "Today")
        ABDateSeparator(text: "April 12, 2026")
    }
    .padding()
    .background(Color.abSurface)
}
