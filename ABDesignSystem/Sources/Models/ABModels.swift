import Foundation

// ============================================================================
// MARK: - AussieBridge Core Data Models
// ============================================================================
//
// 本文件定义了 AussieBridge App 的所有核心数据结构。
// 每个 struct 均遵循 Identifiable（用于 SwiftUI ForEach）
// 和 Codable（用于 JSON 序列化 / API 通信）。
//
// 数据模型分 5 层，对应 Context-First 变体的 5 个机制。
// 详见 `docs/struct.md`（每个字段的 Why 与实体关系箭头都在那里）。
//
// 实体关系图（22 实体，与 struct.md 一致）:
//
//   §1 Identity Layer  (M1 - onboarding 捕获身份，作为下游过滤输入)
//   ─────────────────────────────────────────────────────────────
//   ABUser ──> ABLanguage           (preferredLanguage)
//   ABUser ──> ABUserStatus         (currentStatus)
//   ABUser ──> ABLocation?          (location)
//   ABUser ──> ABDuration           (durationInAustralia)
//   ABUser ──< ABTaskItem           (completedTasks)
//
//   §2 Curation Layer  (M2 + M3 - 上下文 home hub + 可见的可信度标签)
//   ─────────────────────────────────────────────────────────────
//   ABServiceCategory ──> ABServiceCategoryType
//   ABGuide ──> ABServiceCategoryType
//   ABGuide ──< ABContentTag
//   ABQAPost ──> ABUser              (author)
//   ABQAPost ──> ABServiceCategoryType
//   ABQAPost ──< ABContentTag
//   ABQAPost ── ABTopAnswer?         (1:0..1, embedded)
//   ABQAPost ──> ABVerificationStatus
//   ABQAPost ──> ABContentSource?
//   ABContentTag ──> ABContentTagType
//
//   §3 Matching Layer  (M4 - reason-based 志愿者匹配)
//   ─────────────────────────────────────────────────────────────
//   ABVolunteer ──> ABUser           (embedded user)
//   ABVolunteer ──< ABSkillTag
//   ABSkillTag ──> ABSkillCategory
//   ABMatchResult ──> ABVolunteer
//   ABHelpRequest ──> ABUser         (requester)
//   ABHelpRequest ──> ABServiceCategoryType
//   ABHelpRequest ──> ABLanguage
//   ABHelpRequest ──> ABVolunteer?   (assignedVolunteer)
//   ABHelpRequest ──< ABContentTag
//   ABHelpRequest ── ABAchievementBadge?  (1:0..1)
//   ABAchievementBadge ──> ABAchievementVariant
//
//   §4 Conversation Layer  (M5 - context-aware chat handoff)
//   ─────────────────────────────────────────────────────────────
//   ABConversation ──> ABUser        (participant)
//   ABConversation ── ABSharedContext?  (1:0..1)
//   ABConversation ──< ABChatMessage
//   ABConversation ──< ABContextAction
//   ABChatMessage ──> ABMessageDirection
//   ABChatMessage ── ABTranslation?  (via translatedText field)
//   ABSharedContext ──> ABQAPost     (relatedPostID)
//   ABContextAction ──> ABActionVariant
//
//   §5 Cross-cutting Layer  (跨机制基础设施)
//   ─────────────────────────────────────────────────────────────
//   ABTranslation ──> ABLanguage     (sourceLanguage + targetLanguage)
//   ABTaskItem ──> ABServiceCategoryType
//   ABTaskItem ──< ABStep
//
// 命名约定: 文档使用抽象名 (User, Task, QAPost)，代码加 `AB` 前缀
// 避免与 Swift 标准库 / SwiftUI 类型冲突 (e.g. `Task` 是 _Concurrency.Task)。
//
// ============================================================================


// MARK: - 1. User Profile (用户档案)

/// 应用的核心用户实体。包含 onboarding 时收集的个人化信息。
struct ABUser: Identifiable, Codable {
    let id: UUID
    var displayName: String
    var username: String                          // e.g., "u/sarah_m"
    var avatarURL: URL?                           // nil → 用 initials 渲染
    var preferredLanguage: ABLanguage
    var currentStatus: ABUserStatus
    var location: ABLocation?
    var durationInAustralia: ABDuration
    var isOnline: Bool
    var onboardingProgress: Double                // 0.0~1.0, onboarding 完成度
    var completedTasks: [ABTaskItem]              // 已完成的 checklist 任务
    var createdAt: Date

    init(
        id: UUID = UUID(),
        displayName: String,
        username: String,
        avatarURL: URL? = nil,
        preferredLanguage: ABLanguage = .english,
        currentStatus: ABUserStatus = .immigrantStudent,
        location: ABLocation? = nil,
        durationInAustralia: ABDuration = .notYetArrived,
        isOnline: Bool = false,
        onboardingProgress: Double = 0,
        completedTasks: [ABTaskItem] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.username = username
        self.avatarURL = avatarURL
        self.preferredLanguage = preferredLanguage
        self.currentStatus = currentStatus
        self.location = location
        self.durationInAustralia = durationInAustralia
        self.isOnline = isOnline
        self.onboardingProgress = onboardingProgress
        self.completedTasks = completedTasks
        self.createdAt = createdAt
    }

    /// 从 displayName 提取首字母（用于 Avatar fallback）
    var initials: String {
        displayName
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
    }
}

/// 用户首选语言 — 合并了 Language-First 变体的 flagIcon 和 code 字段
enum ABLanguage: String, Codable, CaseIterable, Identifiable {
    case english   = "English"
    case mandarin  = "Mandarin"
    case spanish   = "Spanish"
    case arabic    = "Arabic"
    case hindi     = "Hindi"
    case other     = "Other"

    var id: String { rawValue }

    /// ISO 639-1 语言代码
    var code: String {
        switch self {
        case .english:  return "en"
        case .mandarin: return "zh"
        case .spanish:  return "es"
        case .arabic:   return "ar"
        case .hindi:    return "hi"
        case .other:    return "xx"
        }
    }

    /// 国旗 emoji
    var flagIcon: String {
        switch self {
        case .english:  return "🇦🇺"
        case .mandarin: return "🇨🇳"
        case .spanish:  return "🇪🇸"
        case .arabic:   return "🇸🇦"
        case .hindi:    return "🇮🇳"
        case .other:    return "🌐"
        }
    }
}

/// 用户当前身份状态（onboarding 选择）
enum ABUserStatus: String, Codable, CaseIterable, Identifiable {
    case immigrantStudent = "Immigrant Student"
    case working          = "Working"
    case lookingForWork   = "Looking for Work"
    case businessOwner    = "Business Owner"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .immigrantStudent: return "graduationcap.fill"
        case .working:          return "briefcase.fill"
        case .lookingForWork:   return "magnifyingglass"
        case .businessOwner:    return "building.2"
        }
    }
}

/// 用户在澳时长
///
/// Conforms to `CustomStringConvertible` so picker components like
/// ABChipPicker (which is generic over `Hashable & CustomStringConvertible`)
/// can stringify each case for display without requiring the call-site
/// to declare the conformance separately.
enum ABDuration: String, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case notYetArrived = "Not yet arrived"
    case justLanded    = "Just landed"
    case oneToSix      = "1-6 months"
    case sixToTwelve   = "6-12 months"
    case oneYearPlus   = "1 year+"

    var id: String { rawValue }
    var description: String { rawValue }
}

/// 地理位置
struct ABLocation: Codable, Equatable {
    var city: String            // e.g., "Sydney"
    var state: String           // e.g., "NSW"
    var latitude: Double?
    var longitude: Double?

    var displayString: String {
        "\(city), \(state)"
    }
}


// MARK: - 2. Volunteer (志愿者)

/// 经验丰富的志愿者档案，用于匹配新移民。
struct ABVolunteer: Identifiable, Codable {
    let id: UUID
    var user: ABUser                              // 志愿者本身也是用户
    var role: String                              // e.g., "Senior Community Advisor"
    var rating: Double                            // e.g., 4.9 (满分 5.0)
    var peopleHelped: Int                         // e.g., 142
    var skills: [ABSkillTag]                      // 技能标签列表
    var bio: String                               // 个人简介
    var specializations: [String]                 // e.g., ["Housing", "Visa"]

    init(
        id: UUID = UUID(),
        user: ABUser,
        role: String,
        rating: Double = 0,
        peopleHelped: Int = 0,
        skills: [ABSkillTag] = [],
        bio: String = "",
        specializations: [String] = []
    ) {
        self.id = id
        self.user = user
        self.role = role
        self.rating = rating
        self.peopleHelped = peopleHelped
        self.skills = skills
        self.bio = bio
        self.specializations = specializations
    }
}

/// 技能标签（志愿者专长）
struct ABSkillTag: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String                              // e.g., "UNSW Alumna"
    var category: ABSkillCategory

    init(id: UUID = UUID(), text: String, category: ABSkillCategory = .blue) {
        self.id = id
        self.text = text
        self.category = category
    }
}

/// 技能标签颜色分类
enum ABSkillCategory: String, Codable {
    case blue = "blue"      // 教育/背景类: UNSW Alumna, Legal Background
    case warm = "warm"      // 专业类: NSW Renting Specialist
}

/// 志愿者匹配结果
struct ABMatchResult: Identifiable, Codable {
    let id: UUID
    var volunteer: ABVolunteer
    var matchPercentage: Int                      // 0-100, e.g., 98
    var isTopChoice: Bool                         // 是否 "THE BEST FIT"
    var matchReasons: [String]                    // 匹配原因说明

    init(
        id: UUID = UUID(),
        volunteer: ABVolunteer,
        matchPercentage: Int,
        isTopChoice: Bool = false,
        matchReasons: [String] = []
    ) {
        self.id = id
        self.volunteer = volunteer
        self.matchPercentage = matchPercentage
        self.isTopChoice = isTopChoice
        self.matchReasons = matchReasons
    }
}


// MARK: - 3. Q&A Post (社区问答帖)

/// 社区问答帖子 — Reddit 风格，带投票和标签系统。
struct ABQAPost: Identifiable, Codable {
    let id: UUID
    var author: ABUser
    var title: String
    var preview: String                           // 正文前 150 字摘要
    var fullContent: String                       // 完整正文
    var tags: [ABContentTag]                      // 语义标签
    var category: ABServiceCategoryType           // 所属分类 (Housing, Visa, etc.)
    var voteCount: Int
    var commentCount: Int
    var topAnswer: ABTopAnswer?                   // 最高赞回答摘要
    var verificationStatus: ABVerificationStatus
    var source: ABContentSource?                  // 信息来源 (e.g., TikTok)
    var createdAt: Date

    init(
        id: UUID = UUID(),
        author: ABUser,
        title: String,
        preview: String,
        fullContent: String = "",
        tags: [ABContentTag] = [],
        category: ABServiceCategoryType = .housing,
        voteCount: Int = 0,
        commentCount: Int = 0,
        topAnswer: ABTopAnswer? = nil,
        verificationStatus: ABVerificationStatus = .unverified,
        source: ABContentSource? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.author = author
        self.title = title
        self.preview = preview
        self.fullContent = fullContent
        self.tags = tags
        self.category = category
        self.voteCount = voteCount
        self.commentCount = commentCount
        self.topAnswer = topAnswer
        self.verificationStatus = verificationStatus
        self.source = source
        self.createdAt = createdAt
    }

    /// 格式化的发帖时间 (e.g., "4h ago", "1d ago")
    var timeAgoString: String {
        let interval = Date().timeIntervalSince(createdAt)
        let hours = Int(interval / 3600)
        if hours < 1 { return "Just now" }
        if hours < 24 { return "\(hours)h ago" }
        let days = hours / 24
        if days < 7 { return "\(days)d ago" }
        let weeks = days / 7
        return "\(weeks)w ago"
    }
}

/// 最高赞回答摘要
struct ABTopAnswer: Codable {
    var authorUsername: String
    var excerpt: String                           // 摘要引用文字
    var isVerified: Bool

    init(authorUsername: String = "", excerpt: String, isVerified: Bool = false) {
        self.authorUsername = authorUsername
        self.excerpt = excerpt
        self.isVerified = isVerified
    }
}

/// 帖子验证状态
enum ABVerificationStatus: String, Codable {
    case verified    = "verified"                 // GOVERNMENT VERIFIED (绿色)
    case unverified  = "unverified"               // UNVERIFIED (琥珀色警告)
    case outdated    = "outdated"                 // OLD LAW (红色删除线)
    case pending     = "pending"                  // 等待审核
}

/// 内容来源
enum ABContentSource: String, Codable {
    case tiktok     = "TikTok"
    case government = "Government"
    case community  = "Community"
    case official   = "Official"
}

/// 内容标签 — 用于 Q&A 帖子和推荐文章
struct ABContentTag: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String                              // 显示文本
    var type: ABContentTagType                    // 语义类型（决定颜色）
    var hasIcon: Bool                             // 是否带前导图标

    init(id: UUID = UUID(), text: String, type: ABContentTagType, hasIcon: Bool = false) {
        self.id = id
        self.text = text
        self.type = type
        self.hasIcon = hasIcon
    }
}

/// 标签语义类型 — 映射到设计系统的颜色
enum ABContentTagType: String, Codable {
    case contextMatch   = "context_match"         // 蓝: STUDENT MATCH, SENIOR MATCH
    case verified       = "verified"              // 绿实心: GOVERNMENT VERIFIED
    case newContent     = "new"                   // 浅绿: NEW, NEWCOMER
    case warning        = "warning"               // 琥珀: UNVERIFIED, SOURCE: TIKTOK
    case error          = "error"                 // 红+删除线: OLD LAW
    case gold           = "gold"                  // 金: FEATURED GUIDE, TOP CHOICE
    case topAdvice      = "top_advice"            // 琥珀: Top Advice
    case category       = "category"              // 蓝: UNIVERSITY LIFE, VISA Q&A, UNSW
}


// MARK: - 4. Conversation & Chat (对话 & 聊天)

/// 消息会话 — 两个用户之间的对话线程
struct ABConversation: Identifiable, Codable {
    let id: UUID
    var participant: ABUser                       // 对方用户
    var lastMessage: String                       // 最近消息预览
    var lastMessageAt: Date
    var unreadCount: Int                          // 未读消息数
    var sharedContext: ABSharedContext?            // 关联的 Q&A 上下文

    init(
        id: UUID = UUID(),
        participant: ABUser,
        lastMessage: String,
        lastMessageAt: Date = Date(),
        unreadCount: Int = 0,
        sharedContext: ABSharedContext? = nil
    ) {
        self.id = id
        self.participant = participant
        self.lastMessage = lastMessage
        self.lastMessageAt = lastMessageAt
        self.unreadCount = unreadCount
        self.sharedContext = sharedContext
    }

    var isUnread: Bool { unreadCount > 0 }

    var timeAgoString: String {
        let interval = Date().timeIntervalSince(lastMessageAt)
        let minutes = Int(interval / 60)
        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes) min ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours) hour\(hours == 1 ? "" : "s") ago" }
        let days = hours / 24
        if days == 1 { return "Yesterday" }
        return "\(days)d ago"
    }
}

/// 单条聊天消息
struct ABChatMessage: Identifiable, Codable {
    let id: UUID
    var senderID: UUID                            // 发送者 User ID
    var text: String
    var translatedText: String?                   // 自动翻译后的文字 (Language-First 功能)
    var timestamp: Date
    var direction: ABMessageDirection
    var isVoiceMessage: Bool                      // 是否为语音消息

    init(
        id: UUID = UUID(),
        senderID: UUID,
        text: String,
        translatedText: String? = nil,
        timestamp: Date = Date(),
        direction: ABMessageDirection,
        isVoiceMessage: Bool = false
    ) {
        self.id = id
        self.senderID = senderID
        self.text = text
        self.translatedText = translatedText
        self.timestamp = timestamp
        self.direction = direction
        self.isVoiceMessage = isVoiceMessage
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: timestamp)
    }
}

/// 消息方向
enum ABMessageDirection: String, Codable {
    case incoming = "incoming"                    // 收到的消息（左侧气泡）
    case outgoing = "outgoing"                    // 发出的消息（右侧气泡）
}

/// 共享上下文 — 聊天中关联的 Q&A 帖子引用
struct ABSharedContext: Codable {
    var title: String                             // e.g., "Renting rights when landlord sells"
    var relatedPostID: UUID                       // 关联的 QAPost ID
    var linkText: String                          // e.g., "View Q&A Post"

    init(title: String, relatedPostID: UUID, linkText: String = "View Q&A Post") {
        self.title = title
        self.relatedPostID = relatedPostID
        self.linkText = linkText
    }
}

/// 聊天中的上下文操作选项 (Action Pill)
struct ABContextAction: Identifiable, Codable {
    let id: UUID
    var text: String                              // e.g., "Share My Profile Tags"
    var icon: String                              // SF Symbol name
    var variant: ABActionVariant

    init(id: UUID = UUID(), text: String, icon: String, variant: ABActionVariant = .blue) {
        self.id = id
        self.text = text
        self.icon = icon
        self.variant = variant
    }
}

/// Action Pill 颜色变体
enum ABActionVariant: String, Codable {
    case blue   = "blue"                          // 蓝色: 分享、提问类
    case orange = "orange"                        // 橙色: 通话、紧急类
}


// MARK: - 5. Service Category (服务分类)

/// 首页 Essential Services 网格中的服务分类
struct ABServiceCategory: Identifiable, Codable {
    let id: UUID
    var type: ABServiceCategoryType
    var displayOrder: Int

    init(id: UUID = UUID(), type: ABServiceCategoryType, displayOrder: Int = 0) {
        self.id = id
        self.type = type
        self.displayOrder = displayOrder
    }

    var name: String { type.rawValue }
    var icon: String { type.icon }
}

/// 10 种服务分类枚举
enum ABServiceCategoryType: String, Codable, CaseIterable, Identifiable {
    case job        = "Job"
    case housing    = "Housing"
    case healthcare = "Healthcare"
    case visa       = "Visa"
    case bank       = "Bank"
    case education  = "Education"
    case transport  = "Transport"
    case social     = "Social"
    case finance    = "Finance"
    case utilities  = "Utilities"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .job:        return "briefcase.fill"
        case .housing:    return "house.fill"
        case .healthcare: return "cross.case.fill"
        case .visa:       return "doc.text.fill"
        case .bank:       return "banknote.fill"
        case .education:  return "graduationcap.fill"
        case .transport:  return "bus.fill"
        case .social:     return "person.3.fill"
        case .finance:    return "chart.line.uptrend.xyaxis"
        case .utilities:  return "bolt.fill"
        }
    }
}


// MARK: - 6. Guide / Article (指南/文章)

/// 推荐文章或指南 — 出现在首页 "Recommend for you" 区域
struct ABGuide: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var category: ABServiceCategoryType
    var tags: [ABContentTag]
    var readTimeMinutes: Int                      // 阅读时长 (分钟)
    var isFeatured: Bool                          // 是否为 Featured Guide（深色卡片）
    var imageURL: URL?                            // 文章封面图 (Featured Guide 用)
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: ABServiceCategoryType = .visa,
        tags: [ABContentTag] = [],
        readTimeMinutes: Int = 5,
        isFeatured: Bool = false,
        imageURL: URL? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.tags = tags
        self.readTimeMinutes = readTimeMinutes
        self.isFeatured = isFeatured
        self.imageURL = imageURL
        self.createdAt = createdAt
    }

    var readTimeString: String {
        "\(readTimeMinutes) min read"
    }
}


// MARK: - 7. Help Request (社区求助)

/// "People You Can Help" 中的求助卡片
struct ABHelpRequest: Identifiable, Codable {
    let id: UUID
    var requester: ABUser                         // 发起求助的用户
    var subtitle: String                          // e.g., "Just arrived in Sydney"
    var questionText: String                      // 求助内容引用
    var tags: [ABContentTag]
    var category: ABServiceCategoryType           // 所属服务分类
    var language: ABLanguage                      // 求助使用的语言
    var isResolved: Bool                          // 是否已解决
    var assignedVolunteer: ABVolunteer?           // 已分配的志愿者 (Optional — 初始为 nil)
    var achievement: ABAchievementBadge?          // 当前用户的相关成就
    var createdAt: Date

    init(
        id: UUID = UUID(),
        requester: ABUser,
        subtitle: String,
        questionText: String,
        tags: [ABContentTag] = [],
        category: ABServiceCategoryType = .visa,
        language: ABLanguage = .english,
        isResolved: Bool = false,
        assignedVolunteer: ABVolunteer? = nil,
        achievement: ABAchievementBadge? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.requester = requester
        self.subtitle = subtitle
        self.questionText = questionText
        self.tags = tags
        self.category = category
        self.language = language
        self.isResolved = isResolved
        self.assignedVolunteer = assignedVolunteer
        self.achievement = achievement
        self.createdAt = createdAt
    }
}

/// 成就徽章 — 显示在求助卡中，提供匹配上下文
struct ABAchievementBadge: Codable {
    var text: String                              // e.g., "You helped 3 others with Student Visas this month"
    var icon: String                              // SF Symbol name
    var variant: ABAchievementVariant

    init(text: String, icon: String = "medal", variant: ABAchievementVariant = .warm) {
        self.text = text
        self.icon = icon
        self.variant = variant
    }
}

/// 成就徽章颜色变体
enum ABAchievementVariant: String, Codable {
    case warm = "warm"                            // 暖金: 个人成就类
    case cool = "cool"                            // 蓝色: 共同背景类 ("You both attend UNSW")
}


// MARK: - 8. Task / Checklist Item (任务清单)

/// 任务/清单项 — "The First 7 Days Checklist" 等指南中的可完成步骤。
/// 来源: 组员 Language-First 变体 + homepage Featured Guide。
struct ABTaskItem: Identifiable, Codable {
    let id: UUID
    var title: String                             // e.g., "Get a phone number"
    var category: ABServiceCategoryType           // e.g., .bank, .healthcare
    var isCompleted: Bool
    var steps: [ABStep]                           // 子步骤列表

    init(
        id: UUID = UUID(),
        title: String,
        category: ABServiceCategoryType,
        isCompleted: Bool = false,
        steps: [ABStep] = []
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.isCompleted = isCompleted
        self.steps = steps
    }

    /// 任务完成进度 (0.0~1.0)，基于子步骤完成数计算
    var progress: Double {
        guard !steps.isEmpty else { return isCompleted ? 1.0 : 0.0 }
        let completed = steps.filter(\.isCompleted).count
        return Double(completed) / Double(steps.count)
    }
}

/// 任务子步骤
struct ABStep: Identifiable, Codable {
    let id: UUID
    var title: String                             // e.g., "Visit the Telstra store"
    var description: String                       // 详细说明
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, description: String = "", isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
}


// MARK: - 9. Translation (翻译)

/// 翻译记录 — Language-First 变体的核心功能。
/// 用于消息内自动翻译和独立翻译工具。
struct ABTranslation: Identifiable, Codable {
    let id: UUID
    let originalText: String                      // 原始文字 (不可变)
    var translatedText: String                    // 翻译结果 (可能被修正)
    let sourceLanguage: ABLanguage                // 原始语言
    let targetLanguage: ABLanguage                // 目标语言
    var confidence: Double?                       // 翻译置信度 (0.0~1.0)
    var createdAt: Date

    init(
        id: UUID = UUID(),
        originalText: String,
        translatedText: String,
        sourceLanguage: ABLanguage,
        targetLanguage: ABLanguage = .english,
        confidence: Double? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.originalText = originalText
        self.translatedText = translatedText
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.confidence = confidence
        self.createdAt = createdAt
    }
}
