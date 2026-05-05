import SwiftUI

// MARK: - ABBackBar
//
// Slim frosted sticky bar with a back chevron and an *optional*
// left-aligned title that sits next to the chevron (brand-strip
// style, not iOS centered nav-bar style).
//
// Two typical usages, same init:
//   • `ABBackBar(onBack:)` — back-only, when the page title lives in
//     the content flow as `ABPageHero` (Onboarding, multi-step
//     editorial flows). Title slot stays empty.
//   • `ABBackBar(title:onBack:)` — back + left-aligned title, when
//     the page wants a short nav-context label like "Profile Setup"
//     glued to the chevron, with the long welcome headline still
//     living below in `ABPageHero`.
//
// Use `ABHeader(variant: .pageTitle)` instead for compact detail
// pages (Q&A Detail, Volunteer Match) that already lean on the
// taller 64pt header treatment.

struct ABBackBar: View {
    var title: String? = nil
    var onBack: (() -> Void)? = nil

    /// Slimmer than ABHeader so the page hero below feels editorial.
    /// Mockup `personalization.html` uses py-3 ≈ 56pt total.
    private let height: CGFloat = ABLayout.headerHeight - 8

    var body: some View {
        HStack(spacing: ABSpacing.s3) {
            Button(action: { onBack?() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.abOnSurface)
                    .frame(width: 32, height: 32)
            }

            // Title sits immediately right of the chevron — brand-strip
            // style. Picking abTitleLg (18pt Inter Bold) per mockup
            // `personalization.html` line 20 (`text-lg font-bold`).
            if let title, !title.isEmpty {
                Text(title)
                    .font(.abTitleLg)
                    .foregroundStyle(Color.abOnSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer()
        }
        .padding(.horizontal, ABSpacing.s4)
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(
            Color.abSurface
                .opacity(0.85)
                .background(.ultraThinMaterial)
        )
    }
}

#Preview("ABBackBar — back only") {
    VStack(spacing: 0) {
        ABBackBar(onBack: {})

        ScrollView {
            VStack(alignment: .leading, spacing: ABSpacing.s4) {
                ForEach(0..<10) { i in
                    Text("Content row \(i)")
                        .font(.abBodyMd)
                        .foregroundStyle(Color.abOnSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.abSurfaceCard)
                        .clipShape(RoundedRectangle(cornerRadius: ABRadius.md))
                }
            }
            .padding(ABSpacing.s5)
        }
    }
    .background(Color.abSurface)
}

#Preview("ABBackBar — with title") {
    VStack(spacing: 0) {
        ABBackBar(title: "Profile Setup", onBack: {})

        ScrollView {
            VStack(alignment: .leading, spacing: ABSpacing.s4) {
                ForEach(0..<10) { i in
                    Text("Content row \(i)")
                        .font(.abBodyMd)
                        .foregroundStyle(Color.abOnSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.abSurfaceCard)
                        .clipShape(RoundedRectangle(cornerRadius: ABRadius.md))
                }
            }
            .padding(ABSpacing.s5)
        }
    }
    .background(Color.abSurface)
}
