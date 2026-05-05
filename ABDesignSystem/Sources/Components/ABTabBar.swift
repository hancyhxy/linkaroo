import SwiftUI

// MARK: - Tab Definition

public enum ABTab: String, CaseIterable, Identifiable {
    case home = "Home"
    case community = "Community"
    case profile = "Profile"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .home: return "house.fill"
        case .community: return "person.2.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

// MARK: - ABTabBar

public struct ABTabBar: View {
    @Binding var selectedTab: ABTab

    public var body: some View {
        HStack {
            ForEach(ABTab.allCases) { tab in
                tabItem(tab)
            }
        }
        .padding(.vertical, 10)
        .padding(.bottom, 8) // Extra padding for home indicator safe area
        .frame(maxWidth: .infinity)
        .background(tabBarBackground)
        .abShadowUpward()
    }

    // MARK: - Tab Item

    private func tabItem(_ tab: ABTab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: ABSpacing.s1) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(tab == selectedTab ? .abPrimary : Color.abOnSurfaceDisabled)

                Text(tab.rawValue)
                    .font(.abLabelSm)
                    .tracking(0.5)
                    .foregroundStyle(tab == selectedTab ? .abPrimary : Color.abOnSurfaceDisabled)
                    .fontWeight(tab == selectedTab ? .semibold : .medium)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.rawValue)
        .accessibilityAddTraits(tab == selectedTab ? .isSelected : [])
    }

    // MARK: - Background

    private var tabBarBackground: some View {
        Color.clear.abWhiteFrostedGlass()
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.abBorderHairline.opacity(0.5))
                    .frame(height: 0.5)
            }
    }
}

// MARK: - Preview

#Preview("Tab Bar") {
    ZStack(alignment: .bottom) {
        Color.abSurface.ignoresSafeArea()

        VStack {
            Text("Content Area")
                .foregroundStyle(Color.abOnSurface)
            Spacer()
        }

        ABTabBar(selectedTab: .constant(.home))
    }
}
