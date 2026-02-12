import Foundation
import Combine
import SwiftUI

// MARK: - Streak ViewModel
/// Central ViewModel managing all streak-related business logic.
/// Follows MVVM pattern with published properties for reactive UI updates.
@MainActor
final class StreakViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var records: [PracticeRecord] = []
    @Published private(set) var currentStreak: Int = 0
    @Published private(set) var longestStreak: Int = 0
    @Published private(set) var freezesAvailable: Int = 2
    @Published private(set) var hasPracticedToday: Bool = false
    @Published private(set) var isFrozenToday: Bool = false
    
    @Published var notificationsEnabled: Bool = false
    @Published var notificationHour: Int = 20
    @Published var notificationMinute: Int = 0
    
    @Published var showMilestoneCelebration: Bool = false
    @Published var currentMilestone: Milestone? = nil
    @Published private(set) var celebratedMilestones: [Int] = []
    
    @Published var showPracticeSession: Bool = false
    @Published var practiceProgress: Double = 0.0
    
    @Published var userProfile: UserProfile = .default
    
    // MARK: - Private Properties
    
    private let persistence = PersistenceService.shared
    private let notifications = NotificationService.shared
    private let haptics = HapticService.shared
    
    private var userData: UserData
    
    // MARK: - Constants
    
    /// Days of consistent practice required to earn a freeze
    private let daysPerFreezeEarned = 7
    /// Maximum freezes a user can hold
    private let maxFreezes = 5
    
    // MARK: - Initialization
    
    init() {
        self.userData = PersistenceService.shared.load()
        self.records = userData.records
        self.freezesAvailable = userData.freezesAvailable
        self.celebratedMilestones = userData.celebratedMilestones
        self.notificationsEnabled = userData.notificationsEnabled
        self.notificationHour = userData.preferredNotificationHour
        self.notificationMinute = userData.preferredNotificationMinute
        self.userProfile = userData.userProfile
        
        recalculateStreaks()
        checkTodayStatus()
        checkFreezeEarnings()
    }
    
    // MARK: - Practice Actions
    
    /// Marks today as practiced and updates all related state
    func markTodayAsPracticed() {
        guard !hasPracticedToday else { return }
        
        let record = PracticeRecord(date: Date(), type: .practiced)
        records.append(record)
        hasPracticedToday = true
        
        recalculateStreaks()
        checkForMilestone()
        checkFreezeEarnings()
        save()
        
        haptics.success()
    }
    
    /// Uses a streak freeze to protect today's streak
    func useStreakFreeze() {
        guard !hasPracticedToday && !isFrozenToday && freezesAvailable > 0 else {
            haptics.error()
            return
        }
        
        let record = PracticeRecord(date: Date(), type: .frozen)
        records.append(record)
        freezesAvailable -= 1
        isFrozenToday = true
        
        recalculateStreaks()
        save()
        
        haptics.mediumImpact()
    }
    
    // MARK: - Notification Management
    
    /// Toggles notifications on/off
    func toggleNotifications() async {
        if !notificationsEnabled {
            let granted = await notifications.requestPermission()
            if granted {
                notificationsEnabled = true
                notifications.scheduleDailyReminder(hour: notificationHour, minute: notificationMinute)
            } else {
                notificationsEnabled = false
            }
        } else {
            notificationsEnabled = false
            notifications.cancelDailyReminder()
        }
        save()
    }
    
    /// Updates the preferred notification time
    func updateNotificationTime(hour: Int, minute: Int) {
        notificationHour = hour
        notificationMinute = minute
        if notificationsEnabled {
            notifications.scheduleDailyReminder(hour: hour, minute: minute)
        }
        save()
    }
    
    // MARK: - Milestone Management
    
    /// Dismisses the current milestone celebration
    func dismissMilestone() {
        showMilestoneCelebration = false
        currentMilestone = nil
    }
    
    // MARK: - Onboarding
    
    /// Saves the user profile after onboarding completes
    func completeOnboarding(profile: UserProfile) {
        userProfile = profile
        save()
        haptics.success()
    }
    
    /// Whether onboarding has been completed
    var isOnboardingComplete: Bool {
        userProfile.onboardingCompleted
    }
    
    /// Returns personalized exercises based on user's selected sounds.
    /// Picks exercises from the first selected sound for each session,
    /// rotating through sounds across sessions.
    var personalizedExercises: [ExerciseStep] {
        let sounds = userProfile.selectedSounds
        guard !sounds.isEmpty else {
            return SpeechSound.r.exercises
        }
        // Rotate through sounds based on total practice days
        let dayIndex = records.filter { $0.type == .practiced }.count
        let sound = sounds[dayIndex % sounds.count]
        return sound.exercises
    }
    
    /// Returns the current practice sound name
    var currentPracticeSoundName: String {
        let sounds = userProfile.selectedSounds
        guard !sounds.isEmpty else { return "R" }
        let dayIndex = records.filter { $0.type == .practiced }.count
        let sound = sounds[dayIndex % sounds.count]
        return sound.displayName
    }
    
    // MARK: - Data Management
    
    /// Resets all user data
    func resetAllData() {
        persistence.resetAll()
        userData = UserData.default
        records = []
        freezesAvailable = 2
        celebratedMilestones = []
        currentStreak = 0
        longestStreak = 0
        hasPracticedToday = false
        isFrozenToday = false
        notificationsEnabled = false
        userProfile = .default
        notifications.cancelDailyReminder()
        
        haptics.warning()
    }
    
    // MARK: - Calendar Data
    
    /// Returns the record type for a specific date (for heatmap display)
    func recordType(for date: Date) -> PracticeRecord.RecordType? {
        let targetDay = Calendar.current.startOfDay(for: date)
        return records.first(where: { Calendar.current.isDate($0.date, inSameDayAs: targetDay) })?.type
    }
    
    /// Returns all practice dates as a Set of date keys for fast lookup
    var practiceDateKeys: Set<String> {
        Set(records.map { $0.dateKey })
    }
    
    // MARK: - Statistics
    
    /// Computes comprehensive streak statistics
    var statistics: StreakStatistics {
        let practiceDays = records.filter { $0.type == .practiced }
        let freezeDays = records.filter { $0.type == .frozen }
        
        // Best practice weekday
        let weekdayCounts = Dictionary(grouping: practiceDays, by: { $0.date.weekday })
        let bestWeekday = weekdayCounts.max(by: { $0.value.count < $1.value.count })
        let bestWeekdayName: String? = bestWeekday.map { entry in
            let formatter = DateFormatter()
            formatter.weekdaySymbols = formatter.weekdaySymbols
            return formatter.weekdaySymbols[entry.key - 1]
        }
        
        // Average streak length
        let allStreaks = calculateAllStreakLengths()
        let averageStreak = allStreaks.isEmpty ? 0 : Double(allStreaks.reduce(0, +)) / Double(allStreaks.count)
        
        // Current streak start date
        let startDate = currentStreakStartDate()
        
        return StreakStatistics(
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            totalPracticeDays: practiceDays.count,
            totalFreezeUsed: freezeDays.count,
            freezesAvailable: freezesAvailable,
            bestPracticeWeekday: bestWeekdayName,
            averageStreakLength: averageStreak,
            currentStreakStartDate: startDate
        )
    }
    
    /// Returns progress toward the next milestone (0.0 to 1.0)
    var nextMilestoneProgress: (milestone: Milestone, progress: Double)? {
        guard let next = Milestone.nextMilestone(after: currentStreak) else { return nil }
        let previousMilestoneDay = Milestone.all.last(where: { $0.days < next.days })?.days ?? 0
        let totalNeeded = next.days - previousMilestoneDay
        let achieved = currentStreak - previousMilestoneDay
        let progress = min(Double(achieved) / Double(totalNeeded), 1.0)
        return (next, progress)
    }
    
    // MARK: - Private Helpers
    
    /// Recalculates current and longest streaks from the record history
    private func recalculateStreaks() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Build a set of all "active" dates (practiced or frozen)
        let activeDates = Set(records.map { calendar.startOfDay(for: $0.date) })
        
        // Calculate current streak (counting backwards from today)
        var streak = 0
        var checkDate = today
        
        // If today hasn't been marked yet, start checking from yesterday
        if !activeDates.contains(today) {
            checkDate = calendar.date(byAdding: .day, value: -1, to: today)!
            // If yesterday also isn't active, streak is 0
            if !activeDates.contains(checkDate) {
                currentStreak = 0
                updateLongestStreak()
                return
            }
        }
        
        while activeDates.contains(checkDate) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = previousDay
        }
        
        currentStreak = streak
        updateLongestStreak()
    }
    
    /// Updates the longest streak if current streak exceeds it
    private func updateLongestStreak() {
        let allStreaks = calculateAllStreakLengths()
        longestStreak = allStreaks.max() ?? 0
    }
    
    /// Calculates all individual streak lengths from the record history
    private func calculateAllStreakLengths() -> [Int] {
        let calendar = Calendar.current
        let sortedDates = Set(records.map { calendar.startOfDay(for: $0.date) }).sorted()
        
        guard !sortedDates.isEmpty else { return [] }
        
        var streaks: [Int] = []
        var currentLength = 1
        
        for i in 1..<sortedDates.count {
            let daysBetween = calendar.dateComponents([.day], from: sortedDates[i-1], to: sortedDates[i]).day ?? 0
            if daysBetween == 1 {
                currentLength += 1
            } else {
                streaks.append(currentLength)
                currentLength = 1
            }
        }
        streaks.append(currentLength)
        
        return streaks
    }
    
    /// Returns the start date of the current streak
    private func currentStreakStartDate() -> Date? {
        guard currentStreak > 0 else { return nil }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let activeDates = Set(records.map { calendar.startOfDay(for: $0.date) })
        
        var checkDate = activeDates.contains(today) ? today : today.addingDays(-1)
        var startDate = checkDate
        
        while activeDates.contains(checkDate) {
            startDate = checkDate
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = previousDay
        }
        
        return startDate
    }
    
    /// Checks if the user has practiced or used a freeze today
    private func checkTodayStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        for record in records {
            if Calendar.current.isDate(record.date, inSameDayAs: today) {
                if record.type == .practiced {
                    hasPracticedToday = true
                } else if record.type == .frozen {
                    isFrozenToday = true
                }
            }
        }
    }
    
    /// Checks if user has earned new freezes through consistent practice
    private func checkFreezeEarnings() {
        let practiceDays = records.filter { $0.type == .practiced }.count
        let totalFreezeUsed = records.filter { $0.type == .frozen }.count
        
        // Earn 1 freeze per 7 practice days, minus freezes already used/available
        let totalEarned = practiceDays / daysPerFreezeEarned
        let baseFreezes = 2  // Starting freezes
        let totalShouldHave = min(baseFreezes + totalEarned - totalFreezeUsed, maxFreezes)
        
        if totalShouldHave > freezesAvailable {
            freezesAvailable = totalShouldHave
        }
    }
    
    /// Checks if the current streak has reached a new milestone
    private func checkForMilestone() {
        guard let milestone = Milestone.milestone(for: currentStreak),
              !celebratedMilestones.contains(milestone.days) else { return }
        
        celebratedMilestones.append(milestone.days)
        currentMilestone = milestone
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            showMilestoneCelebration = true
            haptics.heavyImpact()
        }
    }
    
    /// Persists current state to storage
    private func save() {
        userData.records = records
        userData.freezesAvailable = freezesAvailable
        userData.celebratedMilestones = celebratedMilestones
        userData.notificationsEnabled = notificationsEnabled
        userData.preferredNotificationHour = notificationHour
        userData.preferredNotificationMinute = notificationMinute
        userData.userProfile = userProfile
        
        do {
            try persistence.save(userData)
        } catch {
            print("[StreakViewModel] Failed to save: \(error.localizedDescription)")
        }
    }
}
