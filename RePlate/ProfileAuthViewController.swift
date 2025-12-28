//
//  ProfileAuthViewController.swift
//  Replate
//
//  Created by Basem Elkhayat on 21/12/2025.
//

import UIKit
import FirebaseAuth

class ProfileAuthViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var totalDonationsLabel: UILabel!
    @IBOutlet weak var activeDonationsLabel: UILabel!
    @IBOutlet weak var peopleHelpedLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet weak var deleteAccountTapped: UIButton!
    @IBOutlet weak var darkModeContainerView: UIView!
    var totalDonations = 24
    var activeDonations = 18
    var peopleHelped = 140

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserProfile()
        updateDonationStats()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        darkModeSwitch.isOn = isDarkMode
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        darkModeContainerView.layer.cornerRadius = 20
        darkModeContainerView.clipsToBounds = true
    }
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")

        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true)
    }
    
    
    func setupUserProfile() {
        if let user = Auth.auth().currentUser {
            userEmailLabel.text = user.email
            userNameLabel.text = user.displayName ?? "User Name"
            loadGoogleProfileImage()
        }
    }
    func loadGoogleProfileImage() {
        guard let user = Auth.auth().currentUser,
              let photoURL = user.photoURL else { return }

        URLSession.shared.dataTask(with: photoURL) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }.resume()
    }

    func updateDonationStats() {
        totalDonationsLabel.text = "\(totalDonations)"
        activeDonationsLabel.text = "\(activeDonations)"
        peopleHelpedLabel.text = "\(peopleHelped)"
    }
    
    func showDeleteConfirmation() {

        let alert = UIAlertController(
            title: "Final Confirmation",
            message: "Type DELETE in capital letters to delete your account.",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Type DELETE"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            let input = alert.textFields?.first?.text ?? ""

            if input == "DELETE" {
                self.deleteUserAccount()
            } else {
                self.showError(message: "You must type DELETE to continue.")
            }
        })

        present(alert, animated: true)
    }
    
    func deleteUserAccount() {

        guard let user = Auth.auth().currentUser else { return }

        user.delete { error in
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                self.navigateToLogin()
            }
        }
    }

    @IBAction func darkModeSwitchChanged(_ sender: UISwitch) {

        if sender.isOn {
            // Dark Mode
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(true, forKey: "isDarkMode")
        } else {
            // Light Mode
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(false, forKey: "isDarkMode")
        }
    }
    
    @IBAction func deleteAccountTapped(_ sender: UIButton) {

        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.showDeleteConfirmation()
        })

        present(alert, animated: true)
    }
    
    
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let logoutAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            self.performSignOut()
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(logoutAlert, animated: true, completion: nil)
    }

    func performSignOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "Login", sender: self)
        } catch let signOutError as NSError {
            self.showAlert(title: "Error", message: signOutError.localizedDescription)
        }
    }

    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
