import SwiftUI

// MARK: - Main Tab View
/// Root navigation view with tab bar for the main app sections.
struct MainTabView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "flame.fill")
                    }
                    .tag(0)
                
                StatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar.fill")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }
            .tint(Color.tsSecondaryFallback)
            
            // Milestone celebration overlay
            if viewModel.showMilestoneCelebration, let milestone = viewModel.currentMilestone {
                MilestoneCelebrationView(milestone: milestone) {
                    viewModel.dismissMilestone()
                }
                .transition(.opacity.combined(with: .scale))
                .zIndex(100)
            }
        }
        .animation(.spring(response: 0.5), value: viewModel.showMilestoneCelebration)
    }
}
