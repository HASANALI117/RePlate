//
//  Untitled.swift
//  Replate
//
//  Created by Abdulla on 31/12/2025.
//

import UIKit

final class OrganizationVerificationForm: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var containerView: UIView!

    var id: String!

    private let options = ["Platform Verified", "Government Verified"]
    private var selectedOption: String?

    private let placeholderText = "Add any comments or notes about this verification..."
    private let placeholderColor = UIColor.systemGray3
    private let textColor = UIColor.label

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.layer.borderWidth = 1

        commentTextField.layer.cornerRadius = 8
        commentTextField.layer.borderColor = UIColor.systemGray4.cgColor
        commentTextField.layer.borderWidth = 1

        setupDropdown()
        setupTextViewPlaceholder()
    }

    // MARK: - Dropdown
    private func setupDropdown() {
        dropDownButton.setTitle("Select verification type", for: .normal)

        let actions = options.map { option in
            UIAction(title: option, state: option == selectedOption ? .on : .off) { [weak self] _ in
                guard let self else { return }
                self.selectedOption = option
                self.dropDownButton.setTitle(option, for: .normal)
            }
        }

        dropDownButton.menu = UIMenu(title: "Verification Type", options: .singleSelection, children: actions)
        dropDownButton.showsMenuAsPrimaryAction = true
        dropDownButton.changesSelectionAsPrimaryAction = true
    }

    // MARK: - TextView Placeholder
    private func setupTextViewPlaceholder() {
        commentTextField.delegate = self
        commentTextField.text = placeholderText
        commentTextField.textColor = placeholderColor
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = ""
            textView.textColor = textColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
    }

    private func currentComment() -> String {
        if commentTextField.textColor == placeholderColor { return "" }
        return commentTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions
    @IBAction func aprroveButtonTapped(_ sender: Any) {
        guard let id else { return }
        guard let verificationType = selectedOption else {
            showAlert(
                title: "Verification Required",
                message: "Please select a verification type before approving the organization."
            )
            return
        }

        Task {
            do {
                try await NgoController.shared.setOrganizationStatus(
                    id: id,
                    status: "Verified",
                    content: currentComment(),
                    verificationType: verificationType
                )
                await MainActor.run { self.closeThisScreen() }
            } catch {
                showAlert(
                    title: "Error",
                    message: "Failed to approve the organization. Please try again."
                )
            }
        }
    }


    @IBAction func RejectButtonTapped(_ sender: Any) {
        guard let id else { return }
        guard let verificationType = selectedOption else {
            showAlert(
                title: "Verification Required",
                message: "Please select a verification type before rejecting the organization."
            )
            return
        }

        Task {
            do {
                try await NgoController.shared.setOrganizationStatus(
                    id: id,
                    status: "Rejected",
                    content: currentComment(),
                    verificationType: verificationType
                )
                await MainActor.run { self.closeThisScreen() }
            } catch {
                showAlert(
                    title: "Error",
                    message: "Failed to reject the organization. Please try again."
                )
            }
        }
    }

    private func closeThisScreen() {
        if let nav = navigationController {
            let count = nav.viewControllers.count
            if count >= 3 {
                nav.popToViewController(nav.viewControllers[count - 3], animated: true)
            } else {
                nav.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
