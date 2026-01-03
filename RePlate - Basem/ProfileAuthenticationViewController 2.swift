//
//  ProfilAuthenticationViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 11/12/2025.
//

import UIKit
import FirebaseAuth // 

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var totalDonationsLabel: UILabel!
    @IBOutlet weak var activeDonationsLabel: UILabel!
    @IBOutlet weak var peopleHelpedLabel: UILabel!

    var totalDonations = 24
    var activeDonations = 18
    var peopleHelped = 140

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserProfile()
        updateDonationStats()
    }

    func setupUserProfile() {
        if let user = Auth.auth().currentUser {
            userEmailLabel.text = user.email
            
            userNameLabel.text = user.displayName ?? "User Name"
        }
    }

    func updateDonationStats() {
        totalDonationsLabel.text = "\(totalDonations)"
        activeDonationsLabel.text = "\(activeDonations)"
        peopleHelpedLabel.text = "\(peopleHelped)"
    }

    @IBAction func signOutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            self.performSegue(withIdentifier: "Login", sender: self)
            
        } catch let signOutError as NSError {
            showAlert(title: "Error", message: "Error signing out: \(signOutError.localizedDescription)")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
