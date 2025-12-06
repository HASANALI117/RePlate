//
//  LoginViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 05/12/2025.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginButton.layer.cornerRadius = 8
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty {
            showAlert(title: "Error", message: "Please enter email and password")
            return
        }
        
        if email == "admin@gmail.com" && password == "1234" {
            showAlert(title: "Success", message: "Login successful")
        } else {
            showAlert(title: "Failed", message: "Invalid email or password")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
