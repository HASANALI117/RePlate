//
//  ProfilAuthenticationViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 11/12/2025.
//

import UIKit

class ProfileAuthenticationViewController: UIViewController {

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var totalDonationsLabel: UILabel!
    @IBOutlet weak var activeDonationsLabel: UILabel!
    @IBOutlet weak var peopleHelpedLabel: UILabel!

    @IBOutlet weak var myDonationsButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var savedLocationsButton: UIButton!
    @IBOutlet weak var impactDashboardButton: UIButton!

    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var preferencesButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!

    @IBOutlet weak var helpFAQButton: UIButton!

    @IBOutlet weak var signOutButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadUserData()
    }


    func setupUI() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        headerView.layer.zPosition = 1
    }


    func loadUserData() {

        nameLabel.text = "Green Leaf Cafe"
        emailLabel.text = "green.leaf@email.com"

        totalDonationsLabel.text = "24"
        activeDonationsLabel.text = "18"
        peopleHelpedLabel.text = "140"

        profileImage.image = UIImage(systemName: "person.crop.circle")
    }



    @IBAction func myDonationsTapped(_ sender: Any) {
        print("My Donations tapped")
    }

    @IBAction func favoritesTapped(_ sender: Any) {
        print("Favorites tapped")
    }

    @IBAction func savedLocationsTapped(_ sender: Any) {
        print("Saved Locations tapped")
    }

    @IBAction func impactDashboardTapped(_ sender: Any) {
        print("Impact Dashboard tapped")
    }

    @IBAction func editProfileTapped(_ sender: Any) {
        print("Edit Profile tapped")
    }

    @IBAction func notificationsTapped(_ sender: Any) {
        print("Notifications tapped")
    }

    @IBAction func preferencesTapped(_ sender: Any) {
        print("Preferences tapped")
    }

    @IBAction func privacyTapped(_ sender: Any) {
        print("Privacy tapped")
    }

    @IBAction func helpTapped(_ sender: Any) {
        print("Help & FAQ tapped")
    }

    @IBAction func signOutTapped(_ sender: Any) {
        print("User Signed Out")
    }

}
