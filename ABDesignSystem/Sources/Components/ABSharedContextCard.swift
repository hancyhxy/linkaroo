import SwiftUI

// MARK: - ABSharedContextCard

/// Context reference card shown at the top of chat conversations,
/// linking back to the original Q&A post.
public struct ABSharedContextCard: View {
    public let title: String
    public var linkText: String = "View Q&A Post"
    public var onTap: (() -> Void)? = nil

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 0) {
                // Left accent border
                Rectangle()
                    .fill(Color.abPrimaryBright)
                    .frame(width: 3)

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.abPrimary)
                        .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("SHARED CONTEXT")
                            .font(.abMicro)
                            .tracking(1.1)
                            .foregroundStyle(Color.abOnSurfaceDisabled)

                        Text(title)
                            .font(.abTitleSm)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.abOnSurface)

                        HStack(spacing: 4) {
                            Text(linkText)
                                .font(.abLabelMd)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.abPrimaryBright)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10))
                                .foregroundStyle(Color.abPrimaryBright)
                        }
                    }
                }
                .padding(.vertical, 14)
                .padding(.leading, 11) // Total 14px with the 3px border
                .padding(.trailing, 14)
            }
            .background(Color.abSurfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: ABRadius.lg))
        }
        .buttonStyle(ABPressStyle())
    }
}

// MARK: - Preview

#Preview("Shared Context Card") {
    ABSharedContextCard(title: "Renting rights when landlord sells")
        .padding()
        .background(Color.abSurface)
}
