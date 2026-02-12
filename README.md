# Practice Streak Tracker

A standalone iOS demo app showcasing a **Practice Streak Tracker** feature for [TopSpeech Health](https://topspeech.health) — an AI-powered speech therapy platform helping adults overcome rhotacism.

## Features

### Core Requirements
- **Streak Dashboard** — Current streak, longest streak, and visual calendar heatmap showing practice history
- **Daily Practice Simulation** — Mock exercise flow simulating speech therapy exercises (warm-up → R sound → words → sentences → cool down)
- **Streak Protection (Freeze)** — Freeze mechanism to protect streaks for 1-2 days; earned through consistent practice (1 freeze per 7 days, max 5)
- **Milestone Celebrations** — Confetti animations and full-screen overlays for streak milestones (3, 7, 14, 21, 30, 60, 90, 100, 180, 365 days)
- **Local Persistence** — All data persisted via UserDefaults with JSON encoding; survives app launches
- **Push Notification Reminders** — Configurable daily practice reminders with encouraging messages

### Bonus Features
- **Haptic Feedback** — Tactile feedback for practice completion, milestones, and UI interactions
- **Dark Mode** — Full dark mode support using semantic and system colors
- **Accessibility** — VoiceOver labels/hints on all interactive elements, Dynamic Type support
- **Statistics & Insights** — Total practice days, average streak, best practice weekday, milestone progress

## Architecture

```
MVVM (Model-View-ViewModel)
├── Models/          — Data structures (PracticeRecord, Milestone, UserData)
├── ViewModels/      — Business logic (StreakViewModel)
├── Views/           — SwiftUI views organized by feature
│   ├── Dashboard/   — Streak dashboard + calendar heatmap
│   ├── Practice/    — Mock exercise session flow
│   ├── Freeze/      — Streak freeze management
│   ├── Celebrations/— Milestone celebration + confetti
│   ├── Statistics/  — Practice stats and insights
│   └── Settings/    — Notifications, about, data reset
├── Services/        — Persistence, Notifications, Haptics
└── Extensions/      — Color theme, Date helpers
```

## Technical Details

| Requirement | Implementation |
|------------|----------------|
| Language | Swift 5.5+ |
| UI Framework | SwiftUI |
| Deployment Target | iOS 15.0+ |
| Architecture | MVVM |
| Persistence | UserDefaults (JSON-encoded Codable models) |
| Notifications | UNUserNotificationCenter (local notifications) |
| Third-party dependencies | **None** |

## Building the Project

### Option A: Using XcodeGen (Recommended)
1. Install XcodeGen: `brew install xcodegen`
2. Navigate to the project root: `cd PracticeStreakTracker`
3. Generate the Xcode project: `xcodegen generate`
4. Open `PracticeStreakTracker.xcodeproj` in Xcode
5. Select a simulator or device and run

### Option B: Manual Xcode Setup
1. Open Xcode → File → New → Project → iOS App
2. Set Product Name to `PracticeStreakTracker`, Interface: SwiftUI, Language: Swift
3. Delete the default `ContentView.swift`
4. Drag all files from the `PracticeStreakTracker/` source folder into the Xcode project
5. Set deployment target to iOS 15.0
6. Build and run

## Design Decisions

- **Color Palette**: Deep navy/teal primary colors inspired by TopSpeech Health's medical/professional branding. Warm orange/gold for streak-related elements. Ice blue for freeze features.
- **No Third-Party Dependencies**: Fully built with native Apple frameworks to minimize complexity and maximize compatibility.
- **UserDefaults over CoreData**: Chose simpler persistence since the data model is flat and lightweight. JSON encoding provides type safety via Codable.
- **Mock Exercise Flow**: Simulates a 5-step practice session with progress animations. In production, this would integrate with actual speech therapy exercises.
- **Empathetic Design**: Encouraging language throughout (no shaming for missed days), celebration of progress, and privacy-first approach (all data is local).

## Author

Built by **Rupesh Siddani** as part of the TopSpeech Health Engineering Internship Assessment.
