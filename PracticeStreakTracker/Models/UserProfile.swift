import Foundation

// MARK: - Speech Sound Difficulty
/// Represents specific speech sounds that a user may struggle with.
/// Each case contains tailored exercise content for that sound.
enum SpeechSound: String, Codable, CaseIterable, Identifiable {
    case r = "R"          // Primary focus — Rhotacism
    case s = "S"
    case l = "L"
    case th = "TH"
    case sh = "SH/CH"
    case k = "K/G"
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
    
    var description: String {
        switch self {
        case .r: return "Difficulty with R sounds (e.g., \"wabbit\" instead of \"rabbit\")"
        case .s: return "Lisping or unclear S sounds (e.g., \"thun\" instead of \"sun\")"
        case .l: return "Difficulty with L sounds (e.g., \"wion\" instead of \"lion\")"
        case .th: return "Trouble with TH sounds (e.g., \"fink\" instead of \"think\")"
        case .sh: return "Difficulty with SH or CH sounds (e.g., \"sip\" instead of \"ship\")"
        case .k: return "Trouble with K or G sounds (e.g., \"tat\" instead of \"cat\")"
        }
    }
    
    var icon: String {
        switch self {
        case .r: return "r.circle.fill"
        case .s: return "s.circle.fill"
        case .l: return "l.circle.fill"
        case .th: return "t.circle.fill"
        case .sh: return "s.circle.fill"
        case .k: return "k.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .r: return "streakFire"
        case .s: return "tsSecondaryFallback"
        case .l: return "tsAccentFallback"
        case .th: return "celebrationPurple"
        case .sh: return "celebrationPink"
        case .k: return "streakGold"
        }
    }
    
    // MARK: - Personalized Exercises
    
    var exercises: [ExerciseStep] {
        switch self {
        case .r:
            return [
                ExerciseStep(title: "Jaw Relaxation", instruction: "Open your mouth wide, then slowly close it.\nRepeat 5 times. Feel your jaw muscles loosen.", icon: "face.smiling", durationSeconds: 15),
                ExerciseStep(title: "Tongue Curl", instruction: "Curl the tip of your tongue slightly back without touching the roof of your mouth.\nHold for 5 seconds, relax, repeat 3 times.", icon: "mouth.fill", durationSeconds: 20),
                ExerciseStep(title: "Growl Like a Tiger", instruction: "Make a low \"grrr\" sound like a tiger.\nFeel the vibration in your tongue.\nHold each growl for 3 seconds, repeat 5 times.", icon: "waveform", durationSeconds: 25),
                ExerciseStep(title: "R Words — Beginning", instruction: "Say each word slowly, focusing on the R:\n🔴 Red… Rain… Run… Road… Rock\nPause between each. Repeat the list.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "R Words — Middle", instruction: "Now R in the middle of words:\n🟠 Carrot… Mirror… Forest… Parent… Orange\nTake your time with each one.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "R Sentences", instruction: "Read slowly and clearly:\n\"The red rabbit ran rapidly around the rocky road.\"\nRepeat 3 times. It's okay to go slow!", icon: "quote.bubble.fill", durationSeconds: 30),
                ExerciseStep(title: "Cool Down", instruction: "Amazing work! 🎉\nTake 3 deep breaths.\nYour tongue muscles are getting stronger every session.", icon: "sparkles", durationSeconds: 12)
            ]
        case .s:
            return [
                ExerciseStep(title: "Breathing Focus", instruction: "Breathe in slowly through your nose.\nBreathe out through a tiny gap in your teeth.\nFeel the air flow. Repeat 5 times.", icon: "wind", durationSeconds: 15),
                ExerciseStep(title: "Tongue Position", instruction: "Place the tip of your tongue just behind your top front teeth (not touching).\nKeep your teeth close together.\nThis is your S position.", icon: "mouth.fill", durationSeconds: 18),
                ExerciseStep(title: "Snake Hiss", instruction: "Make a long \"sssss\" sound like a snake 🐍\nKeep the airflow steady and smooth.\nHold for 5 seconds, repeat 5 times.", icon: "waveform", durationSeconds: 25),
                ExerciseStep(title: "S Words — Beginning", instruction: "Say each word clearly:\n☀️ Sun… Soap… Six… Sand… Star\nFeel the air pass over your tongue tip.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "S Words — Ending", instruction: "Now S at the end:\n🌟 Bus… Glass… House… Dress… Peace\nHold the final S sound a little longer.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "S Sentences", instruction: "Read slowly:\n\"Six silly snakes slid silently across the sandy shore.\"\nRepeat 3 times.", icon: "quote.bubble.fill", durationSeconds: 30),
                ExerciseStep(title: "Cool Down", instruction: "Great session! 🎉\nRelax your jaw and take 3 deep breaths.\nYour S sound is improving!", icon: "sparkles", durationSeconds: 12)
            ]
        case .l:
            return [
                ExerciseStep(title: "Tongue Stretch", instruction: "Stick your tongue out as far as you can.\nHold for 3 seconds, pull back. Repeat 5 times.\nThis warms up your tongue muscles.", icon: "face.smiling", durationSeconds: 15),
                ExerciseStep(title: "Tongue to Ridge", instruction: "Press the tip of your tongue firmly to the bumpy ridge behind your top front teeth.\nHold for 5 seconds, release. Repeat 4 times.", icon: "mouth.fill", durationSeconds: 20),
                ExerciseStep(title: "La La La", instruction: "Say \"la la la la la\" slowly.\nFeel your tongue tap the ridge each time.\nGradually speed up, then slow down again.", icon: "waveform", durationSeconds: 22),
                ExerciseStep(title: "L Words — Beginning", instruction: "Say each word clearly:\n🦁 Lion… Lake… Leaf… Light… Lemon\nMake sure your tongue touches the ridge.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "L Words — Ending", instruction: "Now L at the end:\n⭐ Ball… Bell… Cool… Full… Smile\nHold the L sound at the end.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "L Sentences", instruction: "Read slowly:\n\"Lucy the lion loved lovely lemonade by the lake.\"\nRepeat 3 times.", icon: "quote.bubble.fill", durationSeconds: 30),
                ExerciseStep(title: "Cool Down", instruction: "Well done! 🎉\nLet your tongue rest. Take 3 deep breaths.\nYour L sound is getting clearer!", icon: "sparkles", durationSeconds: 12)
            ]
        case .th:
            return [
                ExerciseStep(title: "Lip & Tongue Warm Up", instruction: "Gently bite your lower lip, release.\nStick your tongue out slightly between your teeth.\nRepeat both 5 times.", icon: "face.smiling", durationSeconds: 15),
                ExerciseStep(title: "Tongue Between Teeth", instruction: "Place the tip of your tongue lightly between your top and bottom teeth.\nBlow air gently over your tongue.\nThis is the TH position.", icon: "mouth.fill", durationSeconds: 18),
                ExerciseStep(title: "TH Sound Hold", instruction: "Make a long \"thhhh\" sound.\nFeel the air flow over your tongue tip.\nHold for 5 seconds, repeat 5 times.", icon: "waveform", durationSeconds: 25),
                ExerciseStep(title: "TH Words — Voiceless", instruction: "Say each word clearly:\n🤔 Think… Three… Thumb… Thick… Thank\nTongue between teeth!", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "TH Words — Voiced", instruction: "Now the buzzy TH:\n👆 This… That… The… They… There\nFeel the vibration in your tongue.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "TH Sentences", instruction: "Read slowly:\n\"The three thankful brothers thought about things together.\"\nRepeat 3 times.", icon: "quote.bubble.fill", durationSeconds: 30),
                ExerciseStep(title: "Cool Down", instruction: "Fantastic work! 🎉\nRelax and breathe deeply 3 times.\nYour TH is getting stronger!", icon: "sparkles", durationSeconds: 12)
            ]
        case .sh:
            return [
                ExerciseStep(title: "Lip Warm Up", instruction: "Round your lips into a small \"O\" shape.\nHold for 3 seconds, relax. Repeat 5 times.\nThen smile wide and round again.", icon: "face.smiling", durationSeconds: 15),
                ExerciseStep(title: "Lip Position", instruction: "Push your lips forward slightly, like blowing a gentle kiss.\nYour tongue should be wide and flat behind your teeth.\nThis is your SH position.", icon: "mouth.fill", durationSeconds: 18),
                ExerciseStep(title: "Quiet Library", instruction: "Make a long \"shhhh\" sound — like you're telling someone to be quiet in a library 🤫\nHold for 5 seconds, repeat 5 times.", icon: "waveform", durationSeconds: 25),
                ExerciseStep(title: "SH Words", instruction: "Say each word clearly:\n🚢 Ship… Shoe… Shop… Shell… Shower\nKeep your lips rounded!", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "CH Words", instruction: "Now the CH sound (similar but with a pop):\n🧀 Chair… Cheese… Cherry… Chalk… Chest\nStart with a T-like tap.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "SH/CH Sentences", instruction: "Read slowly:\n\"She chose chocolate chip cookies from the charming shop.\"\nRepeat 3 times.", icon: "quote.bubble.fill", durationSeconds: 30),
                ExerciseStep(title: "Cool Down", instruction: "Wonderful session! 🎉\nRelax your lips and jaw. Breathe deeply 3 times.\nYou're making great progress!", icon: "sparkles", durationSeconds: 12)
            ]
        case .k:
            return [
                ExerciseStep(title: "Gargle Warm Up", instruction: "Take a small sip of water and gently gargle.\n(Or pretend to gargle without water.)\nThis activates the back of your tongue.", icon: "face.smiling", durationSeconds: 15),
                ExerciseStep(title: "Back Tongue Lift", instruction: "Press the BACK of your tongue up against the soft part of the roof of your mouth (soft palate).\nHold for 3 seconds, release. Repeat 5 times.", icon: "mouth.fill", durationSeconds: 20),
                ExerciseStep(title: "Coughing Sound", instruction: "Make a gentle cough sound: \"kuh kuh kuh\"\nFeel the back of your tongue pop away from the roof.\nRepeat 8 times, slowly.", icon: "waveform", durationSeconds: 22),
                ExerciseStep(title: "K Words", instruction: "Say each word clearly:\n🐱 Cat… Cup… Cake… Kite… King\nFeel the pop at the back of your mouth.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "G Words", instruction: "Now the G sound (same position, but buzzy):\n🐐 Go… Game… Gate… Goat… Girl\nFeel the vibration.", icon: "character.bubble", durationSeconds: 25),
                ExerciseStep(title: "K/G Sentences", instruction: "Read slowly:\n\"The kind king gave the good girl a golden cake.\"\nRepeat 3 times.", icon: "quote.bubble.fill", durationSeconds: 30),
                ExerciseStep(title: "Cool Down", instruction: "Excellent work! 🎉\nRelax completely. Take 3 deep breaths.\nYour K and G sounds are improving!", icon: "sparkles", durationSeconds: 12)
            ]
        }
    }
}

// MARK: - Age Group
/// Helps tailor language complexity in exercises
enum AgeGroup: String, Codable, CaseIterable, Identifiable {
    case child = "5-12"
    case teen = "13-17"
    case adult = "18+"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .child: return "Child (5-12)"
        case .teen: return "Teen (13-17)"
        case .adult: return "Adult (18+)"
        }
    }
    
    var emoji: String {
        switch self {
        case .child: return "🧒"
        case .teen: return "🧑"
        case .adult: return "🧑‍💼"
        }
    }
}

// MARK: - User Profile
/// Stores the user's personal information and speech difficulty details.
/// Used to personalize the practice experience.
struct UserProfile: Codable {
    var name: String
    var ageGroup: AgeGroup
    var selectedSounds: [SpeechSound]
    var onboardingCompleted: Bool
    
    static let `default` = UserProfile(
        name: "",
        ageGroup: .adult,
        selectedSounds: [.r],
        onboardingCompleted: false
    )
}
