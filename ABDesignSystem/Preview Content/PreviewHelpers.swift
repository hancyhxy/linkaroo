import SwiftUI

// MARK: - Mock Data for Xcode Previews

enum ABPreviewData {

    // MARK: - Q&A Posts

    static let qaPosts: [ABQAPostData] = [
        ABQAPostData(
            author: "SydneySilver",
            timeAgo: "4h ago",
            title: "What are the best suburbs for seniors in Sydney with good public transport?",
            preview: "I'm looking for a suburb that has easy access to trains and buses, ideally with some parks nearby...",
            tags: [("Senior Match", .contextMatch), ("Government Verified", .verified)],
            voteCount: 142,
            commentCount: 32,
            topAnswer: "\"Chatswood and Hurstville are great options - both have train stations, shopping centres, and parks within walking distance.\""
        ),
        ABQAPostData(
            author: "LegalEagle_AU",
            timeAgo: "8h ago",
            title: "Rights when a landlord wants to sell the senior-living unit?",
            preview: "My landlord just told me they plan to sell the property. I'm on a fixed-term lease with 6 months remaining...",
            tags: [("Old Law", .error), ("Unverified", .warning)],
            voteCount: 89,
            commentCount: 15,
            topAnswer: "\"Under NSW law, your lease remains valid even if the property is sold.\""
        ),
        ABQAPostData(
            author: "MelbExplorer",
            timeAgo: "1d ago",
            title: "Comparison: Independent Living vs. Rental Village?",
            preview: "Has anyone compared the costs and benefits of independent living communities?",
            tags: [("Source: TikTok", .warning)],
            voteCount: 256,
            commentCount: 54
        ),
    ]

    // MARK: - Volunteers

    static let heroVolunteer = ABVolunteerHeroData(
        name: "Sarah L.",
        role: "Senior Community Advisor",
        imageURL: nil,
        matchPercent: 98,
        rating: 4.9,
        helpedCount: 142,
        skills: [
            ("UNSW Alumna", .skillBlue),
            ("Fluent in Mandarin", .skillBlue),
            ("NSW Renting Specialist", .skillWarm),
        ],
        bio: "I moved to Sydney from Shanghai 8 years ago as a student. Now I help newcomers navigate housing, visa processes, and settling in. I know what it's like to start from scratch in a new country."
    )

    static let matchVolunteers: [ABVolunteerMatchData] = [
        ABVolunteerMatchData(
            name: "David K.",
            imageURL: nil,
            matchPercent: 82,
            skills: [("Legal Background", .skillBlue), ("Visa Expert", .skillBlue)],
            bio: "Immigration lawyer with 5+ years experience helping skilled workers and students with visa applications."
        ),
        ABVolunteerMatchData(
            name: "Chen W.",
            imageURL: nil,
            matchPercent: 75,
            skills: [("Former Student", .skillBlue), ("Career Mentor", .skillBlue)],
            bio: "Former international student turned tech professional. Passionate about helping others transition from study to career."
        ),
    ]

    // MARK: - Messages

    static let messages: [ABMessageItemData] = [
        ABMessageItemData(
            id: "1", name: "David O.",
            preview: "Thanks for the engineering intern...",
            timeAgo: "2 min ago",
            avatarContent: .initials("DO"),
            isOnline: true, isUnread: true
        ),
        ABMessageItemData(
            id: "2", name: "Rahul K.",
            preview: "Can you send me the link for that ...",
            timeAgo: "45 min ago",
            avatarContent: .initials("RK"),
            isUnread: true
        ),
        ABMessageItemData(
            id: "3", name: "Mei Lin",
            preview: "I just saw your reply about the stu...",
            timeAgo: "1 hour ago",
            avatarContent: .initials("ML"),
            isUnread: true
        ),
        ABMessageItemData(
            id: "4", name: "Sarah M.",
            preview: "The winter tips you gave last year are ...",
            timeAgo: "Yesterday",
            avatarContent: .initials("SM")
        ),
    ]

    // MARK: - Help Cards

    static let helpCards: [ABHelpCardData] = [
        ABHelpCardData(
            name: "Mei Lin",
            subtitle: "Just arrived in Sydney",
            avatarURL: nil,
            tags: [("Student Match", .contextMatch), ("Newcomer", .new)],
            quote: "\"Can someone explain the Student Visa work hour limits? I'm confused about the 48-hour fortnight rule.\"",
            achievementText: "You helped 3 others with Student Visas this month"
        ),
        ABHelpCardData(
            name: "David O.",
            subtitle: "First year Engineering",
            avatarURL: nil,
            tags: [("University Life", .contextMatch), ("UNSW", .contextMatch)],
            quote: "\"Looking for affordable student housing near UNSW. Any recommendations for shared apartments?\"",
            achievementText: "You both attend UNSW Sydney",
            achievementIcon: "building.columns",
            achievementColor: .abPrimary,
            achievementBg: Color(hex: "f0f8ff")
        ),
    ]

    // MARK: - Category Tabs

    static let housingTabs: [ABCategoryTabItem] = [
        ABCategoryTabItem(id: "renting", label: "Renting", icon: "house"),
        ABCategoryTabItem(id: "subletting", label: "Subletting", icon: "arrow.left.arrow.right"),
        ABCategoryTabItem(id: "utilities", label: "Utilities", icon: "bolt"),
        ABCategoryTabItem(id: "flatmates", label: "Flatmates", icon: "person.2"),
    ]

    // MARK: - Service Items

    static let services = ABServiceItem.defaults
}
