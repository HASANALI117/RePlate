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

    // MARK: - IBOutlets
    @IBOutlet weak var progressBar: DonationProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoUploadView: PhotoUploadView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var expiryTextField: UITextField!
    @IBOutlet weak var allergenStackView: UIStackView!

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

        // Setup progress bar
        progressBar.setProgress(step: 2, totalSteps: 4)

        // Setup photo upload view
        photoUploadView.onTap = { [weak self] in
            self?.photoButtonTapped()
        }

        // Setup allergen buttons
        setupAllergenButtons()

        // Setup date picker
        setupDatePicker()

        // Setup text view
        setupTextView()

        // Setup actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        hideKeyboardWhenTappedAround()
    }

    // MARK: - Setup
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
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func photoButtonTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func allergenButtonTapped(_ sender: AllergenButton) {
        sender.isSelected.toggle()

        guard let allergen = sender.allergen else { return }

        if sender.isSelected {
            selectedAllergens.insert(allergen)
        } else {
            selectedAllergens.remove(allergen)
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

        // Navigate to next screen via segue
        performSegue(withIdentifier: "showDonationLocation", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDonationLocation",
           let locationVC = segue.destination as? DonationLocationViewController {
            locationVC.donation = donation
        }
    }

    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
                    self?.photoUploadView.setImage(image)
                }
            }
        }
    }
}
