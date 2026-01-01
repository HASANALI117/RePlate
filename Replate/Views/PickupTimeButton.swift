//
//  PickupTimeButton.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

@IBDesignable
class PickupTimeButton: UIButton {
    
    enum ButtonType {
        case asap
        case scheduled
    }
    
    // MARK: - Inspectable Properties
    @IBInspectable var isASAP: Bool = true {
        didSet {
            buttonType = isASAP ? .asap : .scheduled
            updateContent()
        }
    }
    
    @IBInspectable var scheduledTime: String = "" {
        didSet {
            updateTimeLabel(scheduledTime)
        }
    }

    // MARK: - Properties
    var buttonType: ButtonType = .asap
    private let iconView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let timeLabel: UILabel = UILabel()
    private let radioButton: UIView = UIView()
    private let radioButtonFill: UIView = UIView()

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    // MARK: - Initialization
    init(type: ButtonType) {
        self.buttonType = type
        self.isASAP = (type == .asap)
        super.init(frame: .zero)
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }

    // MARK: - Setup
    private func setupButton() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor

        // Radio button
        radioButton.backgroundColor = .white
        radioButton.layer.cornerRadius = 10
        radioButton.layer.borderWidth = 2
        radioButton.layer.borderColor = UIColor.systemGray4.cgColor
        radioButton.translatesAutoresizingMaskIntoConstraints = false

        radioButtonFill.backgroundColor = Constants.Colors.primaryGreen
        radioButtonFill.layer.cornerRadius = 6
        radioButtonFill.isHidden = true
        radioButtonFill.translatesAutoresizingMaskIntoConstraints = false

        // Icon
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Time label (for scheduled)
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = .systemGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(radioButton)
        radioButton.addSubview(radioButtonFill)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(timeLabel)

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 20),
            radioButton.heightAnchor.constraint(equalToConstant: 20),

            radioButtonFill.centerXAnchor.constraint(equalTo: radioButton.centerXAnchor),
            radioButtonFill.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor),
            radioButtonFill.widthAnchor.constraint(equalToConstant: 12),
            radioButtonFill.heightAnchor.constraint(equalToConstant: 12),

            iconView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])

        updateContent()
        updateAppearance()
    }
    
    private func updateContent() {
        iconView.image = UIImage(systemName: buttonType == .asap ? "clock.fill" : "calendar")
        iconView.tintColor = Constants.Colors.primaryGreen
        titleLabel.text = buttonType == .asap ? "As soon as possible" : "Schedule a time"
        timeLabel.isHidden = buttonType == .asap
    }

    private func updateAppearance() {
        if isSelected {
            layer.borderColor = Constants.Colors.primaryGreen.cgColor
            layer.borderWidth = 2
            radioButton.layer.borderColor = Constants.Colors.primaryGreen.cgColor
            radioButtonFill.isHidden = false
        } else {
            layer.borderColor = UIColor.systemGray4.cgColor
            layer.borderWidth = 1
            radioButton.layer.borderColor = UIColor.systemGray4.cgColor
            radioButtonFill.isHidden = true
        }
    }

    func updateTimeLabel(_ text: String) {
        timeLabel.text = text
        timeLabel.isHidden = false
    }
}
