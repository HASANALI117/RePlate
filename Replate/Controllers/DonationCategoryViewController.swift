//
//  DonationCategoryViewController.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

class DonationCategoryViewController: UIViewController {

    // MARK: - Properties
    var donation: Donation!
    var selectedCategory: Donation.DonationCategory = .freshProduce
    var selectedUnit: Donation.QuantityUnit = .plates

    // MARK: - IBOutlets
    @IBOutlet weak var progressBar: DonationProgressView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var categoryStackView: UIStackView! // Add CategoryBtn instances in storyboard
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    // Keep a reference to all CategoryBtn instances for selection logic
    private var categoryButtons: [CategoryBtn] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize donation if needed
        if donation == nil {
            let mockUserId = "MOCK_USER_\(UUID().uuidString.prefix(8))"
            donation = Donation(donorId: mockUserId)
        }

        // Setup progress bar
        progressBar.setProgress(step: 1, totalSteps: 4)

        // Setup category buttons references
        categoryButtons = categoryStackView.arrangedSubviews.compactMap { $0 as? CategoryBtn }

        // Map category buttons to their respective categories based on their text
        for button in categoryButtons {
            if button.categoryName == "Fresh Produce" {
                button.category = .freshProduce
            } else if button.categoryName == "Cooked Meals" {
                button.category = .cookedMeals
            } else if button.categoryName == "Packaged Goods" {
                button.category = .packagedGoods
            }
        }

        // Select first category by default
        categoryButtons.first?.isSelected = true
        selectedCategory = categoryButtons.first?.category ?? .freshProduce
        updateDefaultUnit()

        print("DEBUG: Found \(categoryButtons.count) category buttons")

        // Setup button actions
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        unitButton.addTarget(self, action: #selector(unitButtonTapped), for: .touchUpInside)

        hideKeyboardWhenTappedAround()
    }

    // MARK: - Category Button Action
    @IBAction func categoryButtonTapped(_ sender: CategoryBtn) {
        // Deselect all buttons
        categoryButtons.forEach { $0.isSelected = false }

        // Select tapped button
        sender.isSelected = true
        selectedCategory = sender.category

        // Update unit button
        updateDefaultUnit()
    }

    private func updateDefaultUnit() {
        switch selectedCategory {
        case .freshProduce:
            selectedUnit = .bags
            unitButton.setTitle("Bags", for: .normal)
        case .cookedMeals:
            selectedUnit = .plates
            unitButton.setTitle("Plates", for: .normal)
        case .packagedGoods:
            selectedUnit = .boxes
            unitButton.setTitle("Boxes", for: .normal)
        }
    }

    // MARK: - Other Actions
    @objc private func closeButtonTapped() {
        let alert = UIAlertController(title: "Discard Donation?", message: "Are you sure you want to cancel? Your progress will be lost.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue Editing", style: .cancel))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    @objc private func unitButtonTapped() {
        let actionSheet = UIAlertController(title: "Select Unit", message: nil, preferredStyle: .actionSheet)
        let units: [Donation.QuantityUnit] = [.bags, .plates, .boxes, .items, .servings]
        for unit in units {
            actionSheet.addAction(UIAlertAction(title: unit.rawValue, style: .default) { [weak self] _ in
                self?.selectedUnit = unit
                self?.unitButton.setTitle(unit.rawValue, for: .normal)
            })
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = unitButton
            popover.sourceRect = unitButton.bounds
        }

        present(actionSheet, animated: true)
    }

    @objc private func nextButtonTapped() {
        guard let itemName = itemNameTextField.text, !itemName.isEmpty else {
            showAlert(title: "Missing Information", message: "Please enter an item name")
            return
        }

        guard let quantityText = quantityTextField.text,
              let quantity = Int(quantityText), quantity > 0 else {
            showAlert(title: "Invalid Quantity", message: "Please enter a valid quantity")
            return
        }

        // Update donation object
        donation.category = selectedCategory
        donation.itemName = itemName
        donation.quantity = quantity
        donation.quantityUnit = selectedUnit

        // Navigate to next screen via segue
        performSegue(withIdentifier: "showDonationDetails", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDonationDetails",
           let detailsVC = segue.destination as? DonationDetailsViewController {
            detailsVC.donation = donation
        }
    }

    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
