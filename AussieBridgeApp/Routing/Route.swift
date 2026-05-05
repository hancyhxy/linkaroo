import Foundation
import ABDesignSystem

enum Route: Hashable {
    // Home tab — 通过 ABServiceCategoryType 进 QA list；通过 post id 进详情
    case qaList(category: ABServiceCategoryType?)
    case qaDetail(postID: UUID)
    case volunteerMatch(originatingPostID: UUID?)

    // Community tab
    case peopleToHelp

    // Messages tab — 通过 conversation id 进详情
    case chat(conversationID: UUID)
}
