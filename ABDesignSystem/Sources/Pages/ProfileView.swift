import SwiftUI

// MARK: - ProfileView
//
// §9 Profile — see docs/spec.md §9.
// M1 read-back: the only surface where the captured ABUser becomes
// visible to the user. Symmetric to §1 (write) ↔ §9 (read).
// "Edit profile" routes back into §1 OnboardingView with the current
// ABUser prefilled — single-source identity capture (see spec §11.4).

public struct ProfileView: View {
    public let user: ABUser?
    public let onEdit: () -> Void

    public init(
        user: ABUser?,
        onEdit: @escaping () -> Void = {}
    ) {
        self.user = user
        self.onEdit = onEdit
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Color.abSurface.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    if let user {
                        identityHero(for: user)
                            .padding(.top, ABSpacing.s12)
                            .padding(.bottom, ABSpacing.s8)

                        fieldsCard(for: user)
                            .padding(.bottom, ABSpacing.s4)

                        whyWeAskRow
                            .padding(.bottom, ABSpacing.s6)

                        editButton
                    } else {
                        emptyState
                            .padding(.top, ABSpacing.s12)
                    }
                }
                .padding(.horizontal, ABLayout.pagePadding)
                .padding(.bottom, ABSpacing.s12)
            }
        }
    }

    // MARK: Identity hero (centered avatar + name + username)
    private func identityHero(for user: ABUser) -> some View {
        VStack(spacing: ABSpacing.s4) {
            ABAvatar(content: user.avatarContent, size: 96)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

            VStack(spacing: 2) {
                Text(user.displayName)
                    .font(.abTitleLg)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.abOnSurface)

                Text(user.username)
                    .font(.abBodySm)
                    .foregroundStyle(Color.abOnSurfaceVariant)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: 4 onboarding fields rendered as list-in-card
    private func fieldsCard(for user: ABUser) -> some View {
        ABCard(variant: .standard) {
            VStack(spacing: 0) {
                ProfileFieldRow(
                    label: "Preferred Language",
                    value: "\(user.preferredLanguage.flagIcon)  \(user.preferredLanguage.rawValue)",
                    icon: nil
                )
                Divider().background(Color.abBorderHairline.opacity(0.4))
                ProfileFieldRow(
                    label: "Current Status",
                    value: user.currentStatus.rawValue,
                    icon: user.currentStatus.icon
                )
                Divider().background(Color.abBorderHairline.opacity(0.4))
                ProfileFieldRow(
                    label: "Location",
                    value: user.location?.displayString ?? "—",
                    icon: "mappin.and.ellipse"
                )
                Divider().background(Color.abBorderHairline.opacity(0.4))
                ProfileFieldRow(
                    label: "Duration in Australia",
                    value: user.durationInAustralia.rawValue,
                    icon: "clock"
                )
            }
        }
    }

    // MARK: Why-we-ask compact row (provenance + edit invitation)
    private var whyWeAskRow: some View {
        HStack(alignment: .center, spacing: ABSpacing.s3) {
            Image(systemName: "bubble.left")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.abOnSurface)

            (Text("Why we ask").fontWeight(.semibold)
                + Text(" — these fields drive personalization. Update them anytime to get more relevant guides, Q&A, and volunteer matches."))
                .font(.abBodySm)
                .foregroundStyle(Color.abOnSurface)
                .lineSpacing(1)
        }
        .padding(.horizontal, ABSpacing.s4)
        .padding(.vertical, ABSpacing.s3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.abAccentGold)
        .clipShape(RoundedRectangle(cornerRadius: ABRadius.lg))
    }

    // MARK: §9.A1 — Edit profile (re-enters §1 with prefilled ABUser)
    private var editButton: some View {
        Button(action: onEdit) {
            HStack(spacing: ABSpacing.s2) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.abPrimary)

                Text("Edit profile")
                    .font(.abBodyMd)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.abOnSurface)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, ABSpacing.s4)
            .background(Color.abSurfaceCard)
            .overlay(
                RoundedRectangle(cornerRadius: ABRadius.lg)
                    .stroke(Color.abBorderHairline.opacity(0.6), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: ABRadius.lg))
        }
        .buttonStyle(.plain)
    }

    // MARK: Empty state — currentUser == nil (should not be reachable in normal flow)
    private var emptyState: some View {
        VStack(spacing: ABSpacing.s4) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(Color.abOnSurfaceVariant)

            Text("No profile yet")
                .font(.abTitleSm)
                .fontWeight(.semibold)
                .foregroundStyle(Color.abOnSurface)

            Text("Finish onboarding first to see your profile here.")
                .font(.abBodySm)
                .foregroundStyle(Color.abOnSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, ABSpacing.s8)
    }
}

// MARK: - ProfileFieldRow (private to ProfileView)

private struct ProfileFieldRow: View {
    let label: String
    let value: String
    let icon: String?

    var body: some View {
        VStack(alignment: .leading, spacing: ABSpacing.s1) {
            Text(label.uppercased())
                .font(.abLabelSm)
                .tracking(0.8)
                .foregroundStyle(Color.abOnSurfaceVariant)

            HStack(spacing: ABSpacing.s2) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.abPrimary)
                        .frame(width: 18, height: 18)
                }

                Text(value)
                    .font(.abBodyMd)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.abOnSurface)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, ABSpacing.s4)
        .padding(.vertical, ABSpacing.s3)
    }
}

// MARK: - Previews

#Preview("Profile · default") {
    ProfileView(user: ABMockData.currentUser)
}

#Preview("Profile · empty") {
    ProfileView(user: nil)
}
