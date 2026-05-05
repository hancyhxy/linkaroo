import SwiftUI

// MARK: - ABBackBar
//
// Slim frosted sticky bar with a back chevron and an *optional*
// centered title.
//
// Two typical usages, same init:
//   • `ABBackBar(onBack:)` — back-only, when the page title lives in
//     the content flow as `ABPageHero` (Onboarding, multi-step
//     editorial flows).
//   • `ABBackBar(title:onBack:)` — back + small centered title, when
//     the page is mid-depth (form pages like NewQuestion) but doesn't
//     warrant the heavy `ABHeader.pageTitle` 64pt frame.
//
// Use `ABHeader(variant: .pageTitle)` instead for compact detail
// pages (Q&A Detail, Volunteer Match) that already lean on the
// taller header treatment.

struct ABBackBar: View {
    var title: String? = nil
    var onBack: (() -> Void)? = nil

    /// Slimmer than ABHeader so the page hero below feels editorial.
    /// Mockup `personalization.html` uses py-3 ≈ 56pt total.
    private let height: CGFloat = ABLayout.headerHeight - 8

    var body: some View {
        ZStack {
            // Centered title layer — independent of the back chevron's
            // 32pt slot, so the title sits on the bar's true midline.
            if let title, !title.isEmpty {
                Text(title)
                    .font(.abTitleSm)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.abOnSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.horizontal, 48) // keep clear of the back chevron
            }

            // Back chevron pinned left.
            HStack(spacing: 0) {
                Button(action: { onBack?() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.abOnSurface)
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
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
        ABBackBar(title: "New Question", onBack: {})

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
