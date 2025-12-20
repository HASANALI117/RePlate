//
//  DonationService.swift
//  Replate
//
//  Created on 2025-12-20.
//

import Foundation
import FirebaseFirestore

class DonationService {

    // MARK: - Singleton
    static let shared = DonationService()

    private init() {}

    // MARK: - Properties
    private let db = Firestore.firestore()

    // MARK: - Donation Methods

    /// Save a new donation to Firestore
    func createDonation(_ donation: Donation, completion: @escaping (Result<Donation, Error>) -> Void) {
        let donationRef = db.collection(Constants.Firebase.donationsCollection).document()

        var updatedDonation = donation
        updatedDonation.id = donationRef.documentID

        donationRef.setData(updatedDonation.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(updatedDonation))
            }
        }
    }

    /// Fetch all donations from Firestore
    func fetchDonations(completion: @escaping (Result<[Donation], Error>) -> Void) {
        db.collection(Constants.Firebase.donationsCollection)
            .whereField("status", isEqualTo: Donation.DonationStatus.available.rawValue)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                let donations = snapshot?.documents.compactMap { doc -> Donation? in
                    return Donation.from(dictionary: doc.data())
                } ?? []

                completion(.success(donations))
            }
    }

    /// Fetch donations by donor ID
    func fetchDonationsByDonor(donorId: String, completion: @escaping (Result<[Donation], Error>) -> Void) {
        db.collection(Constants.Firebase.donationsCollection)
            .whereField("donorId", isEqualTo: donorId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                let donations = snapshot?.documents.compactMap { doc -> Donation? in
                    return Donation.from(dictionary: doc.data())
                } ?? []

                completion(.success(donations))
            }
    }

    /// Update donation status
    func updateDonationStatus(donationId: String, status: Donation.DonationStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(Constants.Firebase.donationsCollection)
            .document(donationId)
            .updateData(["status": status.rawValue]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

    /// Delete a donation
    func deleteDonation(donationId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(Constants.Firebase.donationsCollection)
            .document(donationId)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
}
