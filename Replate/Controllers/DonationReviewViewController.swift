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
