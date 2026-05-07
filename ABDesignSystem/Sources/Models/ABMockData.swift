import Foundation

// ============================================================================
// MARK: - Mock Data (用于 Xcode Preview 和开发阶段)
// ============================================================================

public enum ABMockData {

    // MARK: - Users

    public static let currentUser = ABUser(
        displayName: "Amara D.",
        username: "u/amara_d",
        avatarAssetName: "avatar_amara",
        preferredLanguage: .english,
        currentStatus: .immigrantStudent,
        location: ABLocation(city: "Sydney", state: "NSW", latitude: -33.8688, longitude: 151.2093),
        durationInAustralia: .oneToSix,
        isOnline: true
    )

    public static let meiLin = ABUser(
        displayName: "Mei Lin",
        username: "u/mei_lin",
        avatarAssetName: "avatar_meilin",
        preferredLanguage: .mandarin,
        currentStatus: .immigrantStudent,
        location: ABLocation(city: "Sydney", state: "NSW"),
        durationInAustralia: .justLanded,
        isOnline: false
    )

    public static let davidO = ABUser(
        displayName: "David O.",
        username: "u/david_o",
        avatarAssetName: "avatar_david",
        currentStatus: .immigrantStudent,
        durationInAustralia: .oneToSix,
        isOnline: true
    )

    public static let rahulK = ABUser(
        displayName: "Rahul K.",
        username: "u/rahul_k",
        avatarAssetName: "avatar_chen",
        currentStatus: .working,
        durationInAustralia: .oneYearPlus
    )

    public static let sarahL = ABUser(
        displayName: "Sarah L.",
        username: "u/sarah_l",
        avatarAssetName: "avatar_sarah",
        currentStatus: .working,
        durationInAustralia: .oneYearPlus,
        isOnline: true
    )

    public static let sarahM = ABUser(
        displayName: "Sarah M.",
        username: "u/sarah_m",
        currentStatus: .immigrantStudent
    )

    // Q&A comment authors — see qaComments below for usage and tone calibration.
    public static let chatswoodGran = ABUser(displayName: "Chatswood Gran",  username: "u/chatswood_gran",  durationInAustralia: .oneYearPlus)
    public static let nswHousingMod = ABUser(displayName: "NSW Housing Mod", username: "u/nsw_housing_mod", durationInAustralia: .oneYearPlus, isOnline: true)
    public static let quietRetiree  = ABUser(displayName: "Quiet Retiree",   username: "u/quiet_retiree",   durationInAustralia: .oneYearPlus)
    public static let strathfieldR  = ABUser(displayName: "Strathfield R",   username: "u/strathfield_r",   durationInAustralia: .oneYearPlus)
    public static let oldRenter88   = ABUser(displayName: "Old Renter 88",   username: "u/old_renter_88",   durationInAustralia: .oneYearPlus)
    public static let leaseLawyerAU = ABUser(displayName: "Lease Lawyer AU", username: "u/lease_lawyer_au", durationInAustralia: .oneYearPlus, isOnline: true)
    public static let sydneyTenant  = ABUser(displayName: "Sydney Tenant",   username: "u/sydney_tenant",   durationInAustralia: .oneYearPlus)
    public static let confusedSon   = ABUser(displayName: "Confused Son",    username: "u/confused_son",    durationInAustralia: .oneToSix)
    public static let melbBoomer    = ABUser(displayName: "Melb Boomer",     username: "u/melb_boomer",     durationInAustralia: .oneYearPlus)
    public static let villageSales  = ABUser(displayName: "Bayside Living",  username: "u/bayside_living",  durationInAustralia: .oneYearPlus)
    public static let movedTwice    = ABUser(displayName: "Moved Twice",     username: "u/moved_twice",     durationInAustralia: .oneYearPlus)
    public static let dmMeFriend    = ABUser(displayName: "Helpful Pal",     username: "u/helpful_pal",     durationInAustralia: .oneYearPlus)
    public static let agedCareNurse = ABUser(displayName: "Aged Care Nurse", username: "u/agedcare_nurse",  durationInAustralia: .oneYearPlus, isOnline: true)

    // MARK: - Volunteers

    public static let volunteerSarah = ABVolunteer(
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

    public static let volunteerDavid = ABVolunteer(
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

    public static let volunteerChen = ABVolunteer(
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

    public static let matchResults: [ABMatchResult] = [
        ABMatchResult(volunteer: volunteerSarah, matchPercentage: 98, isTopChoice: true,
                      matchReasons: ["Same university background", "Housing expertise matches your need"]),
        ABMatchResult(volunteer: volunteerDavid, matchPercentage: 82,
                      matchReasons: ["Visa expertise", "Legal background"]),
        ABMatchResult(volunteer: volunteerChen, matchPercentage: 75,
                      matchReasons: ["Student-to-career transition", "Tech industry"]),
    ]

    // MARK: - Q&A Posts

    public static let qaPosts: [ABQAPost] = [
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

    // MARK: - Q&A Comments
    //
    // Flat (non-threaded) comments tied to qaPosts via postID. Tone is
    // calibrated by parent post verification state — see docs/spec.md §5.
    // We render <= 5 per post; commentCount on the parent ABQAPost may
    // exceed comments.count by design (mirrors paginated Reddit behavior).

    public static let qaComments: [ABQAComment] = [

        // ── Post 0 — VERIFIED. Tone: settled, supportive, additive data points. ──
        ABQAComment(
            postID: qaPosts[0].id,
            author: chatswoodGran,
            content: "Chatswood was the right move for us. The train into the city is step-free at our end and there's a good GP across from the station. Worth the slightly higher rent.",
            voteCount: 47,
            createdAt: Date().addingTimeInterval(-3 * 3600),
            isVerified: true
        ),
        ABQAComment(
            postID: qaPosts[0].id,
            author: nswHousingMod,
            content: "Good summary in the top answer. I'd add Burwood and Strathfield to the list — both have express trains and the council senior centres are very active.",
            voteCount: 31,
            createdAt: Date().addingTimeInterval(-2 * 3600)
        ),
        ABQAComment(
            postID: qaPosts[0].id,
            author: quietRetiree,
            content: "Thank you for asking this. I've been quietly reading and it helps to see real names of suburbs rather than \"somewhere on the North Shore\".",
            voteCount: 18,
            createdAt: Date().addingTimeInterval(-90 * 60)
        ),
        ABQAComment(
            postID: qaPosts[0].id,
            author: strathfieldR,
            content: "One small data point: the Gold Opal cap means you can ride all day for $2.50 if you're a pensioner. Made a huge difference for us once we figured it out.",
            voteCount: 12,
            createdAt: Date().addingTimeInterval(-45 * 60)
        ),

        // ── Post 1 — OLD LAW. Tone: contradictory; users themselves confused. ──
        ABQAComment(
            postID: qaPosts[1].id,
            author: oldRenter88,
            content: "Pretty sure the lease just rolls over to the new owner. That's how it worked when our building got sold in 2019, no one had to move.",
            voteCount: 22,
            createdAt: Date().addingTimeInterval(-7 * 3600)
        ),
        ABQAComment(
            postID: qaPosts[1].id,
            author: leaseLawyerAU,
            content: "Careful — the rules around \"sale of premises\" termination notices were tightened in the 2024 NSW reforms. The advice you're seeing in older threads is not current. Please don't rely on it.",
            voteCount: 64,
            createdAt: Date().addingTimeInterval(-5 * 3600),
            isVerified: true
        ),
        ABQAComment(
            postID: qaPosts[1].id,
            author: sydneyTenant,
            content: "I went through this last month. Got a 30-day notice, not 90. The agent claimed \"new rules\". Honestly I gave up trying to fight it because nothing online matched.",
            voteCount: 41,
            createdAt: Date().addingTimeInterval(-4 * 3600)
        ),
        ABQAComment(
            postID: qaPosts[1].id,
            author: confusedSon,
            content: "My mum's in this exact situation right now and every site says something different. If anyone has a link to the actual current Fair Trading page that would help.",
            voteCount: 9,
            createdAt: Date().addingTimeInterval(-2 * 3600)
        ),

        // ── Post 2 — TIKTOK / UNVERIFIED. Tone: chaotic, sales pitch + DM-shilling. ──
        ABQAComment(
            postID: qaPosts[2].id,
            author: melbBoomer,
            content: "Independent living is way cheaper if you're still mobile. We pay about half what our friends pay in a rental village and we don't deal with body corp drama.",
            voteCount: 19,
            createdAt: Date().addingTimeInterval(-12 * 3600)
        ),
        ABQAComment(
            postID: qaPosts[2].id,
            author: villageSales,
            content: "Hi! We have a few new 2-bedroom units opening in Brighton this June with full chef-prepared meals included. DM me for a private tour, mention this thread for a free welcome pack.",
            voteCount: 3,
            createdAt: Date().addingTimeInterval(-9 * 3600)
        ),
        ABQAComment(
            postID: qaPosts[2].id,
            author: movedTwice,
            content: "We tried both. Rental village was lovely until the operator changed hands and the fees jumped 22% in one year. Read the contract twice. Then read it again.",
            voteCount: 78,
            createdAt: Date().addingTimeInterval(-7 * 3600)
        ),
        ABQAComment(
            postID: qaPosts[2].id,
            author: dmMeFriend,
            content: "I have a spreadsheet comparing 14 villages around Melbourne, happy to share — just DM me, don't want to post it publicly.",
            voteCount: 6,
            createdAt: Date().addingTimeInterval(-5 * 3600)
        ),
        ABQAComment(
            postID: qaPosts[2].id,
            author: agedCareNurse,
            content: "As someone who works in the sector — please be very careful with the TikTok comparisons. Costs vary enormously by contract type (DMF vs leasehold vs licence). Talk to someone independent before signing.",
            voteCount: 54,
            createdAt: Date().addingTimeInterval(-3 * 3600),
            isVerified: true
        ),
    ]

    /// Flat comments belonging to a specific post, ordered chronologically.
    public static func comments(for postID: UUID) -> [ABQAComment] {
        qaComments.filter { $0.postID == postID }
                  .sorted { $0.createdAt < $1.createdAt }
    }

    // MARK: - Conversations

    public static let conversations: [ABConversation] = [
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

    public static let chatMessages: [ABChatMessage] = [
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

    public static let chatContext = ABSharedContext(
        title: "Renting rights when landlord sells",
        relatedPostID: qaPosts[1].id
    )

    // MARK: - Context Actions

    public static let contextActions: [ABContextAction] = [
        ABContextAction(text: "Share My Profile Tags", icon: "person.text.rectangle", variant: .blue),
        ABContextAction(text: "Ask about the Q&A post", icon: "text.bubble", variant: .blue),
        ABContextAction(text: "Suggest a 5-min call", icon: "phone.fill", variant: .orange),
    ]

    // MARK: - Service Categories

    public static let serviceCategories: [ABServiceCategory] = ABServiceCategoryType.allCases.enumerated().map { index, type in
        ABServiceCategory(type: type, displayOrder: index)
    }

    // MARK: - Guides

    public static let guides: [ABGuide] = [
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

    public static let helpRequests: [ABHelpRequest] = [
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
