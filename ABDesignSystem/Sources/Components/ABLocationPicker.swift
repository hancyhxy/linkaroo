import SwiftUI

// MARK: - ABLocationPicker

/// Static location picker for onboarding — display selected city + state, with a "Detect" affordance
/// and a stylised mini-map placeholder. Tapping the row triggers `onTap`.
public struct ABLocationPicker: View {
    public let city: String
    public let state: String
    public var onDetect: (() -> Void)? = nil
    public var onTap: (() -> Void)? = nil

    public var body: some View {
        VStack(spacing: ABSpacing.s3) {
            // Row: pin + city/state + detect
            HStack(spacing: ABSpacing.s3) {
                ZStack {
                    Circle()
                        .fill(Color.abAccentSky)
                        .frame(width: 40, height: 40)
                    Image(systemName: "location.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.abPrimary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(city)
                        .font(.abTitleSm)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.abOnSurface)
                    Text(state)
                        .font(.abLabelMd)
                        .foregroundStyle(Color.abOnSurfaceVariant)
                }

                Spacer()

                Button {
                    onDetect?()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "scope")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Detect")
                            .font(.abLabelMd)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(Color.abPrimary)
                    .padding(.horizontal, ABSpacing.s3)
                    .padding(.vertical, 6)
                    .background(Color.abSurfaceContainer)
                    .clipShape(Capsule())
                }
                .buttonStyle(ABPressStyle())
            }

            // Mini-map placeholder
            mapPlaceholder
        }
        .padding(ABSpacing.s4)
        .background(Color.abSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.lg))
        .abGhostBorder(radius: ABRadius.lg)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }

    private var mapPlaceholder: some View {
        ZStack {
            // Pastel gradient stand-in for a map tile
            LinearGradient(
                colors: [Color.abAccentSky, Color.abAccentSky.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Faux grid lines
            Path { path in
                for i in 1..<5 {
                    let x = CGFloat(i) * (ABLayout.phoneFrame / 5)
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: 200))
                }
                for i in 1..<3 {
                    let y = CGFloat(i) * 30
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: ABLayout.phoneFrame, y: y))
                }
            }
            .stroke(Color.white.opacity(0.4), lineWidth: 1)

            // Pin
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 28))
                .foregroundStyle(Color.abPrimary)
                .background(
                    Circle()
                        .fill(.white)
                        .frame(width: 30, height: 30)
                )
        }
        .frame(height: 88)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.md))
    }
}

// MARK: - Preview

#Preview("Location Picker") {
    VStack {
        ABLocationPicker(city: "Sydney", state: "NSW")
            .padding()
    }
    .background(Color.abSurface)
}
