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
    private var selectedPickupTime: Donation.PickupTime = .asap

    // MARK: - IBOutlets
    @IBOutlet weak var progressBar: DonationProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationSelectionView: LocationSelectionView!
    @IBOutlet weak var asapButton: PickupTimeButton!
    @IBOutlet weak var scheduleButton: PickupTimeButton!
    @IBOutlet weak var specialInstructionsTextView: UITextView!

    private let instructionsPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "e.g., Ring the bell twice, Use side entrance"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let datePicker = UIDatePicker()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup progress bar
        progressBar.setProgress(step: 3, totalSteps: 4)

        // Select ASAP by default
        asapButton.isSelected = true

        // Setup location selection view
        locationSelectionView.onUseCurrentLocation = { [weak self] in
            self?.useCurrentLocationTapped()
        }

        // Setup location manager
        setupLocationManager()

        // Setup date picker
        setupDatePicker()

        // Setup text view
        setupTextView()

        // Setup actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        asapButton.addTarget(self, action: #selector(asapButtonTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)

        hideKeyboardWhenTappedAround()
    }

    // MARK: - Setup
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
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

    @objc private func asapButtonTapped() {
        asapButton.isSelected = true
        scheduleButton.isSelected = false
        selectedPickupTime = .asap
    }

    @objc private func scheduleButtonTapped() {
        asapButton.isSelected = false
        scheduleButton.isSelected = true

        // Show date picker
        let alert = UIAlertController(title: "Schedule Pickup Time", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)

        datePicker.frame = CGRect(x: 0, y: 50, width: alert.view.frame.width - 20, height: 200)
        alert.view.addSubview(datePicker)

        alert.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.selectedPickupTime = .scheduled(self.datePicker.date)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            self.scheduleButton.updateTimeLabel(formatter.string(from: self.datePicker.date))
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.asapButton.isSelected = true
            self?.scheduleButton.isSelected = false
            self?.selectedPickupTime = .asap
        })

        // For iPad
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = scheduleButton
            popoverController.sourceRect = scheduleButton.bounds
        }

        present(alert, animated: true)
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
        donation.pickupTime = selectedPickupTime
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
