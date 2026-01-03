import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "currentUser"
    private let isLoggedInKey = "isLoggedIn"
    private let userPreferencesKey = "userPreferences"
    
    private init() {}
    
    // MARK: - Session Management
    var isLoggedIn: Bool {
        get { userDefaults.bool(forKey: isLoggedInKey) }
        set { userDefaults.set(newValue, forKey: isLoggedInKey) }
    }
    
    var currentUser: User? {
        get {
            guard let data = userDefaults.data(forKey: currentUserKey),
                  let user = try? JSONDecoder().decode(User.self, from: data) else {
                return nil
            }
            return user
        }
        set {
            if let user = newValue,
               let data = try? JSONEncoder().encode(user) {
                userDefaults.set(data, forKey: currentUserKey)
                isLoggedIn = true
            } else {
                userDefaults.removeObject(forKey: currentUserKey)
                isLoggedIn = false
            }
        }
    }
    
    // MARK: - App Preferences
    struct AppPreferences: Codable {
        var isDarkModeEnabled: Bool = false
        var notificationsEnabled: Bool = true
        var language: String = "en"
        var lastSyncDate: Date?
    }
    
    var preferences: AppPreferences {
        get {
            guard let data = userDefaults.data(forKey: userPreferencesKey),
                  let prefs = try? JSONDecoder().decode(AppPreferences.self, from: data) else {
                return AppPreferences()
            }
            return prefs
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: userPreferencesKey)
            }
        }
    }
    
    // MARK: - Session Actions
    func login(user: User) {
        currentUser = user
        FirebaseManager.shared.logScreenView("UserLogin")
    }
    
    func logout() {
        currentUser = nil
        clearTemporaryData()
    }
    
    private func clearTemporaryData() {
        // Clear any temporary cached data
        userDefaults.removeObject(forKey: "cachedDonations")
        userDefaults.removeObject(forKey: "lastRefreshTime")
    }
    
    // MARK: - Temporary Data Storage
    func setCachedDonations(_ donations: [Donation]) {
        if let data = try? JSONEncoder().encode(donations) {
            userDefaults.set(data, forKey: "cachedDonations")
            userDefaults.set(Date(), forKey: "lastRefreshTime")
        }
    }
    
    func getCachedDonations() -> [Donation]? {
        guard let data = userDefaults.data(forKey: "cachedDonations"),
              let donations = try? JSONDecoder().decode([Donation].self, from: data) else {
            return nil
        }
        return donations
    }
}