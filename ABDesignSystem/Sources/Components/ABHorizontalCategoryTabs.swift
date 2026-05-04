import SwiftUI

// MARK: - Category Tab Item

struct ABCategoryTabItem: Identifiable, Hashable {
    let id: String
    let label: String
    var icon: String? = nil
}

// MARK: - ABHorizontalCategoryTabs

/// Horizontal scrolling category filter pills (e.g., Q&A page: Renting, Subletting, Utilities).
struct ABHorizontalCategoryTabs: View {
    let items: [ABCategoryTabItem]
    @Binding var selectedId: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ABSpacing.s2) {
                ForEach(items) { item in
                    tabPill(item)
                }
            }
            .padding(.horizontal, ABSpacing.s4)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .padding(.vertical, ABSpacing.s3)
    }

    // MARK: - Tab Pill

    private func tabPill(_ item: ABCategoryTabItem) -> some View {
        let isActive = item.id == selectedId

        return Button {
            withAnimation(.easeOut(duration: 0.2)) {
                selectedId = item.id
            }
        } label: {
            HStack(spacing: 6) {
                if let icon = item.icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                }
                Text(item.label)
                    .font(.abLabelMd)
                    .fontWeight(isActive ? .semibold : .medium)
            }
            .foregroundStyle(isActive ? .white : .abOnSurfaceVariant)
            .padding(.horizontal, ABSpacing.s4)
            .padding(.vertical, ABSpacing.s2)
            .background(isActive ? Color.abPrimary : .abSurfaceCard)
            .clipShape(Capsule())
            .overlay(
                isActive
                    ? nil
                    : Capsule().stroke(Color.abBorderHairline, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Category Tabs") {
    VStack {
        ABHorizontalCategoryTabs(
            items: [
                ABCategoryTabItem(id: "renting", label: "Renting", icon: "house"),
                ABCategoryTabItem(id: "subletting", label: "Subletting", icon: "arrow.left.arrow.right"),
                ABCategoryTabItem(id: "utilities", label: "Utilities", icon: "bolt"),
                ABCategoryTabItem(id: "flatmates", label: "Flatmates", icon: "person.2"),
            ],
            selectedId: .constant("renting")
        )
    }
    .background(Color.abSurface)
}
