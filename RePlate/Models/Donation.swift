import UIKit

struct Donation: Codable {
    let id: String
    let title: String
    let donor: String
    let type: String // "Cooked Meals", "Fresh Produce"
    let status: DonationStatus
    let timeAgo: String
    let claimCount: Int
    let imageURL: String? // New property for image URL
    
    var iconColor: UIColor {
        switch status {
        case .active: return .primaryGreen
        case .claimed: return .codGray
        case .expired: return .grayChateau
        case .flagged: return .statusFlagged
        }
    }
    
    // Initializer for backward compatibility
    init(id: String, title: String, donor: String, type: String, status: DonationStatus, timeAgo: String, claimCount: Int, imageURL: String? = nil) {
        self.id = id
        self.title = title
        self.donor = donor
        self.type = type
        self.status = status
        self.timeAgo = timeAgo
        self.claimCount = claimCount
        self.imageURL = imageURL
    }
}

enum DonationStatus: String, CaseIterable, Codable {
    case active = "active"
    case claimed = "claimed"
    case expired = "expired"
    case flagged = "flagged"
    
    var displayText: String {
        switch self {
        case .active: return "Active"
        case .claimed: return "Claimed"
        case .expired: return "Expired"
        case .flagged: return "Flagged"
        }
    }
    
    var color: UIColor {
        switch self {
        case .active: return UIColor(red: 0/255, green: 166/255, blue: 62/255, alpha: 1) // #00A63E
        case .claimed: return UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1) // #0A0A0A
        case .expired: return UIColor(red: 153/255, green: 161/255, blue: 175/255, alpha: 1) // #99A1AF
        case .flagged: return UIColor(red: 255/255, green: 56/255, blue: 60/255, alpha: 1) // #FF383C
        }
    }
}