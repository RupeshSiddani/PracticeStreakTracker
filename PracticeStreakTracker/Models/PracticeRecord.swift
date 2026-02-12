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
    
    static let `default` = UserData(
        records: [],
        freezesAvailable: 2,
        celebratedMilestones: [],
        notificationsEnabled: false,
        preferredNotificationHour: 20,  // 8 PM default
        preferredNotificationMinute: 0
    )
}
