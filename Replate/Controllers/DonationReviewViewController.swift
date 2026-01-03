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

        // Debug: Check if button outlet is connected
        if postDonationButton == nil {
            print("DEBUG: ❌ POST DONATION BUTTON OUTLET IS NOT CONNECTED!")
        } else {
            print("DEBUG: ✅ Post donation button outlet is connected")
        }

        // Setup progress bar
        progressBar.setProgress(step: 4, totalSteps: 4)

        // Populate review data
        populateReviewData()

        // Setup actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        if postDonationButton != nil {
            postDonationButton.addTarget(self, action: #selector(postDonationButtonTapped), for: .touchUpInside)

            // Ensure button is visible and on top
            postDonationButton.isHidden = false
            postDonationButton.alpha = 1.0
            view.bringSubviewToFront(postDonationButton)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("DEBUG: Post donation button frame: \(postDonationButton.frame)")
        print("DEBUG: Post donation button isHidden: \(postDonationButton.isHidden)")
        print("DEBUG: Post donation button alpha: \(postDonationButton.alpha)")
        print("DEBUG: View bounds: \(view.bounds)")
        print("DEBUG: ScrollView frame: \(scrollView.frame)")
        print("DEBUG: ScrollView contentSize: \(scrollView.contentSize)")

        // Check button's superview
        if let superview = postDonationButton.superview {
            print("DEBUG: Button superview type: \(type(of: superview))")
            print("DEBUG: Button superview frame: \(superview.frame)")
        }

        // Ensure scroll view has correct content size to show the button
        scrollView.layoutIfNeeded()

        // Calculate required content height
        let buttonMaxY = postDonationButton.frame.maxY + 20 // Add padding
        if scrollView.contentSize.height < buttonMaxY {
            print("DEBUG: Adjusting scroll view content size from \(scrollView.contentSize.height) to \(buttonMaxY)")
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: buttonMaxY)
        }
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
        print("DEBUG: Post donation button tapped!")
        print("DEBUG: Donation data - Category: \(donation.category.rawValue), Item: \(donation.itemName)")

        postDonationButton.isEnabled = false
        postDonationButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()

        // Update status to available
        donation.status = .available

        print("DEBUG: Calling Firebase to save donation...")

        // Save to Firestore using DonationService
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

        // Dismiss the entire donation flow (modal presentation)
        navigationController?.dismiss(animated: true) {
            // After dismissing, navigate to browse donations page
            // Find the root view controller
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                print("DEBUG: Could not find root view controller")
                return
            }

            print("DEBUG: Root VC type: \(type(of: rootViewController))")

            // Create the browse donations view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let browseDonationsVC = storyboard.instantiateViewController(withIdentifier: "BrowseDonationsViewController") as? BrowseDonationsViewController {

                // Navigate based on the root view controller type
                if let tabBarController = rootViewController as? UITabBarController {
                    // If root is a tab bar, get the selected navigation controller
                    if let navController = tabBarController.selectedViewController as? UINavigationController {
                        navController.pushViewController(browseDonationsVC, animated: true)
                        print("DEBUG: Pushed to tab bar's nav controller")
                    } else {
                        // Selected tab is not a nav controller, wrap browse VC in one
                        let nav = UINavigationController(rootViewController: browseDonationsVC)
                        tabBarController.present(nav, animated: true)
                        print("DEBUG: Presented modally from tab bar")
                    }
                } else if let navController = rootViewController as? UINavigationController {
                    // Root is a navigation controller
                    navController.pushViewController(browseDonationsVC, animated: true)
                    print("DEBUG: Pushed to root nav controller")
                } else {
                    // Root is something else, present modally
                    let nav = UINavigationController(rootViewController: browseDonationsVC)
                    rootViewController.present(nav, animated: true)
                    print("DEBUG: Presented modally from root")
                }
            } else {
                print("DEBUG: Could not instantiate BrowseDonationsViewController")
            }
        }
    }

    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
