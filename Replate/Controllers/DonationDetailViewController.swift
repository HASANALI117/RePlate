//
//  DonationDetailViewController.swift
//  Replate
//
//  Created on 2025-12-20.
//

import UIKit

class DonationDetailViewController: UIViewController {

    // MARK: - Properties
    var donation: Donation!

    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let donorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusBadge: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let statusIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cube.fill")
        imageView.tintColor = Constants.Colors.primaryGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status: Available"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = Constants.Colors.primaryGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let detailsGridView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let requestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Request to Pickup", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryGreen
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        populateData()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(foodImageView)
        view.addSubview(backButton)
        view.addSubview(favoriteButton)
        view.addSubview(shareButton)

        contentView.addSubview(titleLabel)
        contentView.addSubview(donorLabel)
        contentView.addSubview(ratingView)
        ratingView.addSubview(starImageView)
        ratingView.addSubview(ratingLabel)

        contentView.addSubview(statusBadge)
        statusBadge.addSubview(statusIcon)
        statusBadge.addSubview(statusLabel)

        contentView.addSubview(detailsGridView)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)

        view.addSubview(requestButton)

        setupDetailsGrid()

        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: requestButton.topAnchor, constant: -16),

            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Food image
            foodImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: 320),

            // Back button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            // Favorite button
            favoriteButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),

            // Share button
            shareButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.widthAnchor.constraint(equalToConstant: 40),
            shareButton.heightAnchor.constraint(equalToConstant: 40),

            // Title
            titleLabel.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Donor label
            donorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            donorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            // Rating view
            ratingView.centerYAnchor.constraint(equalTo: donorLabel.centerYAnchor),
            ratingView.leadingAnchor.constraint(equalTo: donorLabel.trailingAnchor, constant: 8),
            ratingView.heightAnchor.constraint(equalToConstant: 20),

            starImageView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor),
            starImageView.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16),

            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor),

            // Status badge
            statusBadge.topAnchor.constraint(equalTo: donorLabel.bottomAnchor, constant: 16),
            statusBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusBadge.heightAnchor.constraint(equalToConstant: 32),

            statusIcon.leadingAnchor.constraint(equalTo: statusBadge.leadingAnchor, constant: 8),
            statusIcon.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            statusIcon.widthAnchor.constraint(equalToConstant: 16),
            statusIcon.heightAnchor.constraint(equalToConstant: 16),

            statusLabel.leadingAnchor.constraint(equalTo: statusIcon.trailingAnchor, constant: 6),
            statusLabel.trailingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: -8),
            statusLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),

            // Details grid
            detailsGridView.topAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: 24),
            detailsGridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsGridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Description title
            descriptionTitleLabel.topAnchor.constraint(equalTo: detailsGridView.bottomAnchor, constant: 32),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Description
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            // Request button
            requestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            requestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            requestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            requestButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupDetailsGrid() {
        // Row 1: Expires and Quantity
        let row1 = createDetailRow(
            item1: ("clock", "Expires", ""),
            item2: ("person.2", "Quantity", "")
        )

        // Row 2: Distance and Allergens
        let row2 = createDetailRow(
            item1: ("location", "Distance", ""),
            item2: ("exclamationmark.triangle", "Allergens", "")
        )

        detailsGridView.addArrangedSubview(row1)
        detailsGridView.addArrangedSubview(row2)
    }

    private func createDetailRow(item1: (String, String, String), item2: (String, String, String)) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 16

        let cell1 = createDetailCell(icon: item1.0, title: item1.1, value: item1.2)
        let cell2 = createDetailCell(icon: item2.0, title: item2.1, value: item2.2)

        row.addArrangedSubview(cell1)
        row.addArrangedSubview(cell2)

        return row
    }

    private func createDetailCell(icon: String, title: String, value: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 8

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = .systemGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = .systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 2
        valueLabel.tag = 100 // For updating later
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconImageView)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),

            iconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            valueLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }

    private func populateData() {
        titleLabel.text = donation.itemName
        donorLabel.text = "by Anonymous Donor" // TODO: Get actual donor name
        ratingLabel.text = "4.8" // TODO: Implement rating system
        descriptionLabel.text = donation.description

        // Set placeholder image
        foodImageView.image = UIImage(systemName: donation.category.icon)
        foodImageView.tintColor = Constants.Colors.primaryGreen
        foodImageView.contentMode = .center

        // TODO: Load actual image from URL
        // if let photoURL = donation.photo { loadImage(from: photoURL) }

        // Update detail cells
        updateDetailCell(in: detailsGridView.arrangedSubviews[0], index: 0, value: getExpiryText())
        updateDetailCell(in: detailsGridView.arrangedSubviews[0], index: 1, value: "\(donation.quantity) \(donation.quantityUnit.rawValue.lowercased())")
        updateDetailCell(in: detailsGridView.arrangedSubviews[1], index: 0, value: "0.5 mi away") // TODO: Calculate distance
        updateDetailCell(in: detailsGridView.arrangedSubviews[1], index: 1, value: getAllergensText())
    }

    private func updateDetailCell(in row: UIView, index: Int, value: String) {
        if let stackView = row as? UIStackView,
           let cell = stackView.arrangedSubviews[index] as? UIView,
           let valueLabel = cell.viewWithTag(100) as? UILabel {
            valueLabel.text = value
        }
    }

    private func getExpiryText() -> String {
        guard let expiryDate = donation.expiryDate else {
            return "No expiry"
        }

        let formatter = DateFormatter()
        let calendar = Calendar.current

        if calendar.isDateInToday(expiryDate) {
            formatter.dateFormat = "h:mm a"
            return "Today\n\(formatter.string(from: expiryDate))"
        } else if calendar.isDateInTomorrow(expiryDate) {
            formatter.dateFormat = "h:mm a"
            return "Tomorrow\n\(formatter.string(from: expiryDate))"
        } else {
            formatter.dateFormat = "MMM dd\nh:mm a"
            return formatter.string(from: expiryDate)
        }
    }

    private func getAllergensText() -> String {
        if donation.allergens.isEmpty {
            return "None"
        }
        return donation.allergens.map { $0.displayName }.joined(separator: ", ")
    }

    // MARK: - Actions
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func favoriteButtonTapped() {
        // TODO: Implement favorite functionality
        let isFavorited = favoriteButton.image(for: .normal) == UIImage(systemName: "heart.fill")

        if isFavorited {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .systemRed
        }
    }

    @objc private func shareButtonTapped() {
        let text = "Check out this donation: \(donation.itemName)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = shareButton
            popoverController.sourceRect = shareButton.bounds
        }

        present(activityVC, animated: true)
    }

    @objc private func requestButtonTapped() {
        // TODO: Implement request/claim functionality
        let successVC = SuccessViewController(
            title: "Request Sent!",
            message: "The donor will be notified of your pickup request"
        ) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        present(successVC, animated: true)
    }
}
