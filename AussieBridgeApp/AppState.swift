import SwiftUI
import ABDesignSystem

@Observable
final class AppState {
    // §1 Onboarding 写入
    var currentUser: ABUser?
    var hasCompletedOnboarding: Bool = false

    // §10.3 Context handoff —— QADetail → VolunteerMatch 时 capture
    var originatingPost: ABQAPost?

    // §6 VolunteerMatch → Chat 时 capture
    var pendingVolunteer: ABVolunteer?

    // 4 个 tab 各自的 navigation path
    var homePath = NavigationPath()
    var communityPath = NavigationPath()
    var messagesPath = NavigationPath()
    var profilePath = NavigationPath()

    // Tab selector (供跨 tab 跳转使用，例如 VolunteerMatch → Chat)
    var selectedTab: Int = 0

    func completeOnboarding(user: ABUser) {
        // OnboardingView 只采集 4 个画像字段（language/status/location/duration），
        // displayName / username / avatarAssetName 留作占位 ("You" / "u/you" / nil)。
        // 把这 4 个字段 merge 进 ABMockData.currentUser 这个完整身份基底，
        // 保留 Amara D. 的 displayName 和 avatar_amara.jpg —— 直到 v2 onboarding
        // 能显式采集姓名和头像。
        currentUser = mergedFromMock(user)
        hasCompletedOnboarding = true
    }

    func skipOnboarding() {
        currentUser = ABMockData.currentUser
        hasCompletedOnboarding = true
    }

    private func mergedFromMock(_ partial: ABUser) -> ABUser {
        var merged = ABMockData.currentUser
        merged.preferredLanguage = partial.preferredLanguage
        merged.currentStatus = partial.currentStatus
        merged.location = partial.location
        merged.durationInAustralia = partial.durationInAustralia
        return merged
    }

    /// §9.A1 — Edit profile 闭环：从 §9 Profile 出发的 OnboardingView 完成后，
    /// 走这个方法（不是 completeOnboarding），保留 hasCompletedOnboarding 状态，
    /// 只更新 ABUser 字段。spec §11.4 single-source identity capture 的运行时实现。
    func updateUser(_ user: ABUser) {
        // 同 completeOnboarding —— OnboardingView 在 edit 模式回写时
        // 会复用 prefilledUser?.displayName / username（OnboardingView.swift:79-80），
        // 但 avatarAssetName 不在 onboarding 视野里，会被默认构造器置 nil。
        // 把现有 currentUser 的身份基底保留，只 merge 4 个画像字段。
        guard let existing = currentUser else {
            currentUser = user
            return
        }
        var merged = existing
        merged.preferredLanguage = user.preferredLanguage
        merged.currentStatus = user.currentStatus
        merged.location = user.location
        merged.durationInAustralia = user.durationInAustralia
        currentUser = merged
    }

    func captureOriginatingPost(_ post: ABQAPost) {
        originatingPost = post
    }
}
