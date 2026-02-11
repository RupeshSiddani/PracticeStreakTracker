import SwiftUI

// MARK: - Dashboard View
/// Main dashboard displaying streak information, practice button, and calendar heatmap.
struct DashboardView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @State private var showFreezeSheet = false
    @State private var showPracticeSession = false
    @State private var animateStreak = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Streak Card
                    streakCard
                    
                    // Practice Button
                    practiceButton
                    
                    // Freeze Card
                    freezeCard
                    
                    // Next Milestone Progress
                    nextMilestoneCard
                    
                    // Calendar Heatmap
                    CalendarHeatmapView()
                        .padding(.top, 4)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color.tsGroupedBackground.ignoresSafeArea())
            .navigationTitle("Practice Streak")
            .sheet(isPresented: $showPracticeSession) {
                PracticeSessionView()
            }
            .sheet(isPresented: $showFreezeSheet) {
                StreakFreezeSheet()
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    animateStreak = true
                }
            }
        }
    }
    
    // MARK: - Streak Card
    
    private var streakCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                // Current Streak
                VStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(LinearGradient.streakGradient)
                        .scaleEffect(animateStreak ? 1.0 : 0.5)
                    
                    Text("\(viewModel.currentStreak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Current Streak")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 80)
                
                // Longest Streak
                VStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.streakGold)
                        .scaleEffect(animateStreak ? 1.0 : 0.5)
                    
                    Text("\(viewModel.longestStreak)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Longest Streak")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 8)
            
            // Today's status
            todayStatusBadge
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.tsBackground)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }
    
    // MARK: - Today Status Badge
    
    private var todayStatusBadge: some View {
        HStack(spacing: 8) {
            if viewModel.hasPracticedToday {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Practiced Today")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.green)
            } else if viewModel.isFrozenToday {
                Image(systemName: "snowflake")
                    .foregroundColor(.streakFreeze)
                Text("Streak Protected Today")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.streakFreeze)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Not Practiced Yet")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.orange)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(statusBackgroundColor.opacity(0.12))
        )
    }
    
    private var statusBackgroundColor: Color {
        if viewModel.hasPracticedToday { return .green }
        if viewModel.isFrozenToday { return .streakFreeze }
        return .orange
    }
    
    // MARK: - Practice Button
    
    private var practiceButton: some View {
        Button {
            if !viewModel.hasPracticedToday {
                showPracticeSession = true
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: viewModel.hasPracticedToday ? "checkmark.circle.fill" : "play.circle.fill")
                    .font(.title2)
                
                Text(viewModel.hasPracticedToday ? "Practice Complete!" : "Start Practice")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Group {
                    if viewModel.hasPracticedToday {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.green.opacity(0.15))
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient.tsPrimaryGradient)
                    }
                }
            )
            .foregroundColor(viewModel.hasPracticedToday ? .green : .white)
        }
        .disabled(viewModel.hasPracticedToday)
        .accessibilityLabel(viewModel.hasPracticedToday ? "Practice completed for today" : "Start practice session")
        .accessibilityHint(viewModel.hasPracticedToday ? "" : "Double tap to begin a practice session")
    }
    
    // MARK: - Freeze Card
    
    private var freezeCard: some View {
        Button {
            showFreezeSheet = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.streakFreeze.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "snowflake")
                        .font(.title3)
                        .foregroundColor(.streakFreeze)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Streak Freezes")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    Text("\(viewModel.freezesAvailable) available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.tsBackground)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            )
        }
        .accessibilityLabel("Streak Freezes. \(viewModel.freezesAvailable) available.")
        .accessibilityHint("Double tap to manage your streak freezes")
    }
    
    // MARK: - Next Milestone Card
    
    private var nextMilestoneCard: some View {
        Group {
            if let next = viewModel.nextMilestoneProgress {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: next.milestone.symbolName)
                            .foregroundColor(.tsSecondaryFallback)
                        Text("Next: \(next.milestone.title)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(viewModel.currentStreak)/\(next.milestone.days) days")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: next.progress)
                        .tint(Color.tsSecondaryFallback)
                        .accessibilityLabel("Progress to next milestone: \(Int(next.progress * 100)) percent")
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.tsBackground)
                        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                )
            }
        }
    }
}
