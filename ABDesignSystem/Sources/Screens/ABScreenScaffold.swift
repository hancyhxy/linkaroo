import SwiftUI

// MARK: - ABScreenScaffold

/// Reusable screen wrapper providing consistent layout: Header + scrollable content + optional Tab Bar.
/// Handles safe area insets, frosted header layering, and tab bar bottom padding.
struct ABScreenScaffold<Content: View>: View {
    let header: ABHeaderVariant
    var showTabBar: Bool = false
    @Binding var selectedTab: ABTab
    var onBack: (() -> Void)? = nil
    var onMenu: (() -> Void)? = nil
    @ViewBuilder let content: () -> Content

    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            Color.abSurface.ignoresSafeArea()

            // Main content
            VStack(spacing: 0) {
                // Header
                ABHeader(
                    variant: header,
                    onBack: onBack,
                    onMenu: onMenu
                )

                // Scrollable content
                ScrollView {
                    content()
                        .padding(.bottom, showTabBar ? ABLayout.tabBarHeight + ABSpacing.s4 : ABSpacing.s4)
                }
            }

            // Tab Bar
            if showTabBar {
                ABTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

// MARK: - Convenience init without tab bar

extension ABScreenScaffold {
    /// Initializer for screens without a tab bar.
    init(
        header: ABHeaderVariant,
        onBack: (() -> Void)? = nil,
        onMenu: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) where Content: View {
        self.header = header
        self.showTabBar = false
        self._selectedTab = .constant(.home)
        self.onBack = onBack
        self.onMenu = onMenu
        self.content = content
    }
}

// MARK: - Adaptive Grid Helper

/// Switches column count based on device size class.
struct ABAdaptiveGrid<Content: View>: View {
    var compactColumns: Int = 5
    var regularColumns: Int = 8
    var spacing: CGFloat = 12
    @ViewBuilder let content: () -> Content

    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columnCount: Int {
        sizeClass == .regular ? regularColumns : compactColumns
    }

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount),
            spacing: spacing
        ) {
            content()
        }
    }
}

// MARK: - Preview

#Preview("Screen Scaffold") {
    ABScreenScaffold(
        header: .pageTitle(title: "Q&A & Guides"),
        showTabBar: true,
        selectedTab: .constant(.community)
    ) {
        VStack(spacing: 16) {
            ForEach(0..<5) { i in
                ABCard(variant: .standard) {
                    Text("Card \(i + 1)")
                        .font(.abTitleMd)
                        .foregroundStyle(Color.abOnSurface)
                }
            }
        }
        .padding(.horizontal, ABLayout.pagePadding)
        .padding(.top, ABSpacing.s4)
    }
}
