import SwiftUI

// MARK: - Streak Freeze Sheet
/// Bottom sheet allowing users to view and use their streak freezes.
/// Freezes protect the streak for 1 day when the user can't practice.
/// Users earn 1 freeze per 7 consecutive practice days (max 5).
struct StreakFreezeSheet: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Ice crystal illustration
                ZStack {
                    Circle()
                        .fill(Color.streakFreeze.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "snowflake")
                        .font(.system(size: 48))
                        .foregroundColor(.streakFreeze)
                }
                .padding(.top, 20)
                
                // Title & description
                VStack(spacing: 8) {
                    Text("Streak Freezes")
                        .font(.title2.weight(.bold))
                    
                    Text("Protect your streak on days you can't practice. Use a freeze to keep your streak alive without practicing.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                // Freeze count display
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < viewModel.freezesAvailable ? "snowflake.circle.fill" : "snowflake.circle")
                            .font(.title2)
                            .foregroundColor(index < viewModel.freezesAvailable ? .streakFreeze : .secondary.opacity(0.3))
                    }
                }
                .padding(.vertical, 8)
                
                Text("\(viewModel.freezesAvailable) of 5 freezes available")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.secondary)
                
                // How to earn freezes
                VStack(alignment: .leading, spacing: 12) {
                    Text("How to Earn Freezes")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.streakFire)
                            .frame(width: 24)
                        Text("Practice for 7 consecutive days to earn 1 additional freeze (max 5).")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "shield.fill")
                            .foregroundColor(.tsSecondaryFallback)
                            .frame(width: 24)
                        Text("Each freeze protects your streak for 1 day. Use them wisely!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.tsSecondaryBackground)
                )
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Use freeze button
                if !viewModel.hasPracticedToday && !viewModel.isFrozenToday {
                    Button {
                        showConfirmation = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "snowflake")
                            Text("Use a Freeze for Today")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.freezesAvailable > 0
                                      ? LinearGradient.freezeGradient
                                      : LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing))
                        )
                        .foregroundColor(.white)
                    }
                    .disabled(viewModel.freezesAvailable == 0)
                    .padding(.horizontal, 24)
                } else {
                    // Already practiced or frozen today
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.hasPracticedToday ? "checkmark.circle.fill" : "snowflake.circle.fill")
                            .foregroundColor(viewModel.hasPracticedToday ? .green : .streakFreeze)
                        Text(viewModel.hasPracticedToday ? "Already practiced today!" : "Streak is protected today!")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(viewModel.hasPracticedToday ? .green : .streakFreeze)
                    }
                    .padding(.vertical, 12)
                }
                
                Spacer().frame(height: 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Use Streak Freeze?", isPresented: $showConfirmation) {
                Button("Use Freeze", role: .destructive) {
                    viewModel.useStreakFreeze()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will protect your streak for today. You'll have \(viewModel.freezesAvailable - 1) freezes remaining.")
            }
        }
    }
}
