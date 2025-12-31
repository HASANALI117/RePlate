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

    // from previous page
    var id: String!

    private let options = ["Platform Verified", "Government Verified"]
    private var selectedOption: String?

    private let placeholderText = "Write a comment (optional)..."
    private let placeholderColor = UIColor.systemGray3
    private let textColor = UIColor.label

    override func viewDidLoad() {
        super.viewDidLoad()

        // container styling
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
        // default title
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
        // return empty if it's placeholder
        if commentTextField.textColor == placeholderColor { return "" }
        return commentTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Actions
    @IBAction func aprroveButtonTapped(_ sender: Any) {
        // later: call your update status function using:
        // id, selectedOption, currentComment()

        closeThisScreen()
    }

    @IBAction func RejectButtonTapped(_ sender: Any) {
        // later: call your reject function using:
        // id, currentComment()

        closeThisScreen()
    }

    private func closeThisScreen() {
        if let nav = navigationController, nav.viewControllers.first != self {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

