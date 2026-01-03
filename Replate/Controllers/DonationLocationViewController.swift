//
//  DonationLocationViewController.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit
import MapKit
import CoreLocation

class DonationLocationViewController: UIViewController {

    // MARK: - Properties
    var donation: Donation!
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    // MARK: - IBOutlets
    @IBOutlet weak var progressBar: DonationProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationSelectionView: LocationSelectionView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var specialInstructionsTextView: UITextView!

    private let instructionsPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "e.g., Ring the bell twice, Use side entrance"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup progress bar
        progressBar.setProgress(step: 3, totalSteps: 4)

        // Setup location manager
        setupLocationManager()

        // Setup text view
        setupTextView()

        // Setup text field
        addressTextField.delegate = self
        addressTextField.isUserInteractionEnabled = true
        addressTextField.isEnabled = true

        // Bring text field to front to ensure it's not blocked
        addressTextField.superview?.bringSubviewToFront(addressTextField)

        // Setup actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        hideKeyboardWhenTappedAround()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugTextFieldSetup()

        // Ensure text field and text view are interactive and on top
        view.bringSubviewToFront(scrollView)
        scrollView.bringSubviewToFront(addressTextField)
        scrollView.bringSubviewToFront(specialInstructionsTextView)
    }

    // MARK: - Setup
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func setupTextView() {
        specialInstructionsTextView.delegate = self
        specialInstructionsTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)

        // Add placeholder label programmatically
        specialInstructionsTextView.addSubview(instructionsPlaceholderLabel)
        NSLayoutConstraint.activate([
            instructionsPlaceholderLabel.topAnchor.constraint(equalTo: specialInstructionsTextView.topAnchor, constant: 12),
            instructionsPlaceholderLabel.leadingAnchor.constraint(equalTo: specialInstructionsTextView.leadingAnchor, constant: 12),
            instructionsPlaceholderLabel.trailingAnchor.constraint(equalTo: specialInstructionsTextView.trailingAnchor, constant: -12)
        ])

        instructionsPlaceholderLabel.isHidden = !specialInstructionsTextView.text.isEmpty
    }

    private func debugTextFieldSetup() {
        print("DEBUG: addressTextField properties:")
        print("  - isUserInteractionEnabled: \(addressTextField.isUserInteractionEnabled)")
        print("  - isEnabled: \(addressTextField.isEnabled)")
        print("  - isHidden: \(addressTextField.isHidden)")
        print("  - alpha: \(addressTextField.alpha)")
        print("  - frame: \(addressTextField.frame)")

        // Check if there's a view blocking it
        if let hitView = addressTextField.superview?.hitTest(addressTextField.center, with: nil) {
            print("  - Hit test result: \(type(of: hitView))")
        }
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func nextButtonTapped() {
        print("DEBUG: LocationVC - Next button tapped")

        // Validate location
        guard let addressText = addressTextField.text, !addressText.isEmpty else {
            showAlert(title: "Missing Location", message: "Please enter a pickup location")
            return
        }

        print("DEBUG: LocationVC - Address entered: \(addressText)")

        // Update donation object
        donation.location.address = addressText
        donation.pickupTime = .asap // Default to ASAP
        donation.specialInstructions = specialInstructionsTextView.text.isEmpty ? nil : specialInstructionsTextView.text

        print("DEBUG: LocationVC - Donation updated with location info")
        print("DEBUG: LocationVC - Full donation state:")
        print("  - Category: \(donation.category.rawValue)")
        print("  - Item: \(donation.itemName)")
        print("  - Quantity: \(donation.quantity)")
        print("  - Description: \(donation.description)")
        print("  - Location: \(donation.location.address)")
        print("  - Donor ID: \(donation.donorId)")

        // Navigate to review screen via segue
        print("DEBUG: LocationVC - Performing segue to showDonationReview")
        performSegue(withIdentifier: "showDonationReview", sender: self)
    }

    private func updateMapLocation(_ location: CLLocation) {
        locationSelectionView.updateLocation(location)
        currentLocation = location
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("DEBUG: LocationVC - prepare(for segue) called")
        print("DEBUG: LocationVC - Segue identifier: \(segue.identifier ?? "nil")")
        print("DEBUG: LocationVC - Destination VC type: \(type(of: segue.destination))")

        if segue.identifier == "showDonationReview" {
            if let reviewVC = segue.destination as? DonationReviewViewController {
                print("DEBUG: LocationVC - Passing donation to ReviewVC")
                print("DEBUG: LocationVC - Donation before passing:")
                print("  - Category: \(donation.category.rawValue)")
                print("  - Item: \(donation.itemName)")
                print("  - Location: \(donation.location.address)")
                reviewVC.donation = donation
                print("DEBUG: LocationVC - ✅ Donation passed successfully")
            } else {
                print("DEBUG: LocationVC - ❌ Could not cast destination to DonationReviewViewController")
            }
        } else {
            print("DEBUG: LocationVC - ❌ Segue identifier '\(segue.identifier ?? "nil")' does not match 'showDonationReview'")
        }
    }

    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension DonationLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        updateMapLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Location Error", message: "Unable to get your current location. Please enter the address manually.")
    }
}

// MARK: - UITextFieldDelegate
extension DonationLocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("DEBUG: Text field began editing")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension DonationLocationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        instructionsPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}
