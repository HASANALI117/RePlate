//
//  RegisterViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 05/12/2025.
//
import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
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
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    @IBAction func signUpTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter an email address.")
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(title: "Missing Phone", message: "Please enter your phone number.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter a password.")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Missing Confirmation", message: "Please confirm your password.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "Password Mismatch", message: "Passwords do not match. Please try again.")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            
            if let error = error {
                self?.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            let user = User(
                uid: uid,
                name: self?.nameTextField.text ?? "",
                email: email,
                phone: phone,
                userType: "Pending" // or choose later
            )
            
            UserService.shared.createUser(user: user) { error in
                if let error = error {
                    self?.showAlert(title: "Database Error", message: error.localizedDescription)
                    return
                }
                
                self?.performSegue(withIdentifier: "SelectType", sender: sender)
            }
        }
        
        
        
    }
}
