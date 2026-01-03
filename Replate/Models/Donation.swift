//
//  Donation.swift
//  Replate
//
//  Created on 2025-12-17.
//

import Foundation

struct Donation: Codable {
    var id: String?
    let donorId: String
    var category: DonationCategory
    var itemName: String
    var quantity: Int
    var quantityUnit: QuantityUnit
    var photo: String? // URL to stored image
    var description: String
    var expiryDate: Date?
    var allergens: [AllergenInfo]
    var location: LocationInfo
    var pickupTime: PickupTime
    var specialInstructions: String?
    var createdAt: Date
    var updatedAt: Date
    var status: DonationStatus

    enum DonationCategory: String, Codable {
        case freshProduce = "Fresh Produce"
        case cookedMeals = "Cooked Meals"
        case packagedGoods = "Packaged Goods"

        var icon: String {
            switch self {
            case .freshProduce: return "leaf.circle.fill"
            case .cookedMeals: return "flame.circle.fill"
            case .packagedGoods: return "shippingbox.circle.fill"
            }
        }
    }

    enum QuantityUnit: String, Codable {
        case bags = "Bags"
        case plates = "Plates"
        case boxes = "Boxes"
        case items = "Items"
        case servings = "Servings"
    }

    enum AllergenInfo: String, Codable, CaseIterable {
        case containsNuts = "Contains Nuts"
        case glutenFree = "Gluten-Free"
        case dairyFree = "Dairy-Free"
        case vegan = "Vegan"
        case containsShellfish = "Contains Shellfish"
        case eggFree = "Egg-free"

        var displayName: String {
            return self.rawValue
        }
    }

    struct LocationInfo: Codable {
        var address: String
        var latitude: Double?
        var longitude: Double?
        var useCurrentLocation: Bool

        init(address: String = "", latitude: Double? = nil, longitude: Double? = nil, useCurrentLocation: Bool = false) {
            self.address = address
            self.latitude = latitude
            self.longitude = longitude
            self.useCurrentLocation = useCurrentLocation
        }
    }

    enum PickupTime: Codable, Equatable {
        case asap
        case scheduled(Date)

        var displayText: String {
            switch self {
            case .asap:
                return "As soon as possible"
            case .scheduled(let date):
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                return formatter.string(from: date)
            }
        }

        enum CodingKeys: String, CodingKey {
            case type
            case date
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)

            if type == "asap" {
                self = .asap
            } else {
                let date = try container.decode(Date.self, forKey: .date)
                self = .scheduled(date)
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .asap:
                try container.encode("asap", forKey: .type)
            case .scheduled(let date):
                try container.encode("scheduled", forKey: .type)
                try container.encode(date, forKey: .date)
            }
        }
    }

    enum DonationStatus: String, Codable {
        case draft
        case available
        case claimed
        case pickedUp
        case cancelled
    }

    init(donorId: String,
         category: DonationCategory = .freshProduce,
         itemName: String = "",
         quantity: Int = 0,
         quantityUnit: QuantityUnit = .bags,
         photo: String? = nil,
         description: String = "",
         expiryDate: Date? = nil,
         allergens: [AllergenInfo] = [],
         location: LocationInfo = LocationInfo(),
         pickupTime: PickupTime = .asap,
         specialInstructions: String? = nil,
         status: DonationStatus = .draft) {
        self.id = nil
        self.donorId = donorId
        self.category = category
        self.itemName = itemName
        self.quantity = quantity
        self.quantityUnit = quantityUnit
        self.photo = photo
        self.description = description
        self.expiryDate = expiryDate
        self.allergens = allergens
        self.location = location
        self.pickupTime = pickupTime
        self.specialInstructions = specialInstructions
        self.createdAt = Date()
        self.updatedAt = Date()
        self.status = status
    }

    // Realtime Database conversion
    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "donorId": donorId,
            "category": category.rawValue,
            "itemName": itemName,
            "quantity": quantity,
            "quantityUnit": quantityUnit.rawValue,
            "description": description,
            "allergens": allergens.map { $0.rawValue },
            "location": [
                "address": location.address,
                "latitude": location.latitude as Any,
                "longitude": location.longitude as Any,
                "useCurrentLocation": location.useCurrentLocation
            ],
            "createdAt": createdAt.timeIntervalSince1970,
            "updatedAt": updatedAt.timeIntervalSince1970,
            "status": status.rawValue
        ]

        if let id = id {
            dict["id"] = id
        }
        if let photo = photo {
            dict["photo"] = photo
        }
        if let expiryDate = expiryDate {
            dict["expiryDate"] = expiryDate.timeIntervalSince1970
        }
        if let specialInstructions = specialInstructions {
            dict["specialInstructions"] = specialInstructions
        }

        // Encode pickupTime
        switch pickupTime {
        case .asap:
            dict["pickupTimeType"] = "asap"
        case .scheduled(let date):
            dict["pickupTimeType"] = "scheduled"
            dict["pickupTimeDate"] = date.timeIntervalSince1970
        }

        return dict
    }

    static func from(dictionary: [String: Any]) -> Donation? {
        guard let donorId = dictionary["donorId"] as? String,
              let categoryString = dictionary["category"] as? String,
              let category = DonationCategory(rawValue: categoryString),
              let itemName = dictionary["itemName"] as? String,
              let quantity = dictionary["quantity"] as? Int,
              let quantityUnitString = dictionary["quantityUnit"] as? String,
              let quantityUnit = QuantityUnit(rawValue: quantityUnitString),
              let description = dictionary["description"] as? String,
              let createdAtTimestamp = dictionary["createdAt"] as? TimeInterval,
              let updatedAtTimestamp = dictionary["updatedAt"] as? TimeInterval,
              let statusString = dictionary["status"] as? String,
              let status = DonationStatus(rawValue: statusString) else {
            return nil
        }

        let allergenStrings = dictionary["allergens"] as? [String] ?? []
        let allergens = allergenStrings.compactMap { AllergenInfo(rawValue: $0) }

        let locationDict = dictionary["location"] as? [String: Any] ?? [:]
        let location = LocationInfo(
            address: locationDict["address"] as? String ?? "",
            latitude: locationDict["latitude"] as? Double,
            longitude: locationDict["longitude"] as? Double,
            useCurrentLocation: locationDict["useCurrentLocation"] as? Bool ?? false
        )

        let pickupTimeType = dictionary["pickupTimeType"] as? String ?? "asap"
        let pickupTime: PickupTime
        if pickupTimeType == "asap" {
            pickupTime = .asap
        } else if let pickupTimestamp = dictionary["pickupTimeDate"] as? TimeInterval {
            pickupTime = .scheduled(Date(timeIntervalSince1970: pickupTimestamp))
        } else {
            pickupTime = .asap
        }

        let expiryDate: Date?
        if let expiryTimestamp = dictionary["expiryDate"] as? TimeInterval {
            expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
        } else {
            expiryDate = nil
        }

        var donation = Donation(
            donorId: donorId,
            category: category,
            itemName: itemName,
            quantity: quantity,
            quantityUnit: quantityUnit,
            photo: dictionary["photo"] as? String,
            description: description,
            expiryDate: expiryDate,
            allergens: allergens,
            location: location,
            pickupTime: pickupTime,
            specialInstructions: dictionary["specialInstructions"] as? String,
            status: status
        )

        donation.id = dictionary["id"] as? String
        donation.createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        donation.updatedAt = Date(timeIntervalSince1970: updatedAtTimestamp)

        return donation
    }
}
