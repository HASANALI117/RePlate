//
//  CategoryButton.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

@IBDesignable
class CategoryBtn: UIButton {
    
    // MARK: - Inspectable Properties
    @IBInspectable var categoryName: String = "" {
        didSet {
            label.text = categoryName
        }
    }
    
    @IBInspectable var iconName: String = "leaf.fill" {
        didSet {
            iconImageView.image = UIImage(systemName: iconName)
        }
    }
    
    @IBInspectable var iconColor: UIColor = Constants.Colors.primaryGreen {
        didSet {
            iconImageView.tintColor = iconColor
        }
    }
    
    @IBInspectable var selectedBorderColor: UIColor = Constants.Colors.primaryGreen
    @IBInspectable var selectedBackgroundAlpha: CGFloat = 0.05
    
    // MARK: - Properties
    var category: Donation.DonationCategory!
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    // MARK: - Initialization
    init(category: Donation.DonationCategory) {
        self.category = category
        super.init(frame: .zero)
        self.categoryName = category.rawValue
        self.iconName = category.icon
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }

    // MARK: - Setup
    private func setupButton() {
        // Container setup
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray5.cgColor
        
        // Set initial values
        iconImageView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = isSelected ? Constants.Colors.primaryGreen : .systemGray3
        label.text = categoryName

        addSubview(iconImageView)
        addSubview(label)
        addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14)
        ])

        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            layer.borderColor = selectedBorderColor.cgColor
            backgroundColor = selectedBorderColor.withAlphaComponent(selectedBackgroundAlpha)
            iconImageView.tintColor = selectedBorderColor
        } else {
            layer.borderColor = UIColor.systemGray5.cgColor
            backgroundColor = .white
            iconImageView.tintColor = .systemGray3
        }
    }
}
