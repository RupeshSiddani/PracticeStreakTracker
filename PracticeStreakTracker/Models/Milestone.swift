import Foundation

// MARK: - Milestone
/// Represents a streak milestone achievement
struct Milestone: Identifiable {
    let id = UUID()
    let days: Int
    let title: String
    let description: String
    let symbolName: String  // SF Symbol name
    
    /// All defined milestones in ascending order
    static let all: [Milestone] = [
        Milestone(days: 3, title: "Getting Started", description: "3 days of practice! You're building a habit.", symbolName: "flame"),
        Milestone(days: 7, title: "One Week Strong", description: "A full week of dedication to your speech journey.", symbolName: "star.fill"),
        Milestone(days: 14, title: "Two Week Warrior", description: "14 days! Consistency is becoming second nature.", symbolName: "shield.fill"),
        Milestone(days: 21, title: "Habit Formed", description: "21 days — they say it takes this long to form a habit!", symbolName: "brain.head.profile"),
        Milestone(days: 30, title: "Monthly Master", description: "A full month of practice. Incredible commitment!", symbolName: "crown.fill"),
        Milestone(days: 60, title: "Two Month Champion", description: "60 days of consistent effort. You're unstoppable.", symbolName: "trophy.fill"),
        Milestone(days: 90, title: "Quarter Year Hero", description: "90 days! Your dedication is truly inspiring.", symbolName: "medal.fill"),
        Milestone(days: 100, title: "Century Club", description: "100 days of practice. A remarkable achievement!", symbolName: "checkmark.seal.fill"),
        Milestone(days: 180, title: "Half Year Legend", description: "6 months of daily practice. You're transforming your speech.", symbolName: "sparkles"),
        Milestone(days: 365, title: "One Year Milestone", description: "365 days! A full year of commitment to your growth.", symbolName: "star.circle.fill")
    ]
    
    /// Returns the milestone for a given streak count, if one exists
    static func milestone(for streakCount: Int) -> Milestone? {
        all.first(where: { $0.days == streakCount })
    }
    
    /// Returns the next upcoming milestone for a given streak count
    static func nextMilestone(after streakCount: Int) -> Milestone? {
        all.first(where: { $0.days > streakCount })
    }
}
