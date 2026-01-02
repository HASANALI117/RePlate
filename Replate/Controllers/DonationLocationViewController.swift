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

        // Setup location selection view
        locationSelectionView.onUseCurrentLocation = { [weak self] in
            self?.useCurrentLocationTapped()
        }

        // Setup location manager
        setupLocationManager()

        // Setup text view
        setupTextView()

        // Setup actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        hideKeyboardWhenTappedAround()
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

    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func useCurrentLocationTapped() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @objc private func nextButtonTapped() {
        // Validate location
        var address = ""
        if let addressText = locationSelectionView.getAddressText(), !addressText.isEmpty {
            address = addressText
        } else if let location = currentLocation {
            // Reverse geocode if using current location
            address = "Current Location"
            donation.location.latitude = location.coordinate.latitude
            donation.location.longitude = location.coordinate.longitude
            donation.location.useCurrentLocation = true
        } else {
            showAlert(title: "Missing Location", message: "Please select or enter a location")
            return
        }

        // Update donation object
        donation.location.address = address
        donation.pickupTime = .asap // Default to ASAP
        donation.specialInstructions = specialInstructionsTextView.text.isEmpty ? nil : specialInstructionsTextView.text

        // Navigate to review screen via segue
        performSegue(withIdentifier: "showDonationReview", sender: self)
    }

    private func updateMapLocation(_ location: CLLocation) {
        locationSelectionView.updateLocation(location)
        currentLocation = location
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDonationReview",
           let reviewVC = segue.destination as? DonationReviewViewController {
            reviewVC.donation = donation
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

// MARK: - UITextViewDelegate
extension DonationLocationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        instructionsPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}
