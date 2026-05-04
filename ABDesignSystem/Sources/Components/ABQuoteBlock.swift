import SwiftUI

// MARK: - ABQuoteBlock

/// Left-bordered quote block used for "Top Answer" excerpts in Q&A cards.
struct ABQuoteBlock: View {
    let text: String
    var showHeader: Bool = false
    var headerText: String = "Top Answer"
    var headerIcon: String = "checkmark.circle.fill"
    var accentColor: Color = .abPrimaryBright
    var backgroundColor: Color = Color.abSurfaceContainer

    var body: some View {
        HStack(spacing: 0) {
            // Left accent border
            Rectangle()
                .fill(accentColor)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 6) {
                if showHeader {
                    HStack(spacing: 6) {
                        Image(systemName: headerIcon)
                            .font(.system(size: 14))
                            .foregroundStyle(accentColor)
                        Text(headerText)
                            .font(.abLabelSm)
                            .fontWeight(.bold)
                            .foregroundStyle(accentColor)
                    }
                }

                Text(text)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineSpacing(4)
            }
            .padding(.vertical, 12)
            .padding(.leading, 13) // 16px total with the 3px border
            .padding(.trailing, 12)
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.lg))
    }
}

// MARK: - Preview

#Preview("Quote Block") {
    VStack(spacing: 16) {
        ABQuoteBlock(
            text: "\"Chatswood and Hurstville are great options - both have train stations, shopping centres, and parks within walking distance.\"",
            showHeader: true
        )

        ABQuoteBlock(
            text: "\"Under NSW law, your lease remains valid even if the property is sold. The new owner must honour your existing lease terms...\""
        )
    }
    .padding()
    .background(Color.abSurface)
}
