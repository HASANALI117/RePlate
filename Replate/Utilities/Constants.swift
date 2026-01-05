//
//  Constants.swift
//  Replate
//
//  Created by Hasan on 17/12/2025.
//

import UIKit

// MARK: - UIColor Hex Extension
extension UIColor {
    /// Initialize UIColor with a hex string, e.g. "#357B49" or "357B49"
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove # if it exists
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // Must be 6 characters
        guard hexString.count == 6 else { return nil }
        
        // Convert hex to integer
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct Constants {

    // MARK: - App Configuration
    struct App {
        static let name = "RePlate"
        static let bundleIdentifier = "com.polytechnic.Replate"
    }

    // MARK: - Firebase Collections
    struct Firebase {
        static let usersCollection = "users"
        static let donationsCollection = "donations"
    }

    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let defaultPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
    }

    // MARK: - Colors
    struct Colors {
        static let primaryGreen = UIColor(hex: "#357B49")!
        static let lightGreen = UIColor(hex: "#34A853")!.withAlphaComponent(0.1)
        static let accentOrange = UIColor(hex: "#FF9800")!
        static let textPrimary = UIColor.black
        static let textSecondary = UIColor.darkGray
        static let background = UIColor.white
        static let cardBackground = UIColor.systemGray6
    }

    // MARK: - Animation Durations
    struct Animation {
        static let short: TimeInterval = 0.2
        static let medium: TimeInterval = 0.3
        static let long: TimeInterval = 0.5
    }

    // MARK: - User Defaults Keys
    struct UserDefaultsKeys {
        static let isFirstLaunch = "isFirstLaunch"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let userId = "userId"
    }
}
