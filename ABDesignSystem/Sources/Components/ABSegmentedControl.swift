import SwiftUI

// MARK: - ABSegmentedControl

/// Custom segmented control matching the design system's pill-style tabs.
/// Supports optional badge count on individual segments.
public struct ABSegmentedControl<T: Hashable & CustomStringConvertible>: View {
    public let options: [T]
    @Binding var selected: T
    public var badgeCounts: [T: Int] = [:]

    public var body: some View {
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
            // Label + badge wrapped tightly, then centered inside the
            // segment slot. This anchors the badge to the *text*'s
            // top-trailing corner (per mockup message.html) instead of
            // the full segment slot's right edge — otherwise the badge
            // floats out into empty track space.
            HStack(spacing: 6) {
                Text(option.description)
                    .font(.abLabelMd)
                    .fontWeight(option == selected ? .semibold : .medium)
                    .foregroundStyle(option == selected ? .abOnSurface : Color.abOnSurfaceDisabled)

                if let count = badgeCounts[option], count > 0 {
                    Text("\(count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(minWidth: 18, minHeight: 18)
                        .padding(.horizontal, 4)
                        .background(Color.abStatusUnread)
                        .clipShape(Capsule())
                }
            }
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
