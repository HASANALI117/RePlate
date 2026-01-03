import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let role: UserRole
    let isActive: Bool
    let joinDate: Date
    let profileImageURL: String?
    
    enum UserRole: String, CaseIterable, Codable {
        case donor = "donor"
        case ngo = "ngo"
        case admin = "admin"
        
        var displayName: String {
            switch self {
            case .admin: return "Administrator"
            case .donor: return "Donor"
            case .ngo: return "NGO Representative"
            }
        }
    }
}