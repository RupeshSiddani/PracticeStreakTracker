import SwiftUI

@main
struct PracticeStreakTrackerApp: App {
    
    @StateObject private var viewModel = StreakViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(viewModel)
                .preferredColorScheme(nil) // Supports both light and dark mode
        }
    }
}
