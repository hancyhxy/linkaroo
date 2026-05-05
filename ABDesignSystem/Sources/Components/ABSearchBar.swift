import SwiftUI

// MARK: - Search Bar Variant

public enum ABSearchBarVariant {
    /// Frosted glass overlay on hero images — white/20% bg + backdrop blur
    case hero
    /// Standard white background for regular pages
    case standard
}

// MARK: - ABSearchBar

public struct ABSearchBar: View {
    @Binding var text: String
    public var placeholder: String = "Search services, guides, Q&A..."
    public var variant: ABSearchBarVariant = .standard
    public var onSubmit: (() -> Void)? = nil

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(iconColor)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.abLabelLg)
                        .foregroundStyle(placeholderColor)
                }
                TextField("", text: $text)
                    .font(.abBodySm)
                    .foregroundStyle(textColor)
                    .onSubmit { onSubmit?() }
            }
        }
        .padding(.horizontal, ABSpacing.s4)
        .padding(.vertical, 10)
        .background(background)
        .clipShape(clipShape)
        .overlay(borderOverlay)
    }

    // MARK: - Variant-specific styling

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .hero:
            Color.white.opacity(0.2)
                .background(.ultraThinMaterial)
        case .standard:
            Color.abSurfaceCard
        }
    }

    private var clipShape: AnyShape {
        switch variant {
        case .hero: AnyShape(Capsule())
        case .standard: AnyShape(RoundedRectangle(cornerRadius: ABRadius.md))
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .hero:
            Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1)
        case .standard:
            EmptyView()
        }
    }

    private var iconColor: Color {
        switch variant {
        case .hero: .white.opacity(0.8)
        case .standard: .abOnSurfaceDisabled
        }
    }

    private var placeholderColor: Color {
        switch variant {
        case .hero: .white.opacity(0.6)
        case .standard: .abOnSurfaceDisabled
        }
    }

    private var textColor: Color {
        switch variant {
        case .hero: .white
        case .standard: .abOnSurface
        }
    }
}

// MARK: - Preview

#Preview("Search Bar") {
    VStack(spacing: 20) {
        // Hero variant on dark background
        ZStack {
            Color.abPrimary
            ABSearchBar(text: .constant(""), variant: .hero)
                .padding(.horizontal)
        }
        .frame(height: 80)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.xl))

        // Standard variant
        ABSearchBar(text: .constant(""), variant: .standard)
            .padding(.horizontal)
    }
    .padding()
    .background(Color.abSurface)
}
