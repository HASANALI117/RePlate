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

    // MARK: - IBOutlets
    @IBOutlet weak var progressBar: DonationProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var foodInfoCard: ReviewCard!
    @IBOutlet weak var detailsCard: ReviewCard!
    @IBOutlet weak var pickupInfoCard: ReviewCard!
    @IBOutlet weak var postDonationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup progress bar
        progressBar.setProgress(step: 4, totalSteps: 4)

        // Populate review data
        populateReviewData()

        // Setup actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        postDonationButton.addTarget(self, action: #selector(postDonationButtonTapped), for: .touchUpInside)
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

    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
