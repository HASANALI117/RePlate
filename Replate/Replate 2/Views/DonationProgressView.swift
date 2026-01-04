//
//  DonationProgressView.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

@IBDesignable
class DonationProgressView: UIView {
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }

    // MARK: - Inspectable Properties
    @IBInspectable var currentStep: Int = 1 {
        didSet { updateProgress() }
    }

    @IBInspectable var totalSteps: Int = 4 {
        didSet { updateProgress() }
    }

    @IBInspectable var progressColor: UIColor = Constants.Colors.primaryGreen {
        didSet { progressBarFill.backgroundColor = progressColor }
    }

    // MARK: - UI Components
    private let progressBarBackground = UIView()
    private let progressBarFill = UIView()
    private let stepLabel = UILabel()

    private var progressWidthConstraint: NSLayoutConstraint?
    private var didSetupView = false

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        currentStep = 1
        totalSteps = 4
        updateProgress()
    }

    // MARK: - Setup
    private func commonInit() {
        guard !didSetupView else { return }
        didSetupView = true

        backgroundColor = .clear

        // Background bar
        progressBarBackground.backgroundColor = .systemGray5
        progressBarBackground.layer.cornerRadius = 2
        progressBarBackground.translatesAutoresizingMaskIntoConstraints = false

        // Fill bar
        progressBarFill.backgroundColor = progressColor
        progressBarFill.layer.cornerRadius = 2
        progressBarFill.translatesAutoresizingMaskIntoConstraints = false

        // Label
        stepLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stepLabel.textColor = .systemGray
        stepLabel.textAlignment = .center
        stepLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stepLabel)
        addSubview(progressBarBackground)
        progressBarBackground.addSubview(progressBarFill)

        NSLayoutConstraint.activate([
            stepLabel.topAnchor.constraint(equalTo: topAnchor),
            stepLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            progressBarBackground.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 8),
            progressBarBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBarBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBarBackground.heightAnchor.constraint(equalToConstant: 4),
            progressBarBackground.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressBarFill.leadingAnchor.constraint(equalTo: progressBarBackground.leadingAnchor),
            progressBarFill.topAnchor.constraint(equalTo: progressBarBackground.topAnchor),
            progressBarFill.bottomAnchor.constraint(equalTo: progressBarBackground.bottomAnchor)
        ])

        progressWidthConstraint = progressBarFill.widthAnchor.constraint(equalTo: progressBarBackground.widthAnchor, multiplier: 0.25)
        progressWidthConstraint?.isActive = true

        updateProgress()
    }

    // MARK: - Progress
    private func updateProgress() {
        stepLabel.text = "Step \(currentStep) of \(totalSteps)"

        let progress = CGFloat(currentStep) / CGFloat(max(totalSteps, 1))
        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressBarFill.widthAnchor.constraint(
            equalTo: progressBarBackground.widthAnchor,
            multiplier: min(max(progress, 0), 1)
        )
        progressWidthConstraint?.isActive = true

        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Public API
    func setProgress(step: Int, totalSteps: Int) {
        self.currentStep = step
        self.totalSteps = totalSteps
    }
}
