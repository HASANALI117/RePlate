import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseAnalytics
import Cloudinary
import SDWebImage

class FirebaseManager {
    static let shared = FirebaseManager()
    private let database = Database.database().reference()
    private let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "your-cloud-name", secure: true))
    
    private init() {}
    
    // MARK: - Authentication
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                completion(.success(User(id: user.uid, name: "Admin User", email: user.email ?? "", role: .admin, isActive: true, joinDate: Date(), profileImageURL: nil)))
            }
        }
    }
    
    // MARK: - Image Upload with Cloudinary
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let uploader = cloudinary.createUploader()
        uploader.upload(data: imageData, uploadPreset: "your-upload-preset") { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result, let url = result.secureUrl {
                completion(.success(url))
            }
        }
    }
    
    // MARK: - Donations CRUD - Realtime Database
    func fetchDonations(completion: @escaping (Result<[Donation], Error>) -> Void) {
        database.child("donations").observeSingleEvent(of: .value) { snapshot in
            var donations: [Donation] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let data = childSnapshot.value as? [String: Any] {
                    let donation = Donation(
                        id: childSnapshot.key,
                        title: data["title"] as? String ?? "",
                        donor: data["donor"] as? String ?? "",
                        type: data["type"] as? String ?? "",
                        status: DonationStatus(rawValue: data["status"] as? String ?? "") ?? .active,
                        timeAgo: data["timeAgo"] as? String ?? "",
                        claimCount: data["claimCount"] as? Int ?? 0,
                        imageURL: data["imageURL"] as? String
                    )
                    donations.append(donation)
                }
            }
            
            completion(.success(donations))
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    func addDonation(_ donation: Donation, completion: @escaping (Result<Void, Error>) -> Void) {
        var data: [String: Any] = [
            "title": donation.title,
            "donor": donation.donor,
            "type": donation.type,
            "status": donation.status.rawValue,
            "timeAgo": donation.timeAgo,
            "claimCount": donation.claimCount,
            "createdAt": ServerValue.timestamp()
        ]
        
        if let imageURL = donation.imageURL {
            data["imageURL"] = imageURL
        }
        
        database.child("donations").child(donation.id).setValue(data) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                Analytics.logEvent("donation_added", parameters: ["type": donation.type])
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Analytics
    func logScreenView(_ screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }
    
    // MARK: - Admin Dashboard Metrics
    func getAdminMetrics(completion: @escaping (Result<AdminMetrics, Error>) -> Void) {
        let metrics = AdminMetrics(
            totalUsers: 2847,
            activeDonations: 432,
            verifiedNGOs: 47,
            totalImpact: 12400
        )
        completion(.success(metrics))
    }
    
    // MARK: - Test Data Generation
    func generateTestData() {
        let testDonations = [
            Donation(id: "1", title: "Fresh Vegetables", donor: "Local Farm", type: "Produce", status: .active, timeAgo: "2 hours ago", claimCount: 3),
            Donation(id: "2", title: "Bakery Items", donor: "City Bakery", type: "Baked Goods", status: .claimed, timeAgo: "5 hours ago", claimCount: 1),
            Donation(id: "3", title: "Canned Foods", donor: "Supermarket", type: "Non-perishable", status: .expired, timeAgo: "1 day ago", claimCount: 0),
            Donation(id: "4", title: "Prepared Meals", donor: "Restaurant", type: "Ready-to-eat", status: .flagged, timeAgo: "3 hours ago", claimCount: 2)
        ]
        
        for donation in testDonations {
            addDonation(donation) { _ in }
        }
    }
}

struct AdminMetrics {
    let totalUsers: Int
    let activeDonations: Int
    let verifiedNGOs: Int
    let totalImpact: Int
}