# Practice Streak Tracker

A standalone iOS app built for **[TopSpeech Health](https://topspeech.health)** — an AI-powered speech therapy platform. This app implements a **Practice Streak Tracker** designed primarily to help users with **rhotacism** (difficulty pronouncing the R sound) build consistent daily practice habits through guided exercises, streak tracking, and motivational milestones.

---

## Table of Contents

- [Overview](#overview)
- [Screenshots Flow](#screenshots-flow)
- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Technical Details](#technical-details)
- [Building & Running](#building--running)
- [Design Decisions](#design-decisions)
- [Key Implementation Details](#key-implementation-details)

---

## Overview

Rhotacism is one of the most common speech sound disorders, where individuals struggle to pronounce the "R" sound correctly. Consistent daily practice is crucial for improvement, but maintaining motivation over weeks and months is challenging.

**Practice Streak Tracker** solves this by:
- Providing **personalized, therapy-based exercises** tailored to the user's specific speech difficulties
- Tracking **daily practice streaks** to build habit consistency
- Offering **streak freezes** to protect progress during off days
- Celebrating **milestones** with animations to keep users motivated
- Sending **daily reminders** to maintain the practice habit

The app collects the user's information during onboarding (name, age group, and problem sounds) and generates a personalized exercise program. While R-sound exercises are the primary focus, the app also supports S, L, TH, SH/CH, and K/G sounds.

---

## Screenshots Flow

| Onboarding | Sound Selection | Dashboard | Practice Session |
|:---:|:---:|:---:|:---:|
| Welcome → Name → Age → Sounds → Ready | Pick R (default) + additional sounds | Streak count, calendar, milestones | 7-step guided therapy exercises |

| Streak Freeze | Statistics | Settings | Dark Mode |
|:---:|:---:|:---:|:---:|
| Protect your streak | Detailed practice analytics | Reminders & preferences | Full dark mode support |

---

## Features

### Core Features

#### 1. Personalized Onboarding
- **5-step welcome flow** that collects the user's name, age group, and problem speech sounds
- R sound is **pre-selected** as the primary focus (rhotacism)
- Users can optionally add other sounds (S, L, TH, SH/CH, K/G)
- Profile data is persisted locally and used to personalize the entire experience

#### 2. Streak Dashboard
- **Current streak** displayed prominently with a fire icon and animated counter
- **Longest streak** record tracked separately
- **Visual calendar heatmap** showing practice history (green = practiced, blue = freeze used, gray = missed)
- **Next milestone progress** bar showing distance to the next achievement
- **Personalized greeting** — dashboard greets the user by name (e.g., "Hi, Alex!")
- **Today's focus** — shows which sound the current session will target

#### 3. Guided Practice Sessions
Each practice session is a **7-step, therapy-based exercise flow** that follows real speech pathology methodology:

**R Sound (Rhotacism) — Primary Focus:**

| Step | Exercise | Duration | Purpose |
|------|----------|----------|---------|
| 1 | Jaw Relaxation | 15s | Loosen jaw muscles with open/close exercises |
| 2 | Tongue Curl | 20s | Practice the R-tongue position without speaking |
| 3 | Growl Like a Tiger | 25s | "Grrr" sound to feel tongue vibration |
| 4 | R Words — Beginning | 25s | Red, Rain, Run, Road, Rock |
| 5 | R Words — Middle | 25s | Carrot, Mirror, Forest, Parent, Orange |
| 6 | R Sentences | 30s | Full sentence practice with R-heavy text |
| 7 | Cool Down | 12s | Deep breathing and relaxation |

**Total session time: ~2.5 minutes** — intentionally paced for users who need time to position their tongue, attempt the sound, and retry.

**Additional Sound Exercises (if selected):**

| Sound | Condition | Key Technique |
|-------|-----------|---------------|
| **S** | Sigmatism / Lisping | Tongue tip behind top teeth, snake hiss drill |
| **L** | Lambdacism | Tongue-to-alveolar-ridge, "la la la" tapping |
| **TH** | TH Fronting | Tongue between teeth, voiceless vs voiced |
| **SH/CH** | Palatalization | Lip rounding, "library shh", CH pop |
| **K/G** | Backing | Back-of-tongue lift, gargle warm-up, cough drill |

When multiple sounds are selected, sessions **rotate through sounds** across days — e.g., Day 1 = R, Day 2 = S, Day 3 = R, etc.

#### 4. Streak Protection (Freeze System)
- Users start with **2 streak freezes**
- Freezes protect the streak for days when practice is missed
- **Earn additional freezes** through consistency: 1 freeze per 7 practice days
- Maximum of **5 freezes** can be held at once
- Freeze usage is displayed on the calendar heatmap in blue

#### 5. Milestone Celebrations
Animated full-screen celebrations with confetti when users hit streak milestones:

| Days | Milestone | Icon |
|------|-----------|------|
| 3 | Getting Started | 🔥 |
| 7 | One Week Strong | ⭐ |
| 14 | Two Week Warrior | 🛡️ |
| 21 | Habit Formed | 🧠 |
| 30 | Monthly Master | 👑 |
| 60 | Two Month Champion | 🏆 |
| 90 | Quarter Year Hero | 🏅 |
| 100 | Century Club | ✅ |
| 180 | Half Year Legend | ✨ |
| 365 | One Year Milestone | 🌟 |

#### 6. Push Notifications
- Daily practice reminders at a user-configurable time
- Encouraging, varied reminder messages
- Uses `UNUserNotificationCenter` for local notifications
- Permission requested through the Settings tab

### Bonus Features

- **Haptic Feedback** — Tactile responses for practice completion (success), milestone celebrations (heavy impact), freeze usage (medium impact), and general UI interactions (selection changed)
- **Dark Mode** — All colors adapt dynamically between light and dark mode using `UIColor` dynamic providers. Brand colors get brighter in dark mode for better visibility.
- **Accessibility** — Full VoiceOver support with descriptive labels and hints on all interactive elements. Dynamic Type support for text scaling.
- **Statistics & Insights** — Total practice days, average streak length, best practice weekday, freezes used/available, milestone progress tracking
- **Empathetic Design** — Encouraging language throughout (no shaming for missed days), celebration of every achievement, privacy-first (all data stays on-device)

---

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern with a clear separation of concerns:

```
┌─────────────────────────────────────────────────────┐
│                      Views                          │
│  (SwiftUI — declarative UI, no business logic)      │
│  Observes ViewModel via @EnvironmentObject          │
└──────────────────────┬──────────────────────────────┘
                       │ @Published properties
┌──────────────────────┴──────────────────────────────┐
│                   ViewModel                         │
│  (StreakViewModel — all business logic)              │
│  @MainActor, ObservableObject                       │
│  Streak calculation, milestone detection,           │
│  freeze management, exercise rotation               │
└──────────────────────┬──────────────────────────────┘
                       │ Codable models
┌──────────────────────┴──────────────────────────────┐
│              Models + Services                      │
│  Models: PracticeRecord, Milestone, UserProfile     │
│  Services: PersistenceService, NotificationService, │
│            HapticService                            │
│  Persistence: UserDefaults with JSON encoding       │
└─────────────────────────────────────────────────────┘
```

### Why MVVM?

- **Testability** — Business logic in StreakViewModel is decoupled from SwiftUI views
- **Single source of truth** — One ViewModel shared across all tabs via `@EnvironmentObject`
- **Reactive UI** — `@Published` properties automatically update all observing views
- **Clean separation** — Views only handle layout/display; all calculations live in the ViewModel

---

## Project Structure

```
PracticeStreakTracker/
├── App/
│   └── PracticeStreakTrackerApp.swift       # App entry point, onboarding vs main flow
│
├── Models/
│   ├── PracticeRecord.swift                # PracticeRecord, StreakStatistics, UserData
│   ├── Milestone.swift                     # Milestone definitions (3 to 365 days)
│   └── UserProfile.swift                   # UserProfile, SpeechSound enum, AgeGroup
│                                           # Contains all 6 sound exercise sets
│
├── ViewModels/
│   └── StreakViewModel.swift               # Central business logic — 400+ lines
│                                           # Streak calc, freezes, milestones,
│                                           # exercise rotation, profile management
│
├── Views/
│   ├── MainTabView.swift                   # Tab bar: Dashboard, Statistics, Settings
│   ├── Onboarding/
│   │   └── OnboardingView.swift            # 5-page onboarding flow
│   ├── Dashboard/
│   │   ├── DashboardView.swift             # Main streak dashboard
│   │   └── CalendarHeatmapView.swift       # 6-week practice history grid
│   ├── Practice/
│   │   └── PracticeSessionView.swift       # Guided exercise session with timer
│   ├── Freeze/
│   │   └── StreakFreezeSheet.swift          # Freeze management bottom sheet
│   ├── Celebrations/
│   │   └── MilestoneCelebrationView.swift  # Full-screen confetti celebration
│   ├── Statistics/
│   │   └── StatisticsView.swift            # Practice analytics and insights
│   └── Settings/
│       └── SettingsView.swift              # Notifications, time picker, reset data
│
├── Services/
│   ├── PersistenceService.swift            # UserDefaults JSON save/load
│   ├── NotificationService.swift           # UNUserNotificationCenter wrapper
│   └── HapticService.swift                 # UIImpactFeedbackGenerator wrapper
│
├── Extensions/
│   ├── Color+Theme.swift                   # Adaptive brand colors + gradients
│   └── Date+Extensions.swift               # Date formatting helpers
│
└── Assets.xcassets/                        # App icon, accent color
```

**Total: ~3,500 lines of Swift across 17 source files**

---

## Technical Details

| Specification | Details |
|--------------|---------|
| **Language** | Swift (Swift 6 concurrency compatible) |
| **UI Framework** | SwiftUI (declarative, reactive) |
| **Minimum Deployment Target** | iOS 17.0 |
| **Architecture Pattern** | MVVM (Model-View-ViewModel) |
| **Persistence** | UserDefaults with JSON encoding via `Codable` |
| **Notifications** | `UNUserNotificationCenter` (local push notifications) |
| **Haptics** | `UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator` |
| **Timer** | Combine `Timer.publish` for Swift 6 concurrency safety |
| **Concurrency** | `@MainActor`, `async/await`, `Task` |
| **Dark Mode** | `UIColor` dynamic trait-based providers |
| **Accessibility** | VoiceOver labels/hints, Dynamic Type |
| **Third-Party Dependencies** | **None** — 100% native Apple frameworks |

---

## Building & Running

### Prerequisites
- **macOS** with Xcode 15+ installed
- iOS Simulator or physical device running iOS 17.0+

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/PracticeStreakTracker.git
   ```
2. Open the Xcode project:
   ```bash
   open PracticeStreakTracker.xcodeproj
   ```
3. Select a simulator (e.g., iPhone 15 Pro) from the device dropdown
4. Press **⌘R** to build and run
5. The onboarding flow will appear on first launch

### Testing Dark Mode
In the Simulator: **Features → Toggle Appearance**

### Reset Data
Go to **Settings tab → Reset All Data** to clear all progress and return to onboarding

---

## Design Decisions

### Rhotacism-First Approach
The app is purpose-built for R-sound therapy. The R sound is pre-selected during onboarding, exercises follow real speech pathology progression (isolation → syllables → words → sentences), and durations are intentionally long (15–30 seconds per step) to give users time to position their tongue, attempt the sound, and retry.

### No Third-Party Dependencies
Built entirely with native Apple frameworks (SwiftUI, Combine, UserNotifications, UIKit for haptics). This eliminates dependency management complexity, ensures maximum compatibility, and keeps the binary size minimal.

### UserDefaults over CoreData
The data model is flat and lightweight (practice records + user profile). JSON encoding via `Codable` provides full type safety without the overhead of CoreData's managed object context, migration system, and threading model.

### Combine Timer over Foundation Timer
`Timer.publish(every:on:in:)` with `.onReceive()` runs on the main thread within SwiftUI's view lifecycle, making it fully compatible with Swift 6 strict concurrency checking — unlike `Timer.scheduledTimer` which creates `@Sendable` closure issues.

### Adaptive Color System
Instead of using Xcode asset catalog colors, all theme colors are defined programmatically using `UIColor { traitCollection in }` dynamic providers. This ensures every color automatically adapts between light and dark mode without manual asset management.

### Exercise Rotation System
When users select multiple speech sounds, sessions rotate through them based on total practice count (`dayIndex % sounds.count`). This ensures balanced practice across all selected sounds without requiring the user to manually choose each day.

### Empathetic, Privacy-First Design
- No shaming language for missed days — only encouragement
- All data stays on-device (no server, no analytics, no tracking)
- Streak freezes provide forgiveness without penalty
- Milestone celebrations reward every achievement, no matter how small

---

## Author

Built as part of the **TopSpeech Health Engineering Internship Assessment**.
