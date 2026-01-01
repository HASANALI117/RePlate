//
//  DonationProgressView.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

@IBDesignable
class DonationProgressView: UIView {
    
    // MARK: - Inspectable Properties
    @IBInspectable var currentStep: Int = 1 {
        didSet {
            updateProgress()
        }
    }
    
    @IBInspectable var totalSteps: Int = 4 {
        didSet {
            updateProgress()
        }
    }
    
    @IBInspectable var progressColor: UIColor = Constants.Colors.primaryGreen {
        didSet {
            progressBarFill.backgroundColor = progressColor
        }
    }
    
    // MARK: - UI Components
    private let progressBarBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let progressBarFill: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryGreen
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var progressWidthConstraint: NSLayoutConstraint!

    // MARK: - Initialization
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
        updateProgress()
    }

    // MARK: - Setup
    private func setupView() {
        addSubview(progressBarBackground)
        progressBarBackground.addSubview(progressBarFill)
        addSubview(stepLabel)

        progressWidthConstraint = progressBarFill.widthAnchor.constraint(equalTo: progressBarBackground.widthAnchor, multiplier: 0.25)

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
            progressBarFill.bottomAnchor.constraint(equalTo: progressBarBackground.bottomAnchor),
            progressWidthConstraint
        ])
        
        updateProgress()
    }

    // MARK: - Public Methods
    func setProgress(step: Int, totalSteps: Int) {
        self.currentStep = step
        self.totalSteps = totalSteps
    }
    
    // MARK: - Private Methods
    private func updateProgress() {
        stepLabel.text = "Step \(currentStep) of \(totalSteps)"
        let progress = CGFloat(currentStep) / CGFloat(totalSteps)
        progressWidthConstraint?.isActive = false
        progressWidthConstraint = progressBarFill.widthAnchor.constraint(equalTo: progressBarBackground.widthAnchor, multiplier: max(0, min(1, progress)))
        progressWidthConstraint?.isActive = true

        UIView.animate(withDuration: Constants.Animation.medium) {
            self.layoutIfNeeded()
        }
    }
}
