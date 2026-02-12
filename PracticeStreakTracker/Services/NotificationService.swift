import Foundation
import UserNotifications

// MARK: - Notification Service
/// Manages local push notifications for daily practice reminders.
final class NotificationService {
    
    static let shared = NotificationService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let dailyReminderIdentifier = "com.topspeech.streaktracker.dailyReminder"
    
    private init() {}
    
    // MARK: - Permission
    
    /// Requests notification authorization from the user
    /// - Returns: Whether permission was granted
    @discardableResult
    func requestPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("[NotificationService] Permission request failed: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Checks the current notification authorization status
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Schedule Reminders
    
    /// Schedules a daily practice reminder at the specified time
    /// - Parameters:
    ///   - hour: Hour component (0-23)
    ///   - minute: Minute component (0-59)
    func scheduleDailyReminder(hour: Int, minute: Int) {
        // Remove any existing reminder first
        cancelDailyReminder()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Practice!"
        content.body = encouragingMessages.randomElement() ?? "Your speech journey continues — just 15 minutes today."
        content.sound = .default
        content.categoryIdentifier = "PRACTICE_REMINDER"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: dailyReminderIdentifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("[NotificationService] Failed to schedule reminder: \(error.localizedDescription)")
            }
        }
    }
    
    /// Cancels the daily practice reminder
    func cancelDailyReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyReminderIdentifier])
    }
    
    // MARK: - Streak Reminder
    
    /// Schedules a reminder if user hasn't practiced today (called in the evening)
    func scheduleStreakAtRiskReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Don't Lose Your Streak!"
        content.body = "You haven't practiced today. A quick session will keep your streak alive."
        content.sound = .default
        
        // Trigger in 1 hour
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
        let request = UNNotificationRequest(
            identifier: "com.topspeech.streaktracker.streakAtRisk",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    // MARK: - Encouraging Messages
    
    private let encouragingMessages = [
        "Your speech journey continues — just 15 minutes today.",
        "Small steps lead to big changes. Ready to practice?",
        "Consistency is your superpower. Let's keep the streak going!",
        "Every practice session brings you closer to your goals.",
        "You're doing amazing! Time for today's practice.",
        "15 minutes can make a real difference. Let's go!",
        "Your future self will thank you. Time to practice!",
        "Progress happens one day at a time. Ready?",
        "Keep the momentum going — your streak is counting on you!",
        "Another day, another step forward. Let's practice!"
    ]
}
