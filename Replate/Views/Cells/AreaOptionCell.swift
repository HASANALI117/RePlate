//
//  AreaOptionCell.swift
//  Replate
//
//  Created by Abdulla on 29/12/2025.
//

import UIKit

final class AreaOptionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!

    var onToggle: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        // ✅ NO background
        checkBox.backgroundColor = .clear
        
        // ✅ No system highlight/border
        checkBox.adjustsImageWhenHighlighted = false
        checkBox.adjustsImageWhenDisabled = false
        checkBox.layer.borderWidth = 0

        // ✅ Gray checkbox color
        checkBox.tintColor = .systemGray

        // ✅ Default unchecked icon
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)

        checkBox.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
    }

    @objc private func toggleTapped() {
        onToggle?()
    }

    func configure(title: String, isChecked: Bool) {
        titleLabel.text = title

        let imageName = isChecked ? "checkmark.square.fill" : "square"
        checkBox.setImage(UIImage(systemName: imageName), for: .normal)
        checkBox.tintColor = .systemGray
    }
}

