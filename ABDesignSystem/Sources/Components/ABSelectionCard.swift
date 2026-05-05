import SwiftUI

// MARK: - Selection Card Variant

public enum ABSelectionVariant {
    /// Icon card — vertical layout with icon + label (e.g., Current Status)
    case iconCard
    /// Text card — compact horizontal label (e.g., Language selection)
    case textCard
    /// Pill / Chip — capsule shape for inline selection (e.g., Duration)
    case chip
}

// MARK: - ABSelectionCard

public struct ABSelectionCard: View {
    public let label: String
    public var icon: String? = nil
    public var variant: ABSelectionVariant = .textCard
    public var isSelected: Bool = false
    public var action: () -> Void

    public var body: some View {
        Button(action: action) {
            content
                .background(isSelected ? Color.abSelected : Color.abSurfaceCard)
                .clipShape(clipShape)
                .overlay(border)
        }
        .buttonStyle(ABPressStyle())
    }

    // MARK: - Content by Variant

    @ViewBuilder
    private var content: some View {
        switch variant {
        case .iconCard:
            VStack(spacing: ABSpacing.s2) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundStyle(isSelected ? .abPrimary : Color.abOnSurfaceVariant)
                }
                Text(label)
                    .font(.abLabelMd)
                    .fontWeight(.semibold)
                    .foregroundStyle(isSelected ? .abPrimary : Color.abOnSurfaceVariant)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, ABSpacing.s4)
            .padding(.horizontal, ABSpacing.s3)

        case .textCard:
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.abPrimaryBright)
                }
                Text(label)
                    .font(.abBodySm)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .abPrimary : Color.abOnSurfaceVariant)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, ABSpacing.s3)

        case .chip:
            Text(label)
                .font(.abLabelMd)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .abPrimary : Color.abOnSurfaceVariant)
                .padding(.vertical, ABSpacing.s2)
                .padding(.horizontal, ABSpacing.s4)
        }
    }

    // MARK: - Shape & Border

    private var clipShape: AnyShape {
        switch variant {
        case .iconCard: AnyShape(RoundedRectangle(cornerRadius: ABRadius.xl))
        case .textCard: AnyShape(RoundedRectangle(cornerRadius: ABRadius.lg))
        case .chip: AnyShape(Capsule())
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .iconCard:
            RoundedRectangle(cornerRadius: ABRadius.xl)
                .stroke(isSelected ? Color.abSelectedBorder : Color.abBorderHairline, lineWidth: isSelected ? 2 : 1)
        case .textCard:
            RoundedRectangle(cornerRadius: ABRadius.lg)
                .stroke(isSelected ? Color.abSelectedBorder : Color.abBorderHairline, lineWidth: isSelected ? 2 : 1)
        case .chip:
            Capsule()
                .stroke(isSelected ? Color.abSelectedBorder : Color.abBorderHairline, lineWidth: isSelected ? 2 : 1)
        }
    }
}

// MARK: - Preview

#Preview("Selection Cards") {
    VStack(spacing: 24) {
        // Icon Cards (Current Status)
        Text("Current Status").font(.abTitleSm)
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ABSelectionCard(label: "Immigrant Student", icon: "graduationcap.fill", variant: .iconCard, isSelected: true) {}
            ABSelectionCard(label: "Working", icon: "briefcase.fill", variant: .iconCard) {}
            ABSelectionCard(label: "Looking for Work", icon: "magnifyingglass", variant: .iconCard) {}
            ABSelectionCard(label: "Business Owner", icon: "building.2", variant: .iconCard) {}
        }

        // Text Cards (Language)
        Text("Language").font(.abTitleSm)
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ABSelectionCard(label: "English", variant: .textCard, isSelected: true) {}
            ABSelectionCard(label: "Mandarin", variant: .textCard) {}
            ABSelectionCard(label: "Spanish", variant: .textCard) {}
        }

        // Chips (Duration)
        Text("Duration").font(.abTitleSm)
        FlowLayout(spacing: 8) {
            ABSelectionCard(label: "Not yet arrived", variant: .chip) {}
            ABSelectionCard(label: "Just landed", variant: .chip) {}
            ABSelectionCard(label: "1-6 months", variant: .chip, isSelected: true) {}
            ABSelectionCard(label: "6-12 months", variant: .chip) {}
            ABSelectionCard(label: "1 year+", variant: .chip) {}
        }
    }
    .padding()
    .background(Color.abSurface)
}
