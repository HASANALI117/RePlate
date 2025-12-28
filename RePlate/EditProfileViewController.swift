//
//  ProfileEditViewController.swift
//  Replate
//
//  Created by Basem Elkhayat on 21/12/2025.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInfo()
    }

    func loadUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.reload { [weak self] error in
            if let error = error {
                print("Reload error:", error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self?.userNameLabel.text = user.displayName ?? "No Name"
                self?.userEmailLabel.text = user.email ?? "No Email"
            }
        }
    }

    func setupFields() {
        if let user = Auth.auth().currentUser {
            nameTextField.text = user.displayName
            emailTextField.text = ""
            emailTextField.isEnabled = true
        }
    }

    @IBAction func updateButtonTapped(_ sender: UIButton) {

        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Warning", message: "Name is required")
            return
        }

        let newEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let user = Auth.auth().currentUser else { return }

   
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name

        changeRequest.commitChanges { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

    
            if let email = newEmail, !email.isEmpty {
                user.updateEmail(to: email) { error in
                    if let error = error {
                        self?.showAlert(title: "Email Error", message: error.localizedDescription)
                        return
                    }

                    self?.goBackToProfile()
                }
            } else {
                self?.goBackToProfile()
            }
        }
    }

    func goBackToProfile() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ProfileAuth", sender: nil)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

