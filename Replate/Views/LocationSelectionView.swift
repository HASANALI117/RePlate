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
        isUserInteractionEnabled = false  // Disable interaction on the entire view

        // Add subviews
        addSubview(mapView)
        mapView.addSubview(locationPinView)
        locationPinView.addSubview(pinIconView)

        // Layout
        NSLayoutConstraint.activate([
            // Map view fills the entire view
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Location pin centered in map
            locationPinView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            locationPinView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            locationPinView.widthAnchor.constraint(equalToConstant: 60),
            locationPinView.heightAnchor.constraint(equalToConstant: 60),

            // Pin icon centered in pin view
            pinIconView.centerXAnchor.constraint(equalTo: locationPinView.centerXAnchor),
            pinIconView.centerYAnchor.constraint(equalTo: locationPinView.centerYAnchor),
            pinIconView.widthAnchor.constraint(equalToConstant: 30),
            pinIconView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    // MARK: - Public Methods
    func updateLocation(_ location: CLLocation) {
        currentLocation = location
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
