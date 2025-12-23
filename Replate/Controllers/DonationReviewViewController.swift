//
//  DonationReviewViewController.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

class DonationReviewViewController: UIViewController {

    // MARK: - Properties
    var donation: Donation!

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let progressBar: DonationProgressView = {
        let view = DonationProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = Constants.Colors.primaryGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Review Your Donation"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let foodInfoCard: ReviewCard = {
        let card = ReviewCard(title: "Food Information")
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private let detailsCard: ReviewCard = {
        let card = ReviewCard(title: "Details")
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private let pickupInfoCard: ReviewCard = {
        let card = ReviewCard(title: "Pickup Information")
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private let postDonationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post Donation", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryGreen
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        populateReviewData()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(foodInfoCard)
        contentView.addSubview(detailsCard)
        contentView.addSubview(pickupInfoCard)

        view.addSubview(postDonationButton)
        view.addSubview(activityIndicator)

        // Setup progress bar
        progressBar.setProgress(step: 4, totalSteps: 4)

        // Layout
        NSLayoutConstraint.activate([
            // Progress bar
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 30),

            // Back button
            backButton.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            // Scroll view
            scrollView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: postDonationButton.topAnchor, constant: -16),

            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),

            // Food Info Card
            foodInfoCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            foodInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            foodInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),

            // Details Card
            detailsCard.topAnchor.constraint(equalTo: foodInfoCard.bottomAnchor, constant: 16),
            detailsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            detailsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),

            // Pickup Info Card
            pickupInfoCard.topAnchor.constraint(equalTo: detailsCard.bottomAnchor, constant: 16),
            pickupInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            pickupInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            pickupInfoCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            // Post Donation Button
            postDonationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            postDonationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            postDonationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            postDonationButton.heightAnchor.constraint(equalToConstant: 52),

            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: postDonationButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: postDonationButton.centerYAnchor)
        ])
    }

    private func populateReviewData() {
        // Food Information
        foodInfoCard.addRow(icon: "leaf.circle.fill", iconColor: Constants.Colors.primaryGreen, label: "Category", value: donation.category.rawValue)
        foodInfoCard.addRow(icon: "text.quote", iconColor: .systemGray, label: "Item Name", value: donation.itemName)
        foodInfoCard.addRow(icon: "number", iconColor: .systemGray, label: "Quantity", value: "\(donation.quantity) \(donation.quantityUnit.rawValue)")

        // Details
        detailsCard.addRow(icon: "text.alignleft", iconColor: .systemGray, label: "Description", value: donation.description)

        if let expiryDate = donation.expiryDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            detailsCard.addRow(icon: "calendar", iconColor: .systemGray, label: "Expires", value: formatter.string(from: expiryDate))
        }

        if !donation.allergens.isEmpty {
            let allergenText = donation.allergens.map { $0.displayName }.joined(separator: ", ")
            detailsCard.addRow(icon: "exclamationmark.triangle.fill", iconColor: .systemOrange, label: "Allergen Info", value: allergenText)
        }

        // Pickup Information
        pickupInfoCard.addRow(icon: "mappin.circle.fill", iconColor: Constants.Colors.primaryGreen, label: "Location", value: donation.location.address)
        pickupInfoCard.addRow(icon: "clock.fill", iconColor: .systemGray, label: "Pickup Time", value: donation.pickupTime.displayText)

        if let instructions = donation.specialInstructions, !instructions.isEmpty {
            pickupInfoCard.addRow(icon: "info.circle.fill", iconColor: .systemGray, label: "Instructions", value: instructions)
        }
    }

    // MARK: - Actions
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        postDonationButton.addTarget(self, action: #selector(postDonationButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func postDonationButtonTapped() {
        postDonationButton.isEnabled = false
        postDonationButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()

        // Update status to available
        donation.status = .available

        // Save to Firestore using DonationService
        DonationService.shared.createDonation(donation) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.postDonationButton.isEnabled = true
                self.postDonationButton.setTitle("Post Donation", for: .normal)

                switch result {
                case .success(let savedDonation):
                    self.donation = savedDonation
                    self.showSuccessAndDismiss()
                case .failure(let error):
                    self.showAlert(title: "Error", message: "Failed to post donation: \(error.localizedDescription)")
                }
            }
        }
    }

    private func showSuccessAndDismiss() {
        let successVC = SuccessViewController(
            title: "Donation Posted!",
            message: "Your donation is now live and available for pickup"
        ) { [weak self] in
            // Dismiss the entire navigation flow
            self?.navigationController?.dismiss(animated: true)
        }
        present(successVC, animated: true)
    }
}

// MARK: - Review Card
class ReviewCard: UIView {
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

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor

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
