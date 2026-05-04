import SwiftUI

// MARK: - ABSegmentedControl

/// Custom segmented control matching the design system's pill-style tabs.
/// Supports optional badge count on individual segments.
struct ABSegmentedControl<T: Hashable & CustomStringConvertible>: View {
    let options: [T]
    @Binding var selected: T
    var badgeCounts: [T: Int] = [:]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                segmentButton(option)
            }
        }
        .padding(4)
        .background(Color.abSurfaceContainer)
        .clipShape(Capsule())
    }

    // MARK: - Segment Button

    private func segmentButton(_ option: T) -> some View {
        Button {
            withAnimation(.easeOut(duration: 0.2)) {
                selected = option
            }
        } label: {
            ZStack(alignment: .topTrailing) {
                Text(option.description)
                    .font(.abLabelMd)
                    .fontWeight(option == selected ? .semibold : .medium)
                    .foregroundStyle(option == selected ? .abOnSurface : Color.abOnSurfaceDisabled)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        option == selected
                            ? AnyShapeStyle(Color.abSurfaceCard)
                            : AnyShapeStyle(Color.clear)
                    )
                    .clipShape(Capsule())
                    .shadow(
                        color: option == selected ? .black.opacity(0.05) : .clear,
                        radius: 1, x: 0, y: 1
                    )

                // Badge
                if let count = badgeCounts[option], count > 0 {
                    Text("\(count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .background(Color.abStatusUnread)
                        .clipShape(Circle())
                        .offset(x: 4, y: -4)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - String Conformance Helper

extension String: @retroactive CustomStringConvertible {
    // String already conforms, just making it explicit for generic usage
}

// MARK: - Preview

#Preview("Segmented Control") {
    VStack(spacing: 20) {
        ABSegmentedControl(
            options: ["Discussions", "Messages"],
            selected: .constant("Discussions")
        )

        ABSegmentedControl(
            options: ["Discussions", "Messages"],
            selected: .constant("Messages"),
            badgeCounts: ["Messages": 3]
        )
    }
    .padding()
    .background(Color.abSurface)
}
