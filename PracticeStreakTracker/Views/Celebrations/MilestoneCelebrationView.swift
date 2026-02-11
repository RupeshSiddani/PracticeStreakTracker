import SwiftUI

// MARK: - Milestone Celebration View
/// Full-screen overlay shown when the user reaches a streak milestone.
/// Features confetti animation, milestone info, and a dismiss button.
struct MilestoneCelebrationView: View {
    
    let milestone: Milestone
    let onDismiss: () -> Void
    
    @State private var showContent = false
    @State private var confettiPieces: [ConfettiPiece] = []
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            // Confetti layer
            ForEach(confettiPieces) { piece in
                ConfettiParticle(piece: piece)
            }
            
            // Content card
            VStack(spacing: 20) {
                Spacer()
                
                // Milestone icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.celebrationYellow.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                    
                    Image(systemName: milestone.symbolName)
                        .font(.system(size: 64))
                        .foregroundStyle(LinearGradient.celebrationGradient)
                        .scaleEffect(showContent ? 1.0 : 0.3)
                        .opacity(showContent ? 1.0 : 0.0)
                }
                
                // Milestone days
                Text("\(milestone.days) Days!")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .opacity(showContent ? 1.0 : 0.0)
                
                // Title
                Text(milestone.title)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.celebrationYellow)
                    .opacity(showContent ? 1.0 : 0.0)
                
                // Description
                Text(milestone.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(showContent ? 1.0 : 0.0)
                
                Spacer()
                
                // Dismiss button
                Button {
                    onDismiss()
                } label: {
                    Text("Keep Going!")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient.celebrationGradient)
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .opacity(showContent ? 1.0 : 0.0)
            }
        }
        .onAppear {
            generateConfetti()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showContent = true
            }
        }
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Milestone achieved: \(milestone.title). \(milestone.description)")
    }
    
    /// Creates random confetti pieces for the celebration
    private func generateConfetti() {
        let colors: [Color] = [
            .celebrationPurple, .celebrationPink, .celebrationYellow,
            .streakFire, .streakGold, .tsAccentFallback, .streakFreeze
        ]
        confettiPieces = (0..<40).map { _ in
            ConfettiPiece(
                color: colors.randomElement() ?? .celebrationYellow,
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                delay: Double.random(in: 0...1.0),
                size: CGFloat.random(in: 6...14),
                rotation: Double.random(in: 0...360)
            )
        }
    }
}

// MARK: - Confetti Piece Model
struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let x: CGFloat
    let delay: Double
    let size: CGFloat
    let rotation: Double
}

// MARK: - Confetti Particle View
/// A single animated confetti particle that falls from the top of the screen.
struct ConfettiParticle: View {
    let piece: ConfettiPiece
    
    @State private var yOffset: CGFloat = -50
    @State private var opacity: Double = 1.0
    @State private var currentRotation: Double = 0
    @State private var xWobble: CGFloat = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(piece.color)
            .frame(width: piece.size, height: piece.size * 1.4)
            .rotationEffect(.degrees(currentRotation))
            .offset(x: piece.x + xWobble, y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeIn(duration: Double.random(in: 2.5...4.0))
                    .delay(piece.delay)
                ) {
                    yOffset = UIScreen.main.bounds.height + 50
                    opacity = 0.0
                }
                withAnimation(
                    .linear(duration: 3.0)
                    .delay(piece.delay)
                    .repeatForever(autoreverses: false)
                ) {
                    currentRotation = piece.rotation + 360
                }
                withAnimation(
                    .easeInOut(duration: 0.8)
                    .delay(piece.delay)
                    .repeatForever(autoreverses: true)
                ) {
                    xWobble = CGFloat.random(in: -30...30)
                }
            }
    }
}
