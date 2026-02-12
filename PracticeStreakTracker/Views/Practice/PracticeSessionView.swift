import SwiftUI
import Combine

// MARK: - Practice Session View
/// A mock exercise flow that simulates completing a speech therapy practice session.
/// In the real app, this would contain actual R-sound exercises. Here, it shows a
/// progress animation with encouraging prompts, then marks the day as practiced.
struct PracticeSessionView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentStep = 0
    @State private var progress: Double = 0.0
    @State private var isCompleted = false
    @State private var elapsed: Double = 0.0
    @State private var isTimerRunning = false
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    /// Personalized exercises loaded from the ViewModel based on user's speech sound selection
    private var exercises: [ExerciseStep] {
        viewModel.personalizedExercises
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isCompleted {
                    completionView
                } else {
                    exerciseView
                }
            }
            .background(Color.tsGroupedBackground.ignoresSafeArea())
            .navigationTitle("R-Sound Practice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isCompleted {
                        Button("Cancel") {
                            isTimerRunning = false
                            dismiss()
                        }
                    }
                }
            }
        }
        .interactiveDismissDisabled(isCompleted)
        .onAppear { isTimerRunning = true }
        .onReceive(timer) { _ in
            guard isTimerRunning else { return }
            timerTick()
        }
    }
    
    // MARK: - Exercise View
    /// Shows the current exercise step with a progress ring and instructions.
    private var exerciseView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.tsSecondaryFallback.opacity(0.15), lineWidth: 12)
                    .frame(width: 180, height: 180)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient.tsPrimaryGradient,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: progress)
                
                VStack(spacing: 4) {
                    Image(systemName: currentExercise.icon)
                        .font(.system(size: 36))
                        .foregroundColor(.tsSecondaryFallback)
                    
                    Text("\(currentStep + 1)/\(exercises.count)")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)
                }
            }
            
            // Exercise Info
            VStack(spacing: 12) {
                Text(currentExercise.title)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(currentExercise.instruction)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Overall progress bar
            VStack(spacing: 8) {
                ProgressView(value: Double(currentStep), total: Double(exercises.count))
                    .tint(Color.tsSecondaryFallback)
                    .padding(.horizontal, 40)
                
                Text("Step \(currentStep + 1) of \(exercises.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Completion View
    /// Shown after all exercises are done. Confirms practice was recorded.
    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .scaleEffect(isCompleted ? 1.0 : 0.5)
                .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isCompleted)
            
            Text("Practice Complete!")
                .font(.title.weight(.bold))
                .foregroundColor(.primary)
            
            Text("Your streak has been updated. Keep up the great work!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if viewModel.currentStreak > 0 {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(LinearGradient.streakGradient)
                    Text("\(viewModel.currentStreak) day streak!")
                        .font(.headline)
                        .foregroundColor(.streakFire)
                }
                .padding(.top, 8)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient.tsPrimaryGradient)
                    )
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Timer Logic
    
    private var currentExercise: ExerciseStep {
        exercises[min(currentStep, exercises.count - 1)]
    }
    
    /// Called every 0.1s by the Combine timer.
    /// Advances progress for the current step, then moves to the next step.
    private func timerTick() {
        let stepDuration = Double(currentExercise.durationSeconds)
        elapsed += 0.1
        progress = min(elapsed / stepDuration, 1.0)
        
        if elapsed >= stepDuration {
            HapticService.shared.lightImpact()
            
            if currentStep < exercises.count - 1 {
                currentStep += 1
                elapsed = 0
                progress = 0
            } else {
                completeSession()
            }
        }
    }
    
    private func completeSession() {
        isTimerRunning = false
        viewModel.markTodayAsPracticed()
        withAnimation(.spring(response: 0.5)) {
            isCompleted = true
        }
    }
}

// MARK: - Exercise Step Model
/// Represents one step in the mock practice session.
struct ExerciseStep {
    let title: String
    let instruction: String
    let icon: String
    let durationSeconds: Int
}
