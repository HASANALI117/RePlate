//
//  RegisterViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 05/12/2025.
//
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }

    @IBAction func signUpTapped(_ sender: UIButton) {

        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        if !isValidPhone(phone) {
            showAlert(title: "Invalid Phone", message: "Phone number must contain numbers only.")
            return
        }

        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }

        if password != confirmPassword {
            showAlert(title: "Password Error", message: "Passwords do not match.")
            return
        }

        goToSelectType()
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }

    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return predicate.evaluate(with: phone)
    }

    func goToSelectType() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectTypeViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
