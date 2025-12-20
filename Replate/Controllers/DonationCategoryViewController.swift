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

    // MARK: - UI Components
    private let progressBar: DonationProgressView = {
        let view = DonationProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = Constants.Colors.primaryGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What are you donating?"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let categoryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "e.g., Organic Apples, Homemade Lasagna"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantity"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let quantityContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let unitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Plates", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryGreen
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var selectedCategory: Donation.DonationCategory = .freshProduce
    private var selectedUnit: Donation.QuantityUnit = .plates
    private var categoryButtons: [CategoryButton] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()

        // Initialize donation if needed
        if donation == nil {
            // TODO: Replace with actual user ID when authentication is implemented
            let mockUserId = "MOCK_USER_\(UUID().uuidString.prefix(8))"
            donation = Donation(donorId: mockUserId)
        }

        hideKeyboardWhenTappedAround()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        // Add subviews
        view.addSubview(progressBar)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(categoryLabel)
        view.addSubview(categoryStackView)
        view.addSubview(itemNameLabel)
        view.addSubview(itemNameTextField)
        view.addSubview(quantityLabel)
        view.addSubview(quantityContainer)
        quantityContainer.addSubview(quantityTextField)
        quantityContainer.addSubview(unitButton)
        view.addSubview(nextButton)

        // Setup progress bar
        progressBar.setProgress(step: 1, totalSteps: 4)

        // Setup category buttons
        setupCategoryButtons()

        // Layout
        NSLayoutConstraint.activate([
            // Progress bar
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 30),

            // Close button
            closeButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            // Title
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),

            // Category label
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),

            // Category stack
            categoryStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),

            // Item name label
            itemNameLabel.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 32),
            itemNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),

            // Item name text field
            itemNameTextField.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 8),
            itemNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            itemNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 50),

            // Quantity label
            quantityLabel.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 24),
            quantityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),

            // Quantity container
            quantityContainer.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 8),
            quantityContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            quantityContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            quantityContainer.heightAnchor.constraint(equalToConstant: 50),

            // Quantity text field
            quantityTextField.leadingAnchor.constraint(equalTo: quantityContainer.leadingAnchor, constant: 12),
            quantityTextField.centerYAnchor.constraint(equalTo: quantityContainer.centerYAnchor),
            quantityTextField.widthAnchor.constraint(equalToConstant: 100),

            // Unit button
            unitButton.leadingAnchor.constraint(equalTo: quantityTextField.trailingAnchor, constant: 8),
            unitButton.trailingAnchor.constraint(equalTo: quantityContainer.trailingAnchor, constant: -12),
            unitButton.centerYAnchor.constraint(equalTo: quantityContainer.centerYAnchor),

            // Next button
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func setupCategoryButtons() {
        let categories: [Donation.DonationCategory] = [.freshProduce, .cookedMeals, .packagedGoods]

        for category in categories {
            let button = CategoryButton(category: category)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(button)
            categoryButtons.append(button)
        }

        // Select first category by default
        categoryButtons.first?.isSelected = true
    }

    // MARK: - Actions
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        unitButton.addTarget(self, action: #selector(unitButtonTapped), for: .touchUpInside)
    }

    @objc private func closeButtonTapped() {
        let alert = UIAlertController(title: "Discard Donation?", message: "Are you sure you want to cancel? Your progress will be lost.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue Editing", style: .cancel))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    @objc private func categoryButtonTapped(_ sender: CategoryButton) {
        // Deselect all buttons
        categoryButtons.forEach { $0.isSelected = false }

        // Select tapped button
        sender.isSelected = true
        selectedCategory = sender.category

        // Update unit options based on category
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

        // For iPad
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = unitButton
            popoverController.sourceRect = unitButton.bounds
        }

        present(actionSheet, animated: true)
    }

    @objc private func nextButtonTapped() {
        // Validate input
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

        // Navigate to next screen
        let detailsVC = DonationDetailsViewController()
        detailsVC.donation = donation
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - Category Button
class CategoryButton: UIButton {
    let category: Donation.DonationCategory

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    init(category: Donation.DonationCategory) {
        self.category = category
        super.init(frame: .zero)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        // Container setup
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray5.cgColor

        // Icon
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: category.icon)
        iconImageView.tintColor = Constants.Colors.primaryGreen
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Label
        let label = UILabel()
        label.text = category.rawValue
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        // Chevron
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray3
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconImageView)
        addSubview(label)
        addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14)
        ])

        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            layer.borderColor = Constants.Colors.primaryGreen.cgColor
            layer.borderWidth = 2
            backgroundColor = Constants.Colors.primaryGreen.withAlphaComponent(0.05)
        } else {
            layer.borderColor = UIColor.systemGray5.cgColor
            layer.borderWidth = 2
            backgroundColor = .white
        }
    }
}

// MARK: - Donation Progress View
class DonationProgressView: UIView {
    private let progressBarBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let progressBarFill: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryGreen
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var progressWidthConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(progressBarBackground)
        progressBarBackground.addSubview(progressBarFill)
        addSubview(stepLabel)

        progressWidthConstraint = progressBarFill.widthAnchor.constraint(equalTo: progressBarBackground.widthAnchor, multiplier: 0.25)

        NSLayoutConstraint.activate([
            stepLabel.topAnchor.constraint(equalTo: topAnchor),
            stepLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            progressBarBackground.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 8),
            progressBarBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBarBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBarBackground.heightAnchor.constraint(equalToConstant: 4),
            progressBarBackground.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressBarFill.leadingAnchor.constraint(equalTo: progressBarBackground.leadingAnchor),
            progressBarFill.topAnchor.constraint(equalTo: progressBarBackground.topAnchor),
            progressBarFill.bottomAnchor.constraint(equalTo: progressBarBackground.bottomAnchor),
            progressWidthConstraint
        ])
    }

    func setProgress(step: Int, totalSteps: Int) {
        stepLabel.text = "Step \(step) of \(totalSteps)"
        let progress = CGFloat(step) / CGFloat(totalSteps)
        progressWidthConstraint.isActive = false
        progressWidthConstraint = progressBarFill.widthAnchor.constraint(equalTo: progressBarBackground.widthAnchor, multiplier: progress)
        progressWidthConstraint.isActive = true

        UIView.animate(withDuration: Constants.Animation.medium) {
            self.layoutIfNeeded()
        }
    }
}
