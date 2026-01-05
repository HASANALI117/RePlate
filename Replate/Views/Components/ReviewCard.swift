//
//  ReviewCard.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

@IBDesignable
class ReviewCard: UIView {
    
    // MARK: - Inspectable Properties
    @IBInspectable var cardTitle: String = "Card Title" {
        didSet {
            titleLabel.text = cardTitle
        }
    }
    
    @IBInspectable var showChevron: Bool = true {
        didSet {
            chevronButton.isHidden = !showChevron
        }
    }
    
    @IBInspectable var cornerRadiusValue: CGFloat = 12 {
        didSet {
            layer.cornerRadius = cornerRadiusValue
        }
    }
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chevronButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initialization
    init(title: String) {
        super.init(frame: .zero)
        self.cardTitle = title
        titleLabel.text = title
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = cornerRadiusValue
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor

        titleLabel.text = cardTitle
        chevronButton.isHidden = !showChevron
        
        addSubview(titleLabel)
        addSubview(chevronButton)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            chevronButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            chevronButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronButton.widthAnchor.constraint(equalToConstant: 20),
            chevronButton.heightAnchor.constraint(equalToConstant: 20),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Public Methods
    func addRow(icon: String, iconColor: UIColor, label: String, value: String) {
        let rowView = ReviewRowView(icon: icon, iconColor: iconColor, label: label, value: value)
        stackView.addArrangedSubview(rowView)
    }
}

// MARK: - Review Row View
class ReviewRowView: UIView {
    
    init(icon: String, iconColor: UIColor, label: String, value: String) {
        super.init(frame: .zero)
        setupView(icon: icon, iconColor: iconColor, label: label, value: value)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(icon: String, iconColor: UIColor, label: String, value: String) {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = iconColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let labelLabel = UILabel()
        labelLabel.text = label
        labelLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        labelLabel.textColor = .systemGray
        labelLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 15)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [labelLabel, valueLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconImageView)
        addSubview(textStack)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            textStack.topAnchor.constraint(equalTo: topAnchor),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
