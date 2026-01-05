//
//  DonationService.swift
//  Replate
//
//  Created on 2025-12-20.
//

import Foundation
import FirebaseDatabase

class DonationService {

    // MARK: - Singleton
    static let shared = DonationService()

    private init() {}

    // MARK: - Properties
    private let db = Database.database().reference()

    // MARK: - Donation Methods

    /// Save a new donation to Realtime Database
    func createDonation(_ donation: Donation, completion: @escaping (Result<Donation, Error>) -> Void) {
        let donationRef = db.child(Constants.Firebase.donationsCollection).childByAutoId()

        var updatedDonation = donation
        updatedDonation.id = donationRef.key

        print("DEBUG: DonationService - Saving to Realtime Database path: \(Constants.Firebase.donationsCollection)")
        print("DEBUG: DonationService - Document ID: \(donationRef.key ?? "unknown")")
        print("DEBUG: DonationService - Donation data: \(updatedDonation.dictionary)")

        donationRef.setValue(updatedDonation.dictionary) { error, _ in
            if let error = error {
                print("DEBUG: DonationService - ❌ Realtime Database save failed: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("DEBUG: DonationService - ✅ Realtime Database save successful!")
                completion(.success(updatedDonation))
            }
        }
    }

    /// Fetch all donations from Realtime Database
    func fetchDonations(completion: @escaping (Result<[Donation], Error>) -> Void) {
        db.child(Constants.Firebase.donationsCollection)
            .queryOrdered(byChild: "status")
            .queryEqual(toValue: Donation.DonationStatus.available.rawValue)
            .observeSingleEvent(of: .value) { snapshot in
                guard snapshot.exists() else {
                    completion(.success([]))
                    return
                }

                var donations: [Donation] = []
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let dict = childSnapshot.value as? [String: Any],
                       let donation = Donation.from(dictionary: dict) {
                        donations.append(donation)
                    }
                }

                completion(.success(donations))
            }
    }

    /// Fetch donations by donor ID
    func fetchDonationsByDonor(donorId: String, completion: @escaping (Result<[Donation], Error>) -> Void) {
        db.child(Constants.Firebase.donationsCollection)
            .queryOrdered(byChild: "donorId")
            .queryEqual(toValue: donorId)
            .observeSingleEvent(of: .value) { snapshot in
                guard snapshot.exists() else {
                    completion(.success([]))
                    return
                }

                var donations: [Donation] = []
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let dict = childSnapshot.value as? [String: Any],
                       let donation = Donation.from(dictionary: dict) {
                        donations.append(donation)
                    }
                }

                completion(.success(donations))
            }
    }

    /// Update donation status
    func updateDonationStatus(donationId: String, status: Donation.DonationStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        db.child(Constants.Firebase.donationsCollection)
            .child(donationId)
            .updateChildValues(["status": status.rawValue]) { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

    /// Delete a donation
    func deleteDonation(donationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.child(Constants.Firebase.donationsCollection)
            .child(donationId)
            .removeValue { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
}
