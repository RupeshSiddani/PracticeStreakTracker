import SwiftUI

// MARK: - TopSpeech Health Brand Colors
extension Color {
    
    // Primary brand colors - deep teal/blue palette
    static let tsPrimary = Color("TSPrimary", bundle: nil)
    static let tsSecondary = Color("TSSecondary", bundle: nil)
    static let tsAccent = Color("TSAccent", bundle: nil)
    
    // Fallback programmatic colors matching TopSpeech Health branding
    static let tsPrimaryFallback = Color(red: 0.11, green: 0.28, blue: 0.45)    // Deep navy blue
    static let tsSecondaryFallback = Color(red: 0.16, green: 0.50, blue: 0.55)  // Teal
    static let tsAccentFallback = Color(red: 0.35, green: 0.78, blue: 0.65)     // Mint green
    
    // Semantic colors
    static let tsBackground = Color(UIColor.systemBackground)
    static let tsSecondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tsGroupedBackground = Color(UIColor.systemGroupedBackground)
    
    // Streak-specific colors
    static let streakFire = Color(red: 1.0, green: 0.55, blue: 0.0)             // Warm orange
    static let streakGold = Color(red: 1.0, green: 0.78, blue: 0.0)             // Gold
    static let streakFreeze = Color(red: 0.40, green: 0.73, blue: 0.95)         // Ice blue
    
    // Heatmap gradient colors
    static let heatmapNone = Color(UIColor.tertiarySystemFill)
    static let heatmapLight = Color(red: 0.60, green: 0.85, blue: 0.75)
    static let heatmapMedium = Color(red: 0.30, green: 0.70, blue: 0.60)
    static let heatmapDark = Color(red: 0.16, green: 0.50, blue: 0.55)
    
    // Celebration colors
    static let celebrationPurple = Color(red: 0.58, green: 0.34, blue: 0.92)
    static let celebrationPink = Color(red: 0.95, green: 0.40, blue: 0.53)
    static let celebrationYellow = Color(red: 1.0, green: 0.84, blue: 0.0)
}

// MARK: - Gradient Definitions
extension LinearGradient {
    
    static let tsPrimaryGradient = LinearGradient(
        colors: [Color.tsPrimaryFallback, Color.tsSecondaryFallback],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let streakGradient = LinearGradient(
        colors: [Color.streakFire, Color.streakGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let freezeGradient = LinearGradient(
        colors: [Color.streakFreeze, Color.streakFreeze.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let celebrationGradient = LinearGradient(
        colors: [Color.celebrationPurple, Color.celebrationPink, Color.celebrationYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
