//
//  typesCell.swift
//  ZAJEL
//
//  Created by wael on 26/05/2025.
//

import UIKit

class typesCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var typeTitle: UILabel!
    var selectTintColor: UIColor = .systemGreen {
           didSet {
               if isSelected {
                   configureAppearance(selected: true)
               }
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureAppearance(selected: false)
    }
    
    override var isSelected: Bool {
        didSet {
            configureAppearance(selected: isSelected)
        }
    }
    
    private func configureAppearance(selected: Bool) {
        if selected {
            container.backgroundColor = selectTintColor
            typeTitle.textColor = .white
            typeTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else {
            container.backgroundColor = .white
            typeTitle.textColor = .darkGray
            typeTitle.font = UIFont.systemFont(ofSize: 15)
        }
        container.layer.borderWidth = 0.4
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
    }
    
}
