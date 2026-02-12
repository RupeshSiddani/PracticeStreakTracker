import SwiftUI

// MARK: - Onboarding View
/// Simplified 3-step onboarding for rhotacism therapy.
/// Collects user's name and age group, then starts R-sound practice.
struct OnboardingView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @State private var currentPage = 0
    @State private var name = ""
    @State private var selectedAge: AgeGroup = .adult
    @FocusState private var isNameFieldFocused: Bool
    
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.tsPrimaryFallback.opacity(0.08), Color.tsSecondaryFallback.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .onTapGesture { isNameFieldFocused = false }
            
            VStack(spacing: 0) {
                // Progress dots
                progressDots
                    .padding(.top, 16)
                
                // Content
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    detailsPage.tag(1)
                    readyPage.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                // Navigation buttons
                navigationButtons
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
    }
    
    // MARK: - Progress Dots
    
    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index <= currentPage ? Color.tsSecondaryFallback : Color.secondary.opacity(0.2))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3), value: currentPage)
            }
        }
    }
    
    // MARK: - Page 1: Welcome
    
    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "waveform.and.mic")
                .font(.system(size: 72))
                .foregroundStyle(LinearGradient.tsPrimaryGradient)
                .padding(.bottom, 8)
            
            Text("Master Your\nR Sound")
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Text("A daily practice companion built for\npeople with rhotacism — difficulty\npronouncing the \"R\" sound.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            VStack(spacing: 10) {
                featureRow(icon: "mouth.fill", text: "Guided tongue & mouth exercises")
                featureRow(icon: "flame.fill", text: "Daily streak tracking")
                featureRow(icon: "trophy.fill", text: "Milestones & celebrations")
                featureRow(icon: "bell.badge.fill", text: "Practice reminders")
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.tsSecondaryFallback)
                .frame(width: 28)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Page 2: Name + Age
    
    private var detailsPage: some View {
        ScrollView {
            VStack(spacing: 28) {
                Spacer().frame(height: 20)
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.tsSecondaryFallback)
                
                Text("Tell us about yourself")
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
                
                // Name input
                VStack(alignment: .leading, spacing: 8) {
                    Text("YOUR NAME")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    TextField("Enter your name", text: $name)
                        .font(.title3)
                        .padding()
                        .focused($isNameFieldFocused)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.tsCardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .strokeBorder(
                                            isNameFieldFocused ? Color.tsSecondaryFallback : Color.secondary.opacity(0.15),
                                            lineWidth: isNameFieldFocused ? 2 : 1
                                        )
                                )
                        )
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, 8)
                
                // Age group selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("AGE GROUP")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    VStack(spacing: 10) {
                        ForEach(AgeGroup.allCases) { age in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedAge = age
                                }
                                isNameFieldFocused = false
                                HapticService.shared.selectionChanged()
                            } label: {
                                HStack(spacing: 14) {
                                    Text(age.emoji)
                                        .font(.title2)
                                    
                                    Text(age.displayName)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if selectedAge == age {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.tsSecondaryFallback)
                                            .font(.title3)
                                    }
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.tsCardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .strokeBorder(
                                                    selectedAge == age ? Color.tsSecondaryFallback : Color.secondary.opacity(0.15),
                                                    lineWidth: selectedAge == age ? 2 : 1
                                                )
                                        )
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Page 3: Ready
    
    private var readyPage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 72))
                .foregroundStyle(LinearGradient.celebrationGradient)
            
            Text("Let's go,\n\(name.trimmingCharacters(in: .whitespaces).isEmpty ? "friend" : name.trimmingCharacters(in: .whitespaces))!")
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                Text("Your R-Sound Practice Plan")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(spacing: 6) {
                    planRow(icon: "1.circle.fill", text: "Warm up your jaw & tongue")
                    planRow(icon: "2.circle.fill", text: "Practice R sound isolation")
                    planRow(icon: "3.circle.fill", text: "R in words & tongue twisters")
                    planRow(icon: "4.circle.fill", text: "R in full sentences")
                    planRow(icon: "5.circle.fill", text: "Fun challenges & cool down")
                }
                
                Text("~3 minutes per session • Daily practice")
                    .font(.caption)
                    .foregroundColor(.tsSecondaryFallback)
                    .padding(.top, 6)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.tsCardBackground)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
            )
            .padding(.horizontal, 8)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private func planRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.tsSecondaryFallback)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    // MARK: - Navigation Buttons
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            // Back button (hidden on first page)
            if currentPage > 0 {
                Button {
                    isNameFieldFocused = false
                    withAnimation { currentPage -= 1 }
                } label: {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.tsCardBackground)
                                .shadow(color: .black.opacity(0.04), radius: 6)
                        )
                }
            }
            
            // Next / Get Started button
            Button {
                isNameFieldFocused = false
                if currentPage == totalPages - 1 {
                    completeOnboarding()
                } else {
                    withAnimation { currentPage += 1 }
                }
                HapticService.shared.mediumImpact()
            } label: {
                Text(currentPage == totalPages - 1 ? "Start Practicing!" : "Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isNextEnabled ? LinearGradient.tsPrimaryGradient : LinearGradient(colors: [Color.gray], startPoint: .leading, endPoint: .trailing))
                    )
            }
            .disabled(!isNextEnabled)
        }
    }
    
    private var isNextEnabled: Bool {
        switch currentPage {
        case 1: return !name.trimmingCharacters(in: .whitespaces).isEmpty
        default: return true
        }
    }
    
    // MARK: - Complete Onboarding
    
    private func completeOnboarding() {
        let profile = UserProfile(
            name: name.trimmingCharacters(in: .whitespaces),
            ageGroup: selectedAge,
            selectedSounds: [.r],
            onboardingCompleted: true
        )
        viewModel.completeOnboarding(profile: profile)
    }
}
