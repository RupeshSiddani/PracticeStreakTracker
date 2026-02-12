import Foundation

// MARK: - Persistence Service
/// Handles saving and loading user data to local storage using UserDefaults with JSON encoding.
/// This approach provides reliable persistence across app launches without requiring CoreData.
final class PersistenceService {
    
    static let shared = PersistenceService()
    
    private let userDefaults = UserDefaults.standard
    private let userDataKey = "com.topspeech.streaktracker.userData"
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Save
    
    /// Saves the user data to UserDefaults
    /// - Parameter data: The UserData to persist
    /// - Throws: Encoding errors if data cannot be serialized
    func save(_ data: UserData) throws {
        let encoded = try encoder.encode(data)
        userDefaults.set(encoded, forKey: userDataKey)
    }
    
    // MARK: - Load
    
    /// Loads user data from UserDefaults
    /// - Returns: The saved UserData, or default data if none exists
    func load() -> UserData {
        guard let data = userDefaults.data(forKey: userDataKey) else {
            return UserData.default
        }
        
        do {
            return try decoder.decode(UserData.self, from: data)
        } catch {
            print("[PersistenceService] Failed to decode user data: \(error.localizedDescription)")
            return UserData.default
        }
    }
    
    // MARK: - Reset
    
    /// Removes all persisted data (useful for testing or account reset)
    func resetAll() {
        userDefaults.removeObject(forKey: userDataKey)
    }
}
