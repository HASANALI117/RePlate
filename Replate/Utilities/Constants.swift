//
//  Constants.swift
//  Replate
//
//  Created by Hasan on 17/12/2025.
//

import UIKit

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
        static let primaryGreen = UIColor(red: 52/255, green: 168/255, blue: 83/255, alpha: 1.0)
        static let lightGreen = UIColor(red: 52/255, green: 168/255, blue: 83/255, alpha: 0.1)
        static let accentOrange = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
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
