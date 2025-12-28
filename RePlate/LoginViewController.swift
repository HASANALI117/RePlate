//
//  LoginViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 05/12/2025.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginButton.layer.cornerRadius = 8
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showForgotPasswordAlert() {
        let alert = UIAlertController(
            title: "Reset Password",
            message: "Enter your email to receive a password reset link.",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Send", style: .default) { _ in
            let email = alert.textFields?.first?.text ?? ""
            self.sendPasswordReset(email: email)
        })

        present(alert, animated: true)
    }
    
    func sendPasswordReset(email: String) {
        guard !email.isEmpty else {
            showError(message: "Please enter your email.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }

            self.showSuccess(message: "If the email exists, a reset link has been sent.")
        }
    }
    
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {

        guard let email = emailTextField.text, !email.isEmpty else {
            showError(message: "Please enter your email first")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }

            let alert = UIAlertController(
                title: "Email Sent",
                message: "A password reset email has been sent to \(email)",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // Handle authentication result
            if let error = error {
                // Sign in failed - show error message
                self?.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            
            UIApplication.shared.windows.first?.rootViewController = tabBarVC
            
            // Sign in successful - navigate to home screen
            self?.performSegue(withIdentifier: "Home", sender: sender)
            
            
        }
    }
    
    @IBAction func googleSignInTapped(_ sender: UIButton) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self
        ) { result, error in
            
            if let error = error {
                print("Google Sign In Error:", error)
                return
            }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign In Error:", error)
                    return
                }
                
                print("Google Sign In Success")
                
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeVC = storyboard.instantiateViewController(
                        withIdentifier: "MainTabBarController"
                    )
                    homeVC.modalPresentationStyle = .fullScreen
                    self.present(homeVC, animated: true)
                }
            }
        }
        
    }
}
