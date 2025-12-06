//
//  SelectTypeViewController.swift
//  RePlate
//
//  Created by Basem Elkhayat on 06/12/2025.
//
import UIKit

class SelectTypeViewController: UIViewController {

    @IBOutlet weak var donateView: UIView!
    @IBOutlet weak var collectView: UIView!
    @IBOutlet weak var continueButton: UIButton!

    var selectedType: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        resetSelection()
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
    }

    @IBAction func donateTapped(_ sender: UIButton) {
        selectedType = "donate"
        updateSelectionUI()
    }

    @IBAction func collectTapped(_ sender: UIButton) {
        selectedType = "collect"
        updateSelectionUI()
    }

    @IBAction func continueTapped(_ sender: UIButton) {
        guard let type = selectedType else { return }

        print("Selected Type: \(type)")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

    func updateSelectionUI() {
        resetSelection()

        if selectedType == "donate" {
            donateView.layer.borderWidth = 2
            donateView.layer.borderColor = UIColor.systemGreen.cgColor
        } 
        if selectedType == "collect" {
            collectView.layer.borderWidth = 2
            collectView.layer.borderColor = UIColor.systemGreen.cgColor
        }

        continueButton.isEnabled = true
        continueButton.alpha = 1
    }

    func resetSelection() {
        donateView.layer.borderWidth = 0
        collectView.layer.borderWidth = 0
    }
}
