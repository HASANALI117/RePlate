//
//  LocationSelectionView.swift
//  Replate
//
//  Created on 2026-01-02.
//

import UIKit
import MapKit
import CoreLocation

@IBDesignable
class LocationSelectionView: UIView {

    // MARK: - Properties
    var onUseCurrentLocation: (() -> Void)?
    var currentLocation: CLLocation? {
        didSet {
            updateMapLocation()
        }
    }

    // MARK: - UI Components
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 12
        map.clipsToBounds = true
        map.isUserInteractionEnabled = false
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

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear

        // Add subviews
        addSubview(mapView)
        mapView.addSubview(locationPinView)
        locationPinView.addSubview(pinIconView)
        addSubview(useCurrentLocationButton)
        useCurrentLocationButton.addSubview(locationIconView)
        useCurrentLocationButton.addSubview(useCurrentLocationLabel)
        addSubview(manualAddressLabel)
        addSubview(addressTextField)

        // Setup button action
        useCurrentLocationButton.addTarget(self, action: #selector(handleUseCurrentLocation), for: .touchUpInside)

        // Layout
        NSLayoutConstraint.activate([
            // Map view
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
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

            // Use current location button
            useCurrentLocationButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 24),
            useCurrentLocationButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            useCurrentLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor),
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
            manualAddressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Address text field
            addressTextField.topAnchor.constraint(equalTo: manualAddressLabel.bottomAnchor, constant: 12),
            addressTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),
            addressTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func handleUseCurrentLocation() {
        onUseCurrentLocation?()
    }

    // MARK: - Public Methods
    func updateLocation(_ location: CLLocation) {
        currentLocation = location
    }

    func getAddressText() -> String? {
        return addressTextField.text
    }

    func setAddressText(_ text: String) {
        addressTextField.text = text
    }

    func getAddressTextField() -> UITextField {
        return addressTextField
    }

    private func updateMapLocation() {
        guard let location = currentLocation else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Interface Builder Support
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
    }
}
