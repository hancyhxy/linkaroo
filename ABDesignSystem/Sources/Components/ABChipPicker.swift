import SwiftUI

// MARK: - ABChipPicker

/// Wrapping flow of selectable chips. Used for compact multi-option pickers (e.g. duration in onboarding).
public struct ABChipPicker<T: Hashable & CustomStringConvertible>: View {
    public let options: [T]
    @Binding var selected: T

    public var body: some View {
        FlowLayout(spacing: ABSpacing.s2) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                chip(option)
            }
        }
    }

    private func chip(_ option: T) -> some View {
        let isActive = option == selected

        return Button {
            withAnimation(.easeOut(duration: 0.18)) {
                selected = option
            }
        } label: {
            Text(option.description)
                .font(.abLabelMd)
                .fontWeight(isActive ? .semibold : .medium)
                .foregroundStyle(isActive ? Color.abPrimary : Color.abOnSurfaceVariant)
                .padding(.horizontal, ABSpacing.s4)
                .padding(.vertical, ABSpacing.s2)
                .background(isActive ? Color.abSelected : Color.abSurfaceCard)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            isActive ? Color.abSelectedBorder : Color.abBorderHairline,
                            lineWidth: isActive ? 1.5 : 1
                        )
                )
        }
        .buttonStyle(ABPressStyle())
    }
}

// MARK: - Preview

private enum DemoDuration: String, CaseIterable, CustomStringConvertible {
    case notArrived = "Not yet arrived"
    case justLanded = "Just landed"
    case oneToSix = "1–6 months"
    case sixToTwelve = "6–12 months"
    case oneYearPlus = "1 year+"

    public var description: String { rawValue }
}

#Preview("Chip Picker") {
    @Previewable @State var selected: DemoDuration = .justLanded
    VStack {
        ABChipPicker(options: DemoDuration.allCases, selected: $selected)
            .padding()
    }
    .background(Color.abSurface)
}
