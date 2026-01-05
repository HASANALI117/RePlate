//
//  Extensions.swift
//  Replate
//
//  Created by Hasan on 17/12/2025.
//

import UIKit

// MARK: - UIView Extensions
extension UIView {

    /// Adds a corner radius to the view
    func roundCorners(radius: CGFloat = Constants.UI.cornerRadius) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    /// Adds a border to the view
    func addBorder(color: UIColor, width: CGFloat = Constants.UI.borderWidth) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    /// Adds a shadow to the view
    func addShadow(color: UIColor = .black, opacity: Float = 0.1, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}

// MARK: - UIViewController Extensions
extension UIViewController {

    /// Shows a simple alert
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }

    /// Hides keyboard when tapping outside
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - String Extensions
extension String {

    /// Checks if string is a valid email
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    /// Trims whitespace and newlines
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
