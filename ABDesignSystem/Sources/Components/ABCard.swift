import SwiftUI

// MARK: - Card Variant

public enum ABCardVariant {
    /// White card with subtle ghost border — general purpose
    case standard
    /// Dark background (#2c3136) with gold badge — Featured Guide
    case featured
    /// Gradient background with inverted button — CTA Banner
    case ctaBanner
    /// Warm gold background (#ffddb7) with icon + text — Tip Card
    case tip
}

// MARK: - ABCard

/// Configurable card container matching the design system.
/// Use `@ViewBuilder` content to fill the card interior.
public struct ABCard<Content: View>: View {
    public let variant: ABCardVariant
    @ViewBuilder let content: () -> Content

    public var body: some View {
        content()
            .padding(cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cardRadius))
            .modifier(cardModifier)
    }

    // MARK: - Variant Properties

    private var cardPadding: CGFloat {
        switch variant {
        case .standard: return ABSpacing.s4
        case .featured, .ctaBanner: return ABSpacing.s5
        case .tip: return ABSpacing.s6
        }
    }

    private var cardRadius: CGFloat {
        switch variant {
        case .standard: return ABRadius.xl
        case .featured, .ctaBanner: return ABRadius.xl
        case .tip: return ABRadius.xxl
        }
    }

    @ViewBuilder
    private var cardBackground: some View {
        switch variant {
        case .standard:
            Color.abSurfaceCard
        case .featured:
            Color.abSurfaceDark
        case .ctaBanner:
            LinearGradient.abPrimaryGradient
        case .tip:
            Color.abAccentGold
        }
    }

    private var cardModifier: some ViewModifier {
        switch variant {
        case .standard:
            return AnyCardModifier { $0.abGhostBorder() }
        case .featured, .ctaBanner, .tip:
            return AnyCardModifier { $0 }
        }
    }
}

// MARK: - Type-erased ViewModifier

private struct AnyCardModifier: ViewModifier {
    public let transform: (AnyView) -> AnyView

    init<V: View>(_ transform: @escaping (AnyView) -> V) {
        self.transform = { AnyView(transform($0)) }
    }

    public func body(content: Content) -> some View {
        transform(AnyView(content))
    }
}

// MARK: - Preview

#Preview("Card Variants") {
    ScrollView {
        VStack(spacing: 16) {
            // Standard
            ABCard(variant: .standard) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Student Visa Work Rights Explained")
                        .font(.abTitleMd)
                        .foregroundStyle(Color.abOnSurface)
                    Text("How many hours can you work on a student visa?")
                        .font(.abBodySm)
                        .foregroundStyle(Color.abOnSurfaceVariant)
                }
            }

            // Featured
            ABCard(variant: .featured) {
                VStack(alignment: .leading, spacing: 8) {
                    ABTag(text: "Featured Guide", style: .gold, size: .badge)
                    Text("The First 7 Days Checklist")
                        .font(.abTitleLg)
                        .foregroundStyle(.white)
                    Text("Everything you need to do in your first week.")
                        .font(.abBodySm)
                        .foregroundStyle(Color.abOnSurfaceDisabled)
                }
            }

            // CTA Banner
            ABCard(variant: .ctaBanner) {
                VStack(spacing: 12) {
                    Text("Can't find what you're looking for?")
                        .font(.abTitleMd)
                        .foregroundStyle(.white)
                    Text("Ask our community of experienced immigrants")
                        .font(.abBodySm)
                        .foregroundStyle(.white.opacity(0.8))
                    ABButton(title: "Ask a Question", variant: .inverted, icon: "plus") {}
                }
                .multilineTextAlignment(.center)
            }

            // Tip
            ABCard(variant: .tip) {
                HStack(alignment: .top, spacing: ABSpacing.s3) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.abAccentGoldDark)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tailored for New Arrivals")
                            .font(.abTitleSm)
                            .foregroundStyle(Color.abOnSurface)
                        Text("Based on your profile, we'll prioritize essential settlement guides.")
                            .font(.abBodySm)
                            .foregroundStyle(Color.abOnSurfaceVariant)
                    }
                }
            }
        }
        .padding()
    }
    .background(Color.abSurface)
}
