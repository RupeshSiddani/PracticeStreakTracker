import SwiftUI

// MARK: - Onboarding View
/// Multi-step onboarding flow that collects user's name, age group,
/// and which speech sounds they struggle with to personalize exercises.
struct OnboardingView: View {
    
    @EnvironmentObject var viewModel: StreakViewModel
    @State private var currentPage = 0
    @State private var name = ""
    @State private var selectedAge: AgeGroup = .adult
    @State private var selectedSounds: Set<SpeechSound> = [.r]
    @State private var animateContent = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.tsPrimaryFallback.opacity(0.08), Color.tsSecondaryFallback.opacity(0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress dots
                progressDots
                    .padding(.top, 16)
                
                // Content
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    namePage.tag(1)
                    agePage.tag(2)
                    soundsPage.tag(3)
                    readyPage.tag(4)
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
            ForEach(0..<5) { index in
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
            
            Text("Welcome to\nPractice Streak Tracker")
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Text("Your R-sound speech therapy companion.\nDesigned to help you master the R sound\nthrough daily guided practice.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Page 2: Name
    
    private var namePage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.tsSecondaryFallback)
            
            Text("What's your name?")
                .font(.title.weight(.bold))
                .foregroundColor(.primary)
            
            Text("We'll use this to personalize your experience.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            TextField("Enter your name", text: $name)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.tsCardBackground)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                )
                .padding(.horizontal, 40)
                .autocorrectionDisabled()
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Page 3: Age Group
    
    private var agePage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "calendar.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.tsAccentFallback)
            
            Text("What's your age group?")
                .font(.title.weight(.bold))
                .foregroundColor(.primary)
            
            Text("This helps us adjust the difficulty\nand language of exercises.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                ForEach(AgeGroup.allCases) { age in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedAge = age
                        }
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
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.tsCardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .strokeBorder(
                                            selectedAge == age ? Color.tsSecondaryFallback : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Page 4: Sound Selection
    
    private var soundsPage: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "mouth.fill")
                .font(.system(size: 56))
                .foregroundColor(.celebrationPurple)
            
            Text("Which sounds are\ndifficult for you?")
                .font(.title.weight(.bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("R is pre-selected as your primary focus.\nSelect any additional sounds you'd like to practice.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(SpeechSound.allCases) { sound in
                    soundCard(sound)
                }
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private func soundCard(_ sound: SpeechSound) -> some View {
        let isSelected = selectedSounds.contains(sound)
        
        return Button {
            withAnimation(.spring(response: 0.3)) {
                if isSelected {
                    selectedSounds.remove(sound)
                } else {
                    selectedSounds.insert(sound)
                }
            }
            HapticService.shared.selectionChanged()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: sound.icon)
                    .font(.title)
                    .foregroundColor(isSelected ? .white : .tsSecondaryFallback)
                
                Text(sound.displayName)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(sound == .r ? "Rhotacism" : sound == .s ? "Lisping" : sound == .l ? "Lambdacism" : sound == .th ? "TH fronting" : sound == .sh ? "Palatalization" : "Backing")
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.tsSecondaryFallback : Color.tsCardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(isSelected ? Color.clear : Color.secondary.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Page 5: Ready
    
    private var readyPage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 72))
                .foregroundStyle(LinearGradient.celebrationGradient)
            
            Text("You're all set,\n\(name.isEmpty ? "friend" : name)!")
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                Text("Here's your plan:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if selectedSounds.isEmpty {
                    Text("General speech practice exercises")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Custom exercises for: \(selectedSounds.map { $0.displayName }.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Text("Daily practice • Streak tracking • Milestones")
                    .font(.caption)
                    .foregroundColor(.tsSecondaryFallback)
                    .padding(.top, 4)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Navigation Buttons
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            // Back button (hidden on first page)
            if currentPage > 0 {
                Button {
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
                if currentPage == 4 {
                    completeOnboarding()
                } else {
                    withAnimation { currentPage += 1 }
                }
                HapticService.shared.mediumImpact()
            } label: {
                Text(currentPage == 4 ? "Get Started!" : "Continue")
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
        case 3: return !selectedSounds.isEmpty
        default: return true
        }
    }
    
    // MARK: - Complete Onboarding
    
    private func completeOnboarding() {
        let profile = UserProfile(
            name: name.trimmingCharacters(in: .whitespaces),
            ageGroup: selectedAge,
            selectedSounds: Array(selectedSounds),
            onboardingCompleted: true
        )
        viewModel.completeOnboarding(profile: profile)
    }
}
