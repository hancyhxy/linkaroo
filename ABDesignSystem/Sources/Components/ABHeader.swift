import SwiftUI

// MARK: - Header Variant

public enum ABHeaderVariant {
    /// Brand logo header — "AussieBridge" in Liberation Serif italic
    case brand
    /// Page title with optional back button
    case pageTitle(title: String, showBack: Bool = true)
    /// Chat header with avatar, name, and online status
    case chat(name: String, avatarURL: URL? = nil, isOnline: Bool = false)
}

// MARK: - ABHeader

public struct ABHeader: View {
    public let variant: ABHeaderVariant
    public var onBack: (() -> Void)? = nil
    public var onMenu: (() -> Void)? = nil

    public var body: some View {
        // Background extends behind the status bar so iOS clock / battery glyphs
        // sit on the header surface instead of the page content underneath.
        // Content layer stays inside the safe area at headerHeight.
        ZStack(alignment: .bottom) {
            headerBackground
                .ignoresSafeArea(edges: .top)

            HStack(spacing: ABSpacing.s3) {
                switch variant {
                case .brand:
                    brandContent

                case .pageTitle(let title, let showBack):
                    pageTitleContent(title: title, showBack: showBack)

                case .chat(let name, let avatarURL, let isOnline):
                    chatContent(name: name, avatarURL: avatarURL, isOnline: isOnline)
                }
            }
            .frame(height: ABLayout.headerHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, ABSpacing.s5)
        }
        .frame(height: ABLayout.headerHeight)
        .modifier(ABHeaderShadow(variant: variant))
    }

    // MARK: - Brand Content

    private var brandContent: some View {
        Text("AussieBridge")
            .font(.abBrand)
            .foregroundStyle(Color.abPrimary)
    }

    // MARK: - Page Title Content

    private func pageTitleContent(title: String, showBack: Bool) -> some View {
        HStack(spacing: ABSpacing.s3) {
            if showBack {
                backButton
            }
            Text(title)
                .font(.abHeadlineMd)
                .foregroundStyle(Color.abOnSurface)
            Spacer()
        }
    }

    // MARK: - Chat Content

    private func chatContent(name: String, avatarURL: URL?, isOnline: Bool) -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 10) {
                backButton

                ABAvatar(
                    content: .image(avatarURL),
                    size: 36,
                    showOnline: isOnline
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.abTitleSm)
                        .foregroundStyle(Color.abOnSurface)

                    if isOnline {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.abStatusOnline)
                                .frame(width: 6, height: 6)
                            Text("Online")
                                .font(.abCaption)
                                .foregroundStyle(Color.abStatusOnlineText)
                        }
                    }
                }
            }

            Spacer()

            if onMenu != nil {
                Button(action: { onMenu?() }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.abOnSurface)
                        .frame(width: 44, height: 44)
                }
            }
        }
    }

    // MARK: - Shared Components

    private var backButton: some View {
        Button(action: { onBack?() }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.abOnSurface)
                .frame(width: 32, height: 32)
        }
    }

    @ViewBuilder
    private var headerBackground: some View {
        switch variant {
        case .brand:
            // Frosted glass for brand header (homepage)
            Color.clear.abFrostedGlass()
        case .pageTitle, .chat:
            // Inherit page background so detail headers dissolve into
            // the surface beneath. No hairline — once the header shares
            // the page's surface tone, a divider only re-introduces a
            // visual seam (Canvas note 2026-05-05).
            Color.abSurface
        }
    }
}

// MARK: - Variant-aware shadow
//
// `.brand` is a frosted overlay that wants the ambient lift recipe
// from design.md §4 (Home page hero stays atmospheric). `.pageTitle`
// and `.chat` inherit `Color.abSurface` so they should fully dissolve
// into the page beneath — no shadow, no hairline.
private struct ABHeaderShadow: ViewModifier {
    public let variant: ABHeaderVariant

    public func body(content: Content) -> some View {
        switch variant {
        case .brand:
            content.abShadowAmbient()
        case .pageTitle, .chat:
            content
        }
    }
}

// MARK: - Preview

#Preview("Header Variants") {
    VStack(spacing: 0) {
        ABHeader(variant: .brand)
        ABHeader(variant: .pageTitle(title: "Community"))
        ABHeader(variant: .pageTitle(title: "Volunteer", showBack: true), onBack: {})
        ABHeader(
            variant: .chat(name: "Sarah L.", isOnline: true),
            onBack: {},
            onMenu: {}
        )
    }
    .background(Color.abSurface)
}
