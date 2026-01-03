import UIKit

class FontManager {
    
    // SF Pro font system from prompt specifications
    static func sfProFont(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        if let font = UIFont(name: "SFPro-Regular", size: size) {
            return font
        }
        // Fallback to system font as specified in prompt
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    // Exact font sizes from CSS specifications in prompt
    static let largeTitle = sfProFont(size: 30, weight: .bold) // 30px
    static let title1 = sfProFont(size: 21.8, weight: .medium) // 21.8px
    static let title2 = sfProFont(size: 14.9, weight: .medium) // 14.9px
    static let subtitle = sfProFont(size: 13.3, weight: .regular) // 13.3px
    
    // Font weights from prompt: Regular (400), Medium (590)
    static func regularFont(size: CGFloat) -> UIFont {
        return sfProFont(size: size, weight: .regular) // 400 weight
    }
    
    static func mediumFont(size: CGFloat) -> UIFont {
        return sfProFont(size: size, weight: .medium) // 590 weight approximation
    }
    
    // Legacy fonts for compatibility
    static let titleFont = UIFont.systemFont(ofSize: 30, weight: .medium)
    static let subtitleFont = UIFont.systemFont(ofSize: 13.3, weight: .regular)
    static let searchPlaceholderFont = UIFont.systemFont(ofSize: 14.5, weight: .regular)
    
    // Stat card fonts
    static let statNumber1Font = UIFont.systemFont(ofSize: 21.8, weight: .medium)
    static let statNumber2Font = UIFont.systemFont(ofSize: 21.2, weight: .medium)
    static let statNumber3Font = UIFont.systemFont(ofSize: 23.4, weight: .medium)
    static let statNumber4Font = UIFont.systemFont(ofSize: 22.1, weight: .medium)
    
    static let statLabel1Font = UIFont.systemFont(ofSize: 10.7, weight: .regular)
    static let statLabel2Font = UIFont.systemFont(ofSize: 11.3, weight: .regular)
    static let statLabel3Font = UIFont.systemFont(ofSize: 11.1, weight: .regular)
    
    // Donation card fonts
    static let donationTitle1Font = UIFont.systemFont(ofSize: 14.6, weight: .medium)
    static let donationTitle2Font = UIFont.systemFont(ofSize: 15.1, weight: .medium)
    
    static let donationSubtitle1Font = UIFont.systemFont(ofSize: 12.9, weight: .regular)
    static let donationSubtitle2Font = UIFont.systemFont(ofSize: 13.2, weight: .regular)
    static let donationSubtitle3Font = UIFont.systemFont(ofSize: 12.8, weight: .regular)
    static let donationSubtitle4Font = UIFont.systemFont(ofSize: 13.3, weight: .regular)
    
    // Status fonts
    static let status1Font = UIFont.systemFont(ofSize: 11.1, weight: .medium)
    static let status2Font = UIFont.systemFont(ofSize: 11.3, weight: .medium)
    
    // Details fonts
    static let details1Font = UIFont.systemFont(ofSize: 13.2, weight: .regular)
    static let details2Font = UIFont.systemFont(ofSize: 13.6, weight: .regular)
    static let details3Font = UIFont.systemFont(ofSize: 12.7, weight: .regular)
    static let details4Font = UIFont.systemFont(ofSize: 13.1, weight: .regular)
    
    // Tab bar fonts
    static let tab1Font = UIFont.systemFont(ofSize: 9.4, weight: .regular)
    static let tab2Font = UIFont.systemFont(ofSize: 8.8, weight: .regular)
    static let tab3Font = UIFont.systemFont(ofSize: 9.5, weight: .regular)
    static let tab4Font = UIFont.systemFont(ofSize: 9.1, weight: .regular)
}