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
        currentUser = user
        hasCompletedOnboarding = true
    }

    func skipOnboarding() {
        currentUser = ABMockData.currentUser
        hasCompletedOnboarding = true
    }

    /// §9.A1 — Edit profile 闭环：从 §9 Profile 出发的 OnboardingView 完成后，
    /// 走这个方法（不是 completeOnboarding），保留 hasCompletedOnboarding 状态，
    /// 只更新 ABUser 字段。spec §11.4 single-source identity capture 的运行时实现。
    func updateUser(_ user: ABUser) {
        currentUser = user
    }

    func captureOriginatingPost(_ post: ABQAPost) {
        originatingPost = post
    }
}
