//
//  DocumentCell.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

final class DocumentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeFormatLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    func configure(fileName: String, sizeText: String) {
        nameLabel.text = fileName
        sizeFormatLabel.text = sizeText
        styleContainer()
    }
    
    private func styleContainer() {


        containerView.backgroundColor = .systemBackground
        containerView.layer.masksToBounds = true

        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        
        
        }
}
