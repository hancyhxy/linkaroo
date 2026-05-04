import Foundation

// ============================================================================
// MARK: - Mock Data (用于 Xcode Preview 和开发阶段)
// ============================================================================

enum ABMockData {

    // MARK: - Users

    static let currentUser = ABUser(
        displayName: "Amara D.",
        username: "u/amara_d",
        preferredLanguage: .english,
        currentStatus: .immigrantStudent,
        location: ABLocation(city: "Sydney", state: "NSW", latitude: -33.8688, longitude: 151.2093),
        durationInAustralia: .oneToSix,
        isOnline: true
    )

    static let meiLin = ABUser(
        displayName: "Mei Lin",
        username: "u/mei_lin",
        preferredLanguage: .mandarin,
        currentStatus: .immigrantStudent,
        location: ABLocation(city: "Sydney", state: "NSW"),
        durationInAustralia: .justLanded,
        isOnline: false
    )

    static let davidO = ABUser(
        displayName: "David O.",
        username: "u/david_o",
        currentStatus: .immigrantStudent,
        durationInAustralia: .oneToSix,
        isOnline: true
    )

    static let rahulK = ABUser(
        displayName: "Rahul K.",
        username: "u/rahul_k",
        currentStatus: .working,
        durationInAustralia: .oneYearPlus
    )

    static let sarahL = ABUser(
        displayName: "Sarah L.",
        username: "u/sarah_l",
        currentStatus: .working,
        durationInAustralia: .oneYearPlus,
        isOnline: true
    )

    static let sarahM = ABUser(
        displayName: "Sarah M.",
        username: "u/sarah_m",
        currentStatus: .immigrantStudent
    )

    // MARK: - Volunteers

    static let volunteerSarah = ABVolunteer(
        user: sarahL,
        role: "Senior Community Advisor",
        rating: 4.9,
        peopleHelped: 142,
        skills: [
            ABSkillTag(text: "UNSW Alumna", category: .blue),
            ABSkillTag(text: "Fluent in Mandarin", category: .blue),
            ABSkillTag(text: "NSW Renting Specialist", category: .warm),
        ],
        bio: "I moved to Sydney from Shanghai 8 years ago as a student. Now I help newcomers navigate housing, visa processes, and settling in. I know what it's like to start from scratch in a new country.",
        specializations: ["Housing", "Visa"]
    )

    static let volunteerDavid = ABVolunteer(
        user: ABUser(displayName: "David K.", username: "u/david_k"),
        role: "Immigration Lawyer",
        rating: 4.7,
        peopleHelped: 89,
        skills: [
            ABSkillTag(text: "Legal Background", category: .blue),
            ABSkillTag(text: "Visa Expert", category: .blue),
        ],
        bio: "Immigration lawyer with 5+ years experience helping skilled workers and students with visa applications and workplace rights.",
        specializations: ["Visa", "Legal"]
    )

    static let volunteerChen = ABVolunteer(
        user: ABUser(displayName: "Chen W.", username: "u/chen_w"),
        role: "Tech Professional & Mentor",
        rating: 4.5,
        peopleHelped: 56,
        skills: [
            ABSkillTag(text: "Former Student", category: .blue),
            ABSkillTag(text: "Career Mentor", category: .blue),
        ],
        bio: "Former international student turned tech professional. Passionate about helping others transition from study to career in Australia.",
        specializations: ["Career", "Education"]
    )

    // MARK: - Match Results

    static let matchResults: [ABMatchResult] = [
        ABMatchResult(volunteer: volunteerSarah, matchPercentage: 98, isTopChoice: true,
                      matchReasons: ["Same university background", "Housing expertise matches your need"]),
        ABMatchResult(volunteer: volunteerDavid, matchPercentage: 82,
                      matchReasons: ["Visa expertise", "Legal background"]),
        ABMatchResult(volunteer: volunteerChen, matchPercentage: 75,
                      matchReasons: ["Student-to-career transition", "Tech industry"]),
    ]

    // MARK: - Q&A Posts

    static let qaPosts: [ABQAPost] = [
        ABQAPost(
            author: ABUser(displayName: "SydneySilver", username: "u/SydneySilver"),
            title: "What are the best suburbs for seniors in Sydney with good public transport?",
            preview: "I'm looking for a suburb that has easy access to trains and buses, ideally with some parks nearby...",
            tags: [
                ABContentTag(text: "SENIOR MATCH", type: .contextMatch),
                ABContentTag(text: "GOVERNMENT VERIFIED", type: .verified, hasIcon: true),
            ],
            category: .housing,
            voteCount: 142,
            commentCount: 32,
            topAnswer: ABTopAnswer(
                excerpt: "\"Chatswood and Hurstville are great options - both have train stations, shopping centres, and parks within walking distance. Many seniors in our community...\"",
                isVerified: true
            ),
            verificationStatus: .verified,
            createdAt: Date().addingTimeInterval(-4 * 3600)
        ),
        ABQAPost(
            author: ABUser(displayName: "LegalEagle_AU", username: "u/LegalEagle_AU"),
            title: "Rights when a landlord wants to sell the senior-living unit?",
            preview: "My landlord just told me they plan to sell the property. I'm on a fixed-term lease with 6 months remaining...",
            tags: [
                ABContentTag(text: "OLD LAW", type: .error),
                ABContentTag(text: "UNVERIFIED", type: .warning),
            ],
            category: .housing,
            voteCount: 89,
            commentCount: 15,
            topAnswer: ABTopAnswer(
                excerpt: "\"Under NSW law, your lease remains valid even if the property is sold. The new owner must honour your existing lease terms...\""
            ),
            verificationStatus: .outdated,
            createdAt: Date().addingTimeInterval(-8 * 3600)
        ),
        ABQAPost(
            author: ABUser(displayName: "MelbExplorer", username: "u/MelbExplorer"),
            title: "Comparison: Independent Living vs. Rental Village?",
            preview: "Has anyone compared the costs and benefits of independent living communities versus traditional rental villages in Melbourne?",
            tags: [
                ABContentTag(text: "SOURCE: TIKTOK", type: .warning),
            ],
            category: .housing,
            voteCount: 256,
            commentCount: 54,
            verificationStatus: .unverified,
            source: .tiktok,
            createdAt: Date().addingTimeInterval(-24 * 3600)
        ),
    ]

    // MARK: - Conversations

    static let conversations: [ABConversation] = [
        ABConversation(
            participant: davidO,
            lastMessage: "Thanks for the engineering intern...",
            lastMessageAt: Date().addingTimeInterval(-120),
            unreadCount: 1
        ),
        ABConversation(
            participant: rahulK,
            lastMessage: "Can you send me the link for that ...",
            lastMessageAt: Date().addingTimeInterval(-2700),
            unreadCount: 1
        ),
        ABConversation(
            participant: meiLin,
            lastMessage: "I just saw your reply about the stu...",
            lastMessageAt: Date().addingTimeInterval(-3600),
            unreadCount: 1
        ),
        ABConversation(
            participant: sarahM,
            lastMessage: "The winter tips you gave last year are ...",
            lastMessageAt: Date().addingTimeInterval(-86400),
            unreadCount: 0
        ),
    ]

    // MARK: - Chat Messages

    static let chatMessages: [ABChatMessage] = [
        ABChatMessage(
            senderID: volunteerSarah.id,
            text: "Hello! I see you're looking into renting rights in Sydney. Since I'm also a former international student, I've been through this. How can I help?",
            timestamp: Date().addingTimeInterval(-300),
            direction: .incoming
        ),
        ABChatMessage(
            senderID: currentUser.id,
            text: "Thanks Sarah! I'm specifically worried about the 90-day notice period. Does it apply if the contract is fixed-term?",
            timestamp: Date().addingTimeInterval(-240),
            direction: .outgoing
        ),
    ]

    // MARK: - Shared Context

    static let chatContext = ABSharedContext(
        title: "Renting rights when landlord sells",
        relatedPostID: qaPosts[1].id
    )

    // MARK: - Context Actions

    static let contextActions: [ABContextAction] = [
        ABContextAction(text: "Share My Profile Tags", icon: "person.text.rectangle", variant: .blue),
        ABContextAction(text: "Ask about the Q&A post", icon: "text.bubble", variant: .blue),
        ABContextAction(text: "Suggest a 5-min call", icon: "phone.fill", variant: .orange),
    ]

    // MARK: - Service Categories

    static let serviceCategories: [ABServiceCategory] = ABServiceCategoryType.allCases.enumerated().map { index, type in
        ABServiceCategory(type: type, displayOrder: index)
    }

    // MARK: - Guides

    static let guides: [ABGuide] = [
        ABGuide(
            title: "The First 7 Days Checklist",
            description: "Everything you need to do in your first week in Australia - from getting a phone number to opening a bank account.",
            tags: [ABContentTag(text: "FEATURED GUIDE", type: .gold)],
            readTimeMinutes: 12,
            isFeatured: true
        ),
        ABGuide(
            title: "Student Visa Work Rights Explained",
            description: "How many hours can you work on a student visa?",
            category: .visa,
            tags: [ABContentTag(text: "STUDENT MATCH", type: .contextMatch)],
            readTimeMinutes: 5
        ),
        ABGuide(
            title: "Sydney's Best Free Wi-Fi Spots",
            description: "Libraries, cafes, and public spaces with reliable internet",
            category: .utilities,
            tags: [ABContentTag(text: "NEW", type: .newContent)],
            readTimeMinutes: 3
        ),
        ABGuide(
            title: "Medicare vs Private Health Insurance",
            description: "Community-voted best explanation for newcomers",
            category: .healthcare,
            tags: [ABContentTag(text: "TOP ANSWER", type: .topAdvice)],
            readTimeMinutes: 8
        ),
    ]

    // MARK: - Help Requests

    static let helpRequests: [ABHelpRequest] = [
        ABHelpRequest(
            requester: meiLin,
            subtitle: "Just arrived in Sydney",
            questionText: "\"Can someone explain the Student Visa work hour limits? I'm confused about the 48-hour fortnight rule.\"",
            tags: [
                ABContentTag(text: "STUDENT MATCH", type: .contextMatch),
                ABContentTag(text: "NEWCOMER", type: .newContent),
            ],
            category: .visa,
            language: .mandarin,
            achievement: ABAchievementBadge(
                text: "You helped 3 others with Student Visas this month",
                icon: "medal",
                variant: .warm
            )
        ),
        ABHelpRequest(
            requester: davidO,
            subtitle: "First year Engineering",
            questionText: "\"Looking for affordable student housing near UNSW. Any recommendations for shared apartments?\"",
            tags: [
                ABContentTag(text: "UNIVERSITY LIFE", type: .category, hasIcon: true),
                ABContentTag(text: "UNSW", type: .category),
            ],
            category: .housing,
            language: .english,
            achievement: ABAchievementBadge(
                text: "You both attend UNSW Sydney",
                icon: "building.columns",
                variant: .cool
            )
        ),
    ]
}
