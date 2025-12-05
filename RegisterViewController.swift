//
//  RegisterViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 05/12/2025.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        
        // Secure password fields
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        // Keyboard types
        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .phonePad
    }

    // MARK: - Sign Up Button Action
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""

        // Validation
        if name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert(title: "Error", message: "All fields are required")
            return
        }

        if password != confirmPassword {
            showAlert(title: "Error", message: "Passwords do not match")
            return
        }

        if password.count < 6 {
            showAlert(title: "Error", message: "Password must be at least 6 characters")
            return
        }

    
        showAlert(title: "Success", message: "Account created successfully")
    }

    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
