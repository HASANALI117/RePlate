//
//  DonationDetailsViewController.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit
import PhotosUI

class DonationDetailsViewController: UIViewController {

    // MARK: - Properties
    var donation: Donation!
    private var selectedImage: UIImage?
    private var selectedAllergens: Set<Donation.AllergenInfo> = []

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
        label.text = "Add more details"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "Photo"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let cameraIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle.fill")
        imageView.tintColor = Constants.Colors.primaryGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Constants.Colors.primaryGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.systemGray6
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "e.g., Freshly baked this morning"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let expiryLabel: UILabel = {
        let label = UILabel()
        label.text = "Expires / Use By"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let expiryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "mm/dd/yyyy"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let allergenLabel: UILabel = {
        let label = UILabel()
        label.text = "Allergen Information"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let allergenStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.minimumDate = Date()
        return picker
    }()

    private var allergenButtons: [AllergenButton] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
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
        contentView.addSubview(photoLabel)
        contentView.addSubview(photoButton)
        photoButton.addSubview(photoImageView)
        photoButton.addSubview(cameraIconView)
        photoButton.addSubview(addPhotoLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        descriptionTextView.addSubview(placeholderLabel)
        contentView.addSubview(expiryLabel)
        contentView.addSubview(expiryTextField)
        contentView.addSubview(allergenLabel)
        contentView.addSubview(allergenStackView)

        // Setup progress bar
        progressBar.setProgress(step: 2, totalSteps: 4)

        // Setup allergen buttons
        setupAllergenButtons()

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

            // Photo label
            photoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            photoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            // Photo button
            photoButton.topAnchor.constraint(equalTo: photoLabel.bottomAnchor, constant: 12),
            photoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            photoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            photoButton.heightAnchor.constraint(equalToConstant: 160),

            // Photo image view
            photoImageView.topAnchor.constraint(equalTo: photoButton.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: photoButton.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: photoButton.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: photoButton.bottomAnchor),

            // Camera icon
            cameraIconView.centerXAnchor.constraint(equalTo: photoButton.centerXAnchor),
            cameraIconView.centerYAnchor.constraint(equalTo: photoButton.centerYAnchor, constant: -15),
            cameraIconView.widthAnchor.constraint(equalToConstant: 50),
            cameraIconView.heightAnchor.constraint(equalToConstant: 50),

            // Add photo label
            addPhotoLabel.topAnchor.constraint(equalTo: cameraIconView.bottomAnchor, constant: 8),
            addPhotoLabel.centerXAnchor.constraint(equalTo: photoButton.centerXAnchor),

            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            // Description text view
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            // Placeholder
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 12),

            // Expiry label
            expiryLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            expiryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            // Expiry text field
            expiryTextField.topAnchor.constraint(equalTo: expiryLabel.bottomAnchor, constant: 8),
            expiryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            expiryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            expiryTextField.heightAnchor.constraint(equalToConstant: 50),

            // Allergen label
            allergenLabel.topAnchor.constraint(equalTo: expiryTextField.bottomAnchor, constant: 24),
            allergenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),

            // Allergen stack view
            allergenStackView.topAnchor.constraint(equalTo: allergenLabel.bottomAnchor, constant: 12),
            allergenStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            allergenStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            allergenStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func setupAllergenButtons() {
        // Create rows of allergen buttons
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 8
        row1.distribution = .fillEqually

        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 8
        row2.distribution = .fillEqually

        let allergens = Donation.AllergenInfo.allCases

        for (index, allergen) in allergens.enumerated() {
            let button = AllergenButton(allergen: allergen)
            button.addTarget(self, action: #selector(allergenButtonTapped(_:)), for: .touchUpInside)
            allergenButtons.append(button)

            if index < 3 {
                row1.addArrangedSubview(button)
            } else {
                row2.addArrangedSubview(button)
            }
        }

        allergenStackView.addArrangedSubview(row1)
        allergenStackView.addArrangedSubview(row2)
    }

    private func setupDatePicker() {
        expiryTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(datePickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerCancel))

        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        expiryTextField.inputAccessoryView = toolbar
    }

    private func setupTextView() {
        descriptionTextView.delegate = self
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }

    // MARK: - Actions
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func photoButtonTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func allergenButtonTapped(_ sender: AllergenButton) {
        sender.isSelected.toggle()

        if sender.isSelected {
            selectedAllergens.insert(sender.allergen)
        } else {
            selectedAllergens.remove(sender.allergen)
        }
    }

    @objc private func datePickerDone() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        expiryTextField.text = formatter.string(from: datePicker.date)
        donation.expiryDate = datePicker.date
        expiryTextField.resignFirstResponder()
    }

    @objc private func datePickerCancel() {
        expiryTextField.resignFirstResponder()
    }

    @objc private func nextButtonTapped() {
        // Validate description
        guard !descriptionTextView.text.isEmpty else {
            showAlert(title: "Missing Information", message: "Please add a description")
            return
        }

        // Update donation object
        donation.description = descriptionTextView.text
        donation.allergens = Array(selectedAllergens)

        // TODO: Upload photo to Firebase Storage and save URL
        // For now, we'll just proceed

        // Navigate to next screen
        let locationVC = DonationLocationViewController()
        locationVC.donation = donation
        navigationController?.pushViewController(locationVC, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension DonationDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - PHPickerViewControllerDelegate
extension DonationDetailsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.selectedImage = image
                    self?.photoImageView.image = image
                    self?.photoImageView.isHidden = false
                    self?.cameraIconView.isHidden = true
                    self?.addPhotoLabel.isHidden = true
                }
            }
        }
    }
}

// MARK: - Allergen Button
class AllergenButton: UIButton {
    let allergen: Donation.AllergenInfo

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    init(allergen: Donation.AllergenInfo) {
        self.allergen = allergen
        super.init(frame: .zero)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        setTitle(allergen.displayName, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.8
        layer.cornerRadius = 8
        heightAnchor.constraint(equalToConstant: 44).isActive = true

        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = getColorForAllergen()
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = UIColor.systemGray6
            setTitleColor(.darkGray, for: .normal)
        }
    }

    private func getColorForAllergen() -> UIColor {
        switch allergen {
        case .containsNuts:
            return UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
        case .glutenFree:
            return UIColor(red: 52/255, green: 168/255, blue: 83/255, alpha: 1.0)
        case .dairyFree:
            return UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
        case .vegan:
            return UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        case .containsShellfish:
            return UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1.0)
        case .eggFree:
            return UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1.0)
        }
    }
}
