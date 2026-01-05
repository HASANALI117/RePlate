//
//  NgoCell.swift
//  Replate
//
//  Created by Abdulla on 29/12/2025.
//

import UIKit

class NgoCell: UITableViewCell {
    @IBOutlet weak var ngoImageView: UIImageView!
    @IBOutlet weak var ngoNameLabel: UILabel!
    @IBOutlet weak var ngoDescriptionLabel: UILabel!
    @IBOutlet weak var ngoLocationLabel: UILabel!
    @IBOutlet weak var ngoRatingLabel: UILabel!
    @IBOutlet weak var totalDonations: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ngoImageView.layer.cornerRadius = 30
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
    }
}

