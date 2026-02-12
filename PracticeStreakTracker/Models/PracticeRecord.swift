import Foundation

// MARK: - Practice Record
/// Represents a single day's practice activity
struct PracticeRecord: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    let type: RecordType
    
    enum RecordType: String, Codable {
        case practiced   // User completed a practice session
        case frozen      // Streak was protected by a freeze
    }
    
    init(id: UUID = UUID(), date: Date = Date(), type: RecordType = .practiced) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.type = type
    }
    
    /// Normalized date key for comparison (start of day)
    var dateKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

// MARK: - Streak Statistics
/// Aggregated streak statistics
struct StreakStatistics {
    let currentStreak: Int
    let longestStreak: Int
    let totalPracticeDays: Int
    let totalFreezeUsed: Int
    let freezesAvailable: Int
    let bestPracticeWeekday: String?
    let averageStreakLength: Double
    let currentStreakStartDate: Date?
}

// MARK: - User Data
/// Root data model persisted to storage
struct UserData: Codable {
    var records: [PracticeRecord]
    var freezesAvailable: Int
    var celebratedMilestones: [Int]
    var notificationsEnabled: Bool
    var preferredNotificationHour: Int
    var preferredNotificationMinute: Int
    var userProfile: UserProfile
    var isDarkMode: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        records = try container.decode([PracticeRecord].self, forKey: .records)
        freezesAvailable = try container.decode(Int.self, forKey: .freezesAvailable)
        celebratedMilestones = try container.decode([Int].self, forKey: .celebratedMilestones)
        notificationsEnabled = try container.decode(Bool.self, forKey: .notificationsEnabled)
        preferredNotificationHour = try container.decode(Int.self, forKey: .preferredNotificationHour)
        preferredNotificationMinute = try container.decode(Int.self, forKey: .preferredNotificationMinute)
        userProfile = try container.decodeIfPresent(UserProfile.self, forKey: .userProfile) ?? .default
        isDarkMode = try container.decodeIfPresent(Bool.self, forKey: .isDarkMode) ?? false
    }
    
    init(records: [PracticeRecord], freezesAvailable: Int, celebratedMilestones: [Int], notificationsEnabled: Bool, preferredNotificationHour: Int, preferredNotificationMinute: Int, userProfile: UserProfile, isDarkMode: Bool) {
        self.records = records
        self.freezesAvailable = freezesAvailable
        self.celebratedMilestones = celebratedMilestones
        self.notificationsEnabled = notificationsEnabled
        self.preferredNotificationHour = preferredNotificationHour
        self.preferredNotificationMinute = preferredNotificationMinute
        self.userProfile = userProfile
        self.isDarkMode = isDarkMode
    }
    
    static let `default` = UserData(
        records: [],
        freezesAvailable: 2,
        celebratedMilestones: [],
        notificationsEnabled: false,
        preferredNotificationHour: 20,  // 8 PM default
        preferredNotificationMinute: 0,
        userProfile: .default,
        isDarkMode: false
    )
}
