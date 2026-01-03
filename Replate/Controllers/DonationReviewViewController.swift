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

    // MARK: - UI Components (Programmatic)
    private let progressBar: DonationProgressView = {
        let view = DonationProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Review Donation"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let foodInfoCard: ReviewCard = {
        let card = ReviewCard(title: "Food Information")
        card.showChevron = false
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private let detailsCard: ReviewCard = {
        let card = ReviewCard(title: "Details")
        card.showChevron = false
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private let pickupInfoCard: ReviewCard = {
        let card = ReviewCard(title: "Pickup Information")
        card.showChevron = false
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private let postDonationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post Donation", for: .normal)
        button.backgroundColor = Constants.Colors.primaryGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // Debug: Check if donation was passed
        if donation == nil {
            print("DEBUG: ❌ DONATION IS NIL IN REVIEW VC!")
        } else {
            print("DEBUG: ✅ Donation received in ReviewVC:")
            print("  - Category: \(donation.category.rawValue)")
            print("  - Item Name: \(donation.itemName)")
            print("  - Quantity: \(donation.quantity) \(donation.quantityUnit.rawValue)")
            print("  - Description: \(donation.description)")
            print("  - Location: \(donation.location.address)")
            print("  - Donor ID: \(donation.donorId)")
        }

        setupUI()
        setupConstraints()
        populateReviewData()

        // Setup progress bar
        progressBar.setProgress(step: 4, totalSteps: 4)

        // Setup actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        postDonationButton.addTarget(self, action: #selector(postDonationButtonTapped), for: .touchUpInside)

        print("DEBUG: ✅ Programmatic UI setup complete")
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(backButton)
        view.addSubview(scrollView)
        view.addSubview(postDonationButton)
        postDonationButton.addSubview(activityIndicator)

        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(foodInfoCard)
        contentView.addSubview(detailsCard)
        contentView.addSubview(pickupInfoCard)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Progress bar
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 8),

            // Back button
            backButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            // Scroll view
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: postDonationButton.topAnchor, constant: -16),

            // Content view (inside scroll view)
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Food info card
            foodInfoCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            foodInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            foodInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Details card
            detailsCard.topAnchor.constraint(equalTo: foodInfoCard.bottomAnchor, constant: 16),
            detailsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Pickup info card
            pickupInfoCard.topAnchor.constraint(equalTo: detailsCard.bottomAnchor, constant: 16),
            pickupInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pickupInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            pickupInfoCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            // Post donation button (pinned to bottom of main view)
            postDonationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            postDonationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            postDonationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            postDonationButton.heightAnchor.constraint(equalToConstant: 52),

            // Activity indicator (centered in button)
            activityIndicator.centerXAnchor.constraint(equalTo: postDonationButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: postDonationButton.centerYAnchor)
        ])
    }

    // MARK: - Setup
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
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func postDonationButtonTapped() {
        print("DEBUG: ========================================")
        print("DEBUG: 🎯 POST DONATION BUTTON TAPPED!")
        print("DEBUG: ========================================")
        print("DEBUG: Donation data - Category: \(donation.category.rawValue), Item: \(donation.itemName)")

        postDonationButton.isEnabled = false
        postDonationButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()

        // Update status to available
        donation.status = .available

        print("DEBUG: Calling Firebase to save donation...")

        // Save to Realtime Database using DonationService
        DonationService.shared.createDonation(donation) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.postDonationButton.isEnabled = true
                self.postDonationButton.setTitle("Post Donation", for: .normal)

                switch result {
                case .success(let savedDonation):
                    print("DEBUG: ✅ Donation saved successfully! ID: \(savedDonation.id ?? "unknown")")
                    self.donation = savedDonation
                    self.showSuccessAndDismiss()
                case .failure(let error):
                    print("DEBUG: ❌ Failed to save donation: \(error.localizedDescription)")
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
            guard let self = self else { return }

            // Dismiss the success screen first
            self.dismiss(animated: true) {
                // Then navigate to browse page
                self.navigateToBrowsePage()
            }
        }
        present(successVC, animated: true)
    }

    private func navigateToBrowsePage() {
        print("DEBUG: Navigating to browse page...")
        
        // Create the browse donations view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let browseDonationsVC = storyboard.instantiateViewController(withIdentifier: "BrowseDonationsViewController") as? BrowseDonationsViewController {
            
            // Pop to root and push the browse VC
            if let navController = navigationController {
                // Get all view controllers and keep only the first one (root)
                var viewControllers = navController.viewControllers
                viewControllers = [viewControllers[0], browseDonationsVC]
                navController.setViewControllers(viewControllers, animated: true)
                print("DEBUG: ✅ Navigated to BrowseDonationsViewController")
            } else {
                print("DEBUG: ❌ No navigation controller found")
            }
        } else {
            print("DEBUG: ❌ Could not instantiate BrowseDonationsViewController - check Storyboard ID")
        }
    }

    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
