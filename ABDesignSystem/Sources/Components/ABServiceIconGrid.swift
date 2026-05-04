import SwiftUI

// MARK: - Service Item

struct ABServiceItem: Identifiable {
    let id: String
    let label: String
    var icon: String = "questionmark.circle"
}

// MARK: - ABServiceIconGrid

/// 5-column grid of service category icons (homepage "Essential Services").
struct ABServiceIconGrid: View {
    let items: [ABServiceItem]
    var onTap: ((ABServiceItem) -> Void)? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items) { item in
                serviceIcon(item)
            }
        }
    }

    // MARK: - Service Icon

    private func serviceIcon(_ item: ABServiceItem) -> some View {
        Button {
            onTap?(item)
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: ABRadius.xl)
                        .fill(Color.abTagContextBg)
                        .frame(width: 56, height: 56)

                    Image(systemName: item.icon)
                        .font(.system(size: 22))
                        .foregroundStyle(Color.abPrimary)
                }

                Text(item.label)
                    .font(.abCaption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.abOnSurfaceVariant)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(ABPressStyle())
    }
}

// MARK: - Default Service Items

extension ABServiceItem {
    static let defaults: [ABServiceItem] = [
        ABServiceItem(id: "job", label: "Job", icon: "briefcase.fill"),
        ABServiceItem(id: "housing", label: "Housing", icon: "house.fill"),
        ABServiceItem(id: "healthcare", label: "Healthcare", icon: "cross.case.fill"),
        ABServiceItem(id: "visa", label: "Visa", icon: "doc.text.fill"),
        ABServiceItem(id: "bank", label: "Bank", icon: "banknote.fill"),
        ABServiceItem(id: "education", label: "Education", icon: "graduationcap.fill"),
        ABServiceItem(id: "transport", label: "Transport", icon: "bus.fill"),
        ABServiceItem(id: "social", label: "Social", icon: "person.3.fill"),
        ABServiceItem(id: "finance", label: "Finance", icon: "chart.line.uptrend.xyaxis"),
        ABServiceItem(id: "utilities", label: "Utilities", icon: "bolt.fill"),
    ]
}

// MARK: - Preview

#Preview("Service Icon Grid") {
    ABServiceIconGrid(items: ABServiceItem.defaults)
        .padding()
        .background(Color.abSurface)
}
