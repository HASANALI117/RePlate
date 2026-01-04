//
//  OrganizationCell.swift
//  Replate
//
//  Created by Abdulla on 31/12/2025.
//

import UIKit

final class OrganizationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var regDateLabel: UILabel!
    @IBOutlet weak var totalDocumentsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var detailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusLabel.layer.cornerRadius = 12
        statusLabel.layer.masksToBounds = true
    }

    func configure(with org: Organization) {
        nameLabel.text = org.name
        locationLabel.text = org.location
        regDateLabel.text = "Registered: \(org.regestrationDate)"
        totalDocumentsLabel.text = "Documents: \(org.documents.count) files"

        statusLabel.text = org.status
        applyStatusStyle(status: org.status)
        
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        
    }

    private func applyStatusStyle(status: String) {
        switch status.lowercased() {

        case "verified":
            statusLabel.textColor = UIColor(red: 22/255, green: 101/255, blue: 52/255, alpha: 1)
            statusLabel.backgroundColor = UIColor(red: 220/255, green: 252/255, blue: 231/255, alpha: 1)

        case "pending":
            statusLabel.textColor = UIColor(red: 133/255, green: 77/255, blue: 14/255, alpha: 1)
            statusLabel.backgroundColor = UIColor(red: 254/255, green: 249/255, blue: 195/255, alpha: 1)

        case "rejected":
            statusLabel.textColor = UIColor(red: 153/255, green: 27/255, blue: 27/255, alpha: 1)
            statusLabel.backgroundColor = UIColor(red: 254/255, green: 226/255, blue: 226/255, alpha: 1)

        default:
            statusLabel.textColor = .label
            statusLabel.backgroundColor = .systemGray5
        }
    }
}
