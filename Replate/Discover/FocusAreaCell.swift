//
//  FocusAreaCell.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

final class FocusAreaCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = UIColor.systemGray5
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configure(text: String) {
        titleLabel.text = text
    }
}
