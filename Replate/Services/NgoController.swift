//
//  NgoController.swift
//  Replate
//
//  Created by Abdulla on 31/12/2025.
//

import FirebaseFirestore

final class NgoController {
    static let shared = NgoController()
    private init() {}

    func getAllNgo() async throws -> [Ngo] {

        let snapshot = try await Firestore.firestore()
            .collection("Ngo")
            .whereField("status", isEqualTo: "Verified")
            .getDocuments()

        let ngos = snapshot.documents.compactMap { doc -> Ngo? in
            let data = doc.data()

            guard
                let name = data["name"] as? String,
                let description = data["description"] as? String,
                let imageUrl = data["imageUrl"] as? String,
                let location = data["location"] as? String,
                let rating = data["rating"] as? Double,
                let totalDonations = data["totalDonations"] as? Int,
                let focusAreas = data["focusAreas"] as? [String],
                let verificationType = data["verificationType"] as? String,
                let transparency = data["transparency"] as? Double,
                let impact = data["impact"] as? Double,
                let reliability = data["reliability"] as? Double,
                let registrationId = data["registrationId"] as? String,
                let registrationDate = data["registrationDate"] as? String
            else {
                return nil
            }

            let galleryImages = data["galleryImages"] as? [String] ?? []

            let reviewsArray = data["reviews"] as? [[String: Any]] ?? []
            let reviews: [NgoRating] = reviewsArray.compactMap { item -> NgoRating? in
                guard
                    let userName = item["userName"] as? String,
                    let content = item["content"] as? String,
                    let rate = item["rate"] as? Int,
                    let t = item["transparency"] as? Double,
                    let i = item["impact"] as? Double,
                    let r = item["reliability"] as? Double,
                    let createdAt = item["createdAt"] as? Timestamp
                else { return nil }

                return NgoRating(
                    userName: userName,
                    rate: rate,
                    createdAt: createdAt.dateValue(),
                    content: content,
                    transparency: t,
                    impact: i,
                    reliability: r
                )
            }

            return Ngo(
                id: doc.documentID,
                name: name,
                description: description,
                imageUrl: imageUrl,
                location: location,
                rating: rating,
                totalDonations: totalDonations,
                focusAreas: focusAreas,
                verificationType: verificationType,
                galleryImages: galleryImages,
                reviews: reviews,
                transparency: transparency,
                impact: impact,
                reliability: reliability,
                registrationId: registrationId,
                registraionDate: registrationDate
            )
        }

        return ngos
    }

    
    func toggleNgoFollow(ngoID: String, userID: String) async throws {
           let db = Firestore.firestore()
           let ref = db.collection("Ngo").document(ngoID)

           try await db.runTransaction { transaction, errorPointer in
               do {
                   let snap = try transaction.getDocument(ref)
                   let followers = snap.data()?["followers"] as? [String] ?? []

                   if followers.contains(userID) {
                       transaction.updateData([
                           "followers": FieldValue.arrayRemove([userID])
                       ], forDocument: ref)
                   } else {
                       transaction.updateData([
                           "followers": FieldValue.arrayUnion([userID])
                       ], forDocument: ref)
                   }

                   return nil
               } catch let err as NSError {
                   errorPointer?.pointee = err
                   return nil
               }
           }
       }

       func isUserFollowingNgo(ngoID: String, userID: String) async throws -> Bool {
           let snap = try await Firestore.firestore()
               .collection("Ngo")
               .document(ngoID)
               .getDocument()

           let followers = snap.data()?["followers"] as? [String] ?? []
           return followers.contains(userID)
       }
    
    func getAllOrganizations() async throws -> [Organization] {

        let snapshot = try await Firestore.firestore()
            .collection("Ngo")
            .getDocuments()

        let organizations: [Organization] = snapshot.documents.compactMap { doc in
            let data = doc.data()

            guard
                let name = data["name"] as? String,
                let location = data["location"] as? String,
                let regestrationDate = data["registrationDate"] as? String,
                let status = data["status"] as? String,
                let email = data["email"] as? String,
                let phone = data["phone"] as? String
            else {
                return nil
            }

            let documents = data["documents"] as? [String] ?? []

            return Organization(
                id: doc.documentID,
                name: name,
                location: location,
                regestrationDate: regestrationDate,
                documents: documents,
                status: status,
                email: email,
                phone: phone
            )
        }

        return organizations
    }
    
    func setOrganizationStatus(id: String, status: String, content: String, verificationType: String) async throws {
        try await Firestore.firestore()
            .collection("Ngo")
            .document(id)
            .updateData([
                "status": status,
                "comment": content,
                "verificationType": verificationType
            ])
    }


}

