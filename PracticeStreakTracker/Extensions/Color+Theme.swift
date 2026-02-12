import SwiftUI

// MARK: - Adaptive Color Helper
/// Creates a Color that automatically adapts between light and dark mode
private func adaptiveColor(light: UIColor, dark: UIColor) -> Color {
    Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark ? dark : light
    })
}

// MARK: - TopSpeech Health Brand Colors
extension Color {
    
    // Primary brand colors — adaptive for light/dark
    static let tsPrimaryFallback = adaptiveColor(
        light: UIColor(red: 0.11, green: 0.28, blue: 0.45, alpha: 1),
        dark: UIColor(red: 0.35, green: 0.60, blue: 0.82, alpha: 1)
    )
    static let tsSecondaryFallback = adaptiveColor(
        light: UIColor(red: 0.16, green: 0.50, blue: 0.55, alpha: 1),
        dark: UIColor(red: 0.30, green: 0.72, blue: 0.78, alpha: 1)
    )
    static let tsAccentFallback = adaptiveColor(
        light: UIColor(red: 0.35, green: 0.78, blue: 0.65, alpha: 1),
        dark: UIColor(red: 0.45, green: 0.88, blue: 0.75, alpha: 1)
    )
    
    // Semantic colors — automatically adapt
    static let tsBackground = Color(UIColor.systemBackground)
    static let tsSecondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tsGroupedBackground = Color(UIColor.systemGroupedBackground)
    
    // Card background — slightly elevated in dark mode
    static let tsCardBackground = adaptiveColor(
        light: UIColor.systemBackground,
        dark: UIColor.secondarySystemBackground
    )
    
    // Streak-specific colors — brighter in dark mode
    static let streakFire = adaptiveColor(
        light: UIColor(red: 1.0, green: 0.55, blue: 0.0, alpha: 1),
        dark: UIColor(red: 1.0, green: 0.65, blue: 0.2, alpha: 1)
    )
    static let streakGold = adaptiveColor(
        light: UIColor(red: 1.0, green: 0.78, blue: 0.0, alpha: 1),
        dark: UIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1)
    )
    static let streakFreeze = adaptiveColor(
        light: UIColor(red: 0.40, green: 0.73, blue: 0.95, alpha: 1),
        dark: UIColor(red: 0.50, green: 0.80, blue: 1.0, alpha: 1)
    )
    
    // Heatmap gradient colors
    static let heatmapNone = Color(UIColor.tertiarySystemFill)
    static let heatmapLight = adaptiveColor(
        light: UIColor(red: 0.60, green: 0.85, blue: 0.75, alpha: 1),
        dark: UIColor(red: 0.30, green: 0.55, blue: 0.45, alpha: 1)
    )
    static let heatmapMedium = adaptiveColor(
        light: UIColor(red: 0.30, green: 0.70, blue: 0.60, alpha: 1),
        dark: UIColor(red: 0.25, green: 0.60, blue: 0.50, alpha: 1)
    )
    static let heatmapDark = adaptiveColor(
        light: UIColor(red: 0.16, green: 0.50, blue: 0.55, alpha: 1),
        dark: UIColor(red: 0.30, green: 0.72, blue: 0.78, alpha: 1)
    )
    
    // Celebration colors — vibrant in both modes
    static let celebrationPurple = adaptiveColor(
        light: UIColor(red: 0.58, green: 0.34, blue: 0.92, alpha: 1),
        dark: UIColor(red: 0.68, green: 0.48, blue: 1.0, alpha: 1)
    )
    static let celebrationPink = adaptiveColor(
        light: UIColor(red: 0.95, green: 0.40, blue: 0.53, alpha: 1),
        dark: UIColor(red: 1.0, green: 0.50, blue: 0.60, alpha: 1)
    )
    static let celebrationYellow = adaptiveColor(
        light: UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1),
        dark: UIColor(red: 1.0, green: 0.90, blue: 0.3, alpha: 1)
    )
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
