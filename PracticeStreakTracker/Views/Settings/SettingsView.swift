import SwiftUI

// MARK: - Settings View
/// App settings including notification preferences, reminder timing, and data management.
struct SettingsView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @State private var showResetConfirmation = false
    @State private var reminderTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                // Appearance Section
                appearanceSection
                
                // Notifications Section
                notificationsSection
                
                // About Section
                aboutSection
                
                // Data Management Section
                dataSection
            }
            .navigationTitle("Settings")
            .onAppear {
                // Sync the date picker with stored hour/minute
                var components = DateComponents()
                components.hour = viewModel.notificationHour
                components.minute = viewModel.notificationMinute
                if let date = Calendar.current.date(from: components) {
                    reminderTime = date
                }
            }
        }
    }
    
    // MARK: - Appearance Section
    private var appearanceSection: some View {
        Section {
            HStack {
                Label {
                    Text("Dark Mode")
                } icon: {
                    Image(systemName: viewModel.isDarkMode ? "moon.fill" : "sun.max.fill")
                        .foregroundColor(viewModel.isDarkMode ? .celebrationPurple : .streakGold)
                }
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { viewModel.isDarkMode },
                    set: { _ in viewModel.toggleDarkMode() }
                ))
                .tint(Color.tsSecondaryFallback)
            }
            .accessibilityLabel("Dark Mode \(viewModel.isDarkMode ? "enabled" : "disabled")")
        } header: {
            Text("Appearance")
        } footer: {
            Text("Switch between light and dark theme for the app.")
        }
    }
    
    // MARK: - Notifications Section
    private var notificationsSection: some View {
        Section {
            // Toggle notifications on/off
            HStack {
                Label {
                    Text("Daily Reminders")
                } icon: {
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(.tsSecondaryFallback)
                }
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { viewModel.notificationsEnabled },
                    set: { _ in
                        Task { await viewModel.toggleNotifications() }
                    }
                ))
                .tint(Color.tsSecondaryFallback)
            }
            .accessibilityLabel("Daily reminders \(viewModel.notificationsEnabled ? "enabled" : "disabled")")
            
            // Reminder time picker (only shown if enabled)
            if viewModel.notificationsEnabled {
                DatePicker(
                    selection: $reminderTime,
                    displayedComponents: .hourAndMinute
                ) {
                    Label {
                        Text("Reminder Time")
                    } icon: {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.streakFire)
                    }
                }
                .onChange(of: reminderTime) { _, newTime in
                    let components = Calendar.current.dateComponents([.hour, .minute], from: newTime)
                    viewModel.updateNotificationTime(
                        hour: components.hour ?? 20,
                        minute: components.minute ?? 0
                    )
                }
                .accessibilityLabel("Reminder time")
            }
        } header: {
            Text("Notifications")
        } footer: {
            Text("Receive a gentle reminder to practice each day at your preferred time.")
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        Section {
            HStack {
                Label {
                    Text("App")
                } icon: {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.tsSecondaryFallback)
                }
                Spacer()
                Text("Practice Streak Tracker")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label {
                    Text("Version")
                } icon: {
                    Image(systemName: "number.circle.fill")
                        .foregroundColor(.tsAccentFallback)
                }
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
            Link(destination: URL(string: "https://topspeech.health")!) {
                HStack {
                    Label {
                        Text("TopSpeech Health")
                    } icon: {
                        Image(systemName: "link.circle.fill")
                            .foregroundColor(.tsPrimaryFallback)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)
        } header: {
            Text("About")
        }
    }
    
    // MARK: - Data Section
    private var dataSection: some View {
        Section {
            Button(role: .destructive) {
                showResetConfirmation = true
            } label: {
                Label {
                    Text("Reset All Data")
                        .foregroundColor(.red)
                } icon: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }
            }
            .accessibilityLabel("Reset all data")
            .accessibilityHint("Double tap to reset all practice data. This cannot be undone.")
        } header: {
            Text("Data Management")
        } footer: {
            Text("This will permanently delete all practice history, streaks, and freeze data. This action cannot be undone.")
        }
        .alert("Reset All Data?", isPresented: $showResetConfirmation) {
            Button("Reset", role: .destructive) {
                viewModel.resetAllData()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All practice history, streaks, and earned freezes will be permanently deleted. This cannot be undone.")
        }
    }
}
