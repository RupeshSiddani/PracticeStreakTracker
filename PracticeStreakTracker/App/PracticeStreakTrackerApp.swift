import SwiftUI

@main
struct PracticeStreakTrackerApp: App {
    
    @StateObject private var viewModel = StreakViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.isOnboardingComplete {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(viewModel)
            .animation(.easeInOut(duration: 0.4), value: viewModel.isOnboardingComplete)
        }
    }
}
