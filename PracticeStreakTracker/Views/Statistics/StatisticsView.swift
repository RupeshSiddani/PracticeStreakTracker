import SwiftUI

// MARK: - Statistics View
/// Displays detailed practice statistics and insights.
/// Helps users understand their practice patterns and progress.
struct StatisticsView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    
    private var stats: StreakStatistics {
        viewModel.statistics
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Overview Cards
                    overviewSection
                    
                    // Streaks Section
                    streaksSection
                    
                    // Practice Patterns
                    patternsSection
                    
                    // Milestones Achieved
                    milestonesSection
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color.tsGroupedBackground.ignoresSafeArea())
            .navigationTitle("Statistics")
        }
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Overview")
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statCard(
                    title: "Total Practice Days",
                    value: "\(stats.totalPracticeDays)",
                    icon: "calendar.badge.checkmark",
                    color: .tsSecondaryFallback
                )
                statCard(
                    title: "Freezes Used",
                    value: "\(stats.totalFreezeUsed)",
                    icon: "snowflake",
                    color: .streakFreeze
                )
                statCard(
                    title: "Freezes Available",
                    value: "\(stats.freezesAvailable)",
                    icon: "snowflake.circle",
                    color: .streakFreeze.opacity(0.7)
                )
                statCard(
                    title: "Avg Streak Length",
                    value: String(format: "%.1f", stats.averageStreakLength),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .tsAccentFallback
                )
            }
        }
    }
    
    // MARK: - Streaks Section
    private var streaksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Streaks")
            
            VStack(spacing: 0) {
                streakRow(
                    title: "Current Streak",
                    value: "\(stats.currentStreak) days",
                    icon: "flame.fill",
                    color: .streakFire,
                    showDivider: true
                )
                
                streakRow(
                    title: "Longest Streak",
                    value: "\(stats.longestStreak) days",
                    icon: "trophy.fill",
                    color: .streakGold,
                    showDivider: true
                )
                
                if let startDate = stats.currentStreakStartDate {
                    streakRow(
                        title: "Streak Started",
                        value: startDate.shortDateString,
                        icon: "calendar",
                        color: .tsSecondaryFallback,
                        showDivider: false
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.tsBackground)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    // MARK: - Patterns Section
    private var patternsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Practice Patterns")
            
            VStack(spacing: 0) {
                if let bestDay = stats.bestPracticeWeekday {
                    streakRow(
                        title: "Best Practice Day",
                        value: bestDay,
                        icon: "star.fill",
                        color: .celebrationYellow,
                        showDivider: false
                    )
                } else {
                    HStack {
                        Text("Start practicing to see your patterns!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(16)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.tsBackground)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    // MARK: - Milestones Section
    private var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Milestones")
            
            VStack(spacing: 0) {
                ForEach(Array(Milestone.all.enumerated()), id: \.element.days) { index, milestone in
                    let isAchieved = viewModel.celebratedMilestones.contains(milestone.days)
                    
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(isAchieved ? Color.celebrationYellow.opacity(0.15) : Color.secondary.opacity(0.08))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: milestone.symbolName)
                                .font(.body)
                                .foregroundColor(isAchieved ? .celebrationYellow : .secondary.opacity(0.4))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(milestone.title)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(isAchieved ? .primary : .secondary)
                            Text("\(milestone.days) days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if isAchieved {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundColor(.secondary.opacity(0.4))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .accessibilityLabel("\(milestone.title), \(milestone.days) days, \(isAchieved ? "achieved" : "locked")")
                    
                    if index < Milestone.all.count - 1 {
                        Divider().padding(.leading, 70)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.tsBackground)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            )
        }
    }
    
    // MARK: - Reusable Components
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.horizontal, 4)
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.tsBackground)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
    
    private func streakRow(title: String, value: String, icon: String, color: Color, showDivider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            if showDivider {
                Divider().padding(.leading, 66)
            }
        }
    }
}
