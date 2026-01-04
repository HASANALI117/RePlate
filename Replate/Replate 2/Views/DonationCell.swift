//
//  DonationCell.swift
//  Replate
//
//  Created on 2025-12-20.
//

import UIKit

class DonationCell: UITableViewCell {

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let donationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor.systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let distanceIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.circle")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let expiryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let expiryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(donationImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(distanceIcon)
        containerView.addSubview(distanceLabel)
        containerView.addSubview(expiryIcon)
        containerView.addSubview(expiryLabel)

        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Image view
            donationImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            donationImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            donationImageView.widthAnchor.constraint(equalToConstant: 70),
            donationImageView.heightAnchor.constraint(equalToConstant: 70),

            // Title label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: donationImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            // Distance icon
            distanceIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            distanceIcon.leadingAnchor.constraint(equalTo: donationImageView.trailingAnchor, constant: 12),
            distanceIcon.widthAnchor.constraint(equalToConstant: 14),
            distanceIcon.heightAnchor.constraint(equalToConstant: 14),

            // Distance label
            distanceLabel.centerYAnchor.constraint(equalTo: distanceIcon.centerYAnchor),
            distanceLabel.leadingAnchor.constraint(equalTo: distanceIcon.trailingAnchor, constant: 4),

            // Expiry icon
            expiryIcon.topAnchor.constraint(equalTo: distanceIcon.bottomAnchor, constant: 6),
            expiryIcon.leadingAnchor.constraint(equalTo: donationImageView.trailingAnchor, constant: 12),
            expiryIcon.widthAnchor.constraint(equalToConstant: 14),
            expiryIcon.heightAnchor.constraint(equalToConstant: 14),

            // Expiry label
            expiryLabel.centerYAnchor.constraint(equalTo: expiryIcon.centerYAnchor),
            expiryLabel.leadingAnchor.constraint(equalTo: expiryIcon.trailingAnchor, constant: 4)
        ])
    }

    // MARK: - Configuration
    func configure(with donation: Donation) {
        titleLabel.text = donation.itemName

        // Set distance (placeholder for now)
        // TODO: Calculate actual distance based on user location
        distanceLabel.text = "0.5 mi away"

        // Set expiry
        if let expiryDate = donation.expiryDate {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            expiryLabel.text = "Expires \(formatter.localizedString(for: expiryDate, relativeTo: Date()))"
        } else {
            expiryLabel.text = "No expiry date"
        }

        // Set placeholder image or load from URL
        donationImageView.image = UIImage(systemName: donation.category.icon)
        donationImageView.tintColor = Constants.Colors.primaryGreen
        donationImageView.contentMode = .center

        // TODO: Load actual image from URL if available
        // if let photoURL = donation.photo {
        //     loadImage(from: photoURL)
        // }
    }

    // TODO: Implement image loading from URL
    private func loadImage(from urlString: String) {
        // Implement URLSession image loading or use a library like SDWebImage
    }
}
