import UIKit

extension UIColor {
    
    // Exact color palette from prompt
    static let primaryGreen = UIColor(red: 53/255, green: 123/255, blue: 73/255, alpha: 1) // #357B49
    static let seaGreen = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1) // #2E8B57
    static let coral = UIColor(red: 255/255, green: 140/255, blue: 66/255, alpha: 1) // #FF8C42
    static let heliotrope = UIColor(red: 173/255, green: 70/255, blue: 255/255, alpha: 1) // #AD46FF
    static let dodgerBlue = UIColor(red: 43/255, green: 127/255, blue: 255/255, alpha: 1) // #2B7FFF
    static let redOrange = UIColor(red: 251/255, green: 44/255, blue: 54/255, alpha: 1) // #FB2C36
    static let ebony = UIColor(red: 16/255, green: 24/255, blue: 40/255, alpha: 1) // #101828
    static let paleSky = UIColor(red: 106/255, green: 114/255, blue: 130/255, alpha: 1) // #6A7282
    static let athensGray = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1) // #F9FAFB
    
    // Legacy colors for compatibility
    static let secondaryGreen = seaGreen
    static let donationHeaderGreen = primaryGreen
    static let greenHaze = UIColor(red: 0/255, green: 166/255, blue: 62/255, alpha: 1) // #00A63E
    static let codGray = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1) // #0A0A0A
    static let grayChateau = UIColor(red: 153/255, green: 161/255, blue: 175/255, alpha: 1) // #99A1AF
    static let redTint = UIColor(red: 255/255, green: 56/255, blue: 60/255, alpha: 0.1) // rgba(255, 56, 60, 0.1)
    
    // Background colors - system support for light/dark mode
    static let lightGray = UIColor.systemGray6 // Adaptive background
    static let greenTint = UIColor(red: 53/255, green: 123/255, blue: 73/255, alpha: 0.1) // rgba(53, 123, 73, 0.1)
    
    // Text colors - adaptive for light/dark mode
    static let textPrimary = UIColor.label // System adaptive
    static let textSecondary = UIColor.secondaryLabel // System adaptive
    static let textWhite80 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8) // White at 80% opacity
    
    // Tab bar colors
    static let tabSelected = seaGreen
    static let tabUnselected = grayChateau
    static let tabTextUnselected = paleSky
    
    // Status colors
    static let statusActive = greenHaze
    static let statusClaimed = codGray
    static let statusExpired = grayChateau
    static let statusFlagged = redOrange
    
    // Convenience initializer for hex colors
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}