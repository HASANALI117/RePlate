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

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(Constants.Colors.primaryGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Where & When to Pickup?"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 12
        map.clipsToBounds = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    private let locationPinView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryGreen
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let pinIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let useCurrentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let locationIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.circle.fill")
        imageView.tintColor = Constants.Colors.primaryGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let useCurrentLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "Use Current Location"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let manualAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "or enter address manually"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "123 Main Street, San Francisco, CA 94102"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let pickupTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Pickup Time"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let asapButton: PickupTimeButton = {
        let button = PickupTimeButton(type: .asap)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let scheduleButton: PickupTimeButton = {
        let button = PickupTimeButton(type: .scheduled)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let specialInstructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Special Instructions"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let specialInstructionsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.systemGray6
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let instructionsPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "e.g., Ring the bell twice, Use side entrance"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var selectedPickupTime: Donation.PickupTime = .asap
    private let datePicker = UIDatePicker()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupLocationManager()
        setupDatePicker()
        setupTextView()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(mapView)
        mapView.addSubview(locationPinView)
        locationPinView.addSubview(pinIconView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(useCurrentLocationButton)
        useCurrentLocationButton.addSubview(locationIconView)
        useCurrentLocationButton.addSubview(useCurrentLocationLabel)
        contentView.addSubview(manualAddressLabel)
        contentView.addSubview(addressTextField)
        contentView.addSubview(pickupTimeLabel)
        contentView.addSubview(asapButton)
        contentView.addSubview(scheduleButton)
        contentView.addSubview(specialInstructionsLabel)
        contentView.addSubview(specialInstructionsTextView)
        specialInstructionsTextView.addSubview(instructionsPlaceholderLabel)

        // Setup progress bar
        progressBar.setProgress(step: 3, totalSteps: 4)

        // Select ASAP by default
        asapButton.isSelected = true

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

            // Next button
            nextButton.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Scroll view
            scrollView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

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

            // Map view
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            mapView.heightAnchor.constraint(equalToConstant: 200),

            // Location pin
            locationPinView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            locationPinView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            locationPinView.widthAnchor.constraint(equalToConstant: 60),
            locationPinView.heightAnchor.constraint(equalToConstant: 60),

            // Pin icon
            pinIconView.centerXAnchor.constraint(equalTo: locationPinView.centerXAnchor),
            pinIconView.centerYAnchor.constraint(equalTo: locationPinView.centerYAnchor),
            pinIconView.widthAnchor.constraint(equalToConstant: 30),
            pinIconView.heightAnchor.constraint(equalToConstant: 30),

            // Location label
            locationLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 24),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            // Use current location button
            useCurrentLocationButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            useCurrentLocationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            useCurrentLocationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            useCurrentLocationButton.heightAnchor.constraint(equalToConstant: 50),

            // Location icon
            locationIconView.leadingAnchor.constraint(equalTo: useCurrentLocationButton.leadingAnchor, constant: 12),
            locationIconView.centerYAnchor.constraint(equalTo: useCurrentLocationButton.centerYAnchor),
            locationIconView.widthAnchor.constraint(equalToConstant: 24),
            locationIconView.heightAnchor.constraint(equalToConstant: 24),

            // Use current location label
            useCurrentLocationLabel.leadingAnchor.constraint(equalTo: locationIconView.trailingAnchor, constant: 12),
            useCurrentLocationLabel.centerYAnchor.constraint(equalTo: useCurrentLocationButton.centerYAnchor),

            // Manual address label
            manualAddressLabel.topAnchor.constraint(equalTo: useCurrentLocationButton.bottomAnchor, constant: 16),
            manualAddressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Address text field
            addressTextField.topAnchor.constraint(equalTo: manualAddressLabel.bottomAnchor, constant: 12),
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),

            // Pickup time label
            pickupTimeLabel.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 24),
            pickupTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            // ASAP button
            asapButton.topAnchor.constraint(equalTo: pickupTimeLabel.bottomAnchor, constant: 12),
            asapButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            asapButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            asapButton.heightAnchor.constraint(equalToConstant: 50),

            // Schedule button
            scheduleButton.topAnchor.constraint(equalTo: asapButton.bottomAnchor, constant: 12),
            scheduleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            scheduleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            scheduleButton.heightAnchor.constraint(equalToConstant: 50),

            // Special instructions label
            specialInstructionsLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 24),
            specialInstructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            // Special instructions text view
            specialInstructionsTextView.topAnchor.constraint(equalTo: specialInstructionsLabel.bottomAnchor, constant: 8),
            specialInstructionsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            specialInstructionsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            specialInstructionsTextView.heightAnchor.constraint(equalToConstant: 80),
            specialInstructionsTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),

            // Instructions placeholder
            instructionsPlaceholderLabel.topAnchor.constraint(equalTo: specialInstructionsTextView.topAnchor, constant: 12),
            instructionsPlaceholderLabel.leadingAnchor.constraint(equalTo: specialInstructionsTextView.leadingAnchor, constant: 12),
            instructionsPlaceholderLabel.trailingAnchor.constraint(equalTo: specialInstructionsTextView.trailingAnchor, constant: -12)
        ])
    }

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
        instructionsPlaceholderLabel.isHidden = !specialInstructionsTextView.text.isEmpty
    }

    // MARK: - Actions
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        useCurrentLocationButton.addTarget(self, action: #selector(useCurrentLocationTapped), for: .touchUpInside)
        asapButton.addTarget(self, action: #selector(asapButtonTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func useCurrentLocationTapped() {
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
        if !addressTextField.text!.isEmpty {
            address = addressTextField.text!
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

        // Navigate to review screen
        let reviewVC = DonationReviewViewController()
        reviewVC.donation = donation
        navigationController?.pushViewController(reviewVC, animated: true)
    }

    private func updateMapLocation(_ location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        currentLocation = location
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

// MARK: - Pickup Time Button
class PickupTimeButton: UIButton {
    enum ButtonType {
        case asap
        case scheduled
    }

    let btnType: ButtonType
    private let iconView: UIImageView
    private let titleTextLabel: UILabel
    private let timeLabel: UILabel
    private let radioButton: UIView
    private let radioButtonFill: UIView

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    init(type: ButtonType) {
        self.btnType = type
        self.iconView = UIImageView()
        self.titleTextLabel = UILabel()
        self.timeLabel = UILabel()
        self.radioButton = UIView()
        self.radioButtonFill = UIView()
        super.init(frame: .zero)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor

        // Radio button
        radioButton.backgroundColor = .white
        radioButton.layer.cornerRadius = 10
        radioButton.layer.borderWidth = 2
        radioButton.layer.borderColor = UIColor.systemGray4.cgColor
        radioButton.translatesAutoresizingMaskIntoConstraints = false

        radioButtonFill.backgroundColor = Constants.Colors.primaryGreen
        radioButtonFill.layer.cornerRadius = 6
        radioButtonFill.isHidden = true
        radioButtonFill.translatesAutoresizingMaskIntoConstraints = false

        // Icon
        iconView.image = UIImage(systemName: btnType == .asap ? "clock.fill" : "calendar")
        iconView.tintColor = Constants.Colors.primaryGreen
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // Title
        titleTextLabel.text = btnType == .asap ? "As soon as possible" : "Schedule a time"
        titleTextLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleTextLabel.textColor = .black
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false

        // Time label (for scheduled)
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = .systemGray
        timeLabel.isHidden = btnType == .asap
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(radioButton)
        radioButton.addSubview(radioButtonFill)
        addSubview(iconView)
        addSubview(titleTextLabel)
        if btnType == .scheduled {
            addSubview(timeLabel)
        }

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 20),
            radioButton.heightAnchor.constraint(equalToConstant: 20),

            radioButtonFill.centerXAnchor.constraint(equalTo: radioButton.centerXAnchor),
            radioButtonFill.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor),
            radioButtonFill.widthAnchor.constraint(equalToConstant: 12),
            radioButtonFill.heightAnchor.constraint(equalToConstant: 12),

            iconView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),

            titleTextLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        if btnType == .scheduled {
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 2),
                timeLabel.leadingAnchor.constraint(equalTo: titleTextLabel.leadingAnchor)
            ])
        }

        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            layer.borderColor = Constants.Colors.primaryGreen.cgColor
            layer.borderWidth = 2
            radioButton.layer.borderColor = Constants.Colors.primaryGreen.cgColor
            radioButtonFill.isHidden = false
        } else {
            layer.borderColor = UIColor.systemGray4.cgColor
            layer.borderWidth = 1
            radioButton.layer.borderColor = UIColor.systemGray4.cgColor
            radioButtonFill.isHidden = true
        }
    }

    func updateTimeLabel(_ text: String) {
        timeLabel.text = text
        timeLabel.isHidden = false
    }
}
