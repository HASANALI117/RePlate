//
//  OrganizationDetailsViewController.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

final class OrganizationDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var regDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    @IBOutlet weak var labelsContainer: UIStackView!
    @IBOutlet weak var documentsContainer: UIStackView!
    
    let verifiedTextColor = UIColor(red: 22/255, green: 101/255, blue: 52/255, alpha: 1)
    let verifiedBackgroundColor = UIColor(red: 220/255, green: 252/255, blue: 231/255, alpha: 1)

    let pendingTextColor = UIColor(red: 133/255, green: 77/255, blue: 14/255, alpha: 1)
    let pendingBackgroundColor = UIColor(red: 254/255, green: 249/255, blue: 195/255, alpha: 1)
    
    var organization: Organization!
    
    let dummyOrg = Organization(
        id: "ORG-2019-B0892",
        name: "Sitra Community Kitchen",
        location: "Sitra, Bahrain",
        regestrationDate: "2019",
        documents: [
            "Registration_Certificate.pdf",
            "Bank_Account_Verification.pdf",
            "Annual_Report_2024.pdf",
            "Ministry_Approval_Letter.pdf",
            "NGO_Profile.pdf"
        ],
        status: "Verified",
        email: "info@sitrakitchen.org",
        phone: "+973 3600 1234"
    )


    override func viewDidLoad() {
        super.viewDidLoad()

        if organization == nil {
            organization = dummyOrg
        }

        setupUI()
        setupTable()
        
   
        
    }

    private func setupUI() {
        nameLabel.text = organization.name
        locationLabel.text = organization.location
        regDateLabel.text = organization.regestrationDate
        emailLabel.text = organization.email
        phoneLabel.text = organization.phone

        statusLabel.text = organization.status
        statusLabel.textColor = (organization.status.lowercased() == "verified") ? verifiedTextColor : pendingTextColor
        statusLabel.backgroundColor = (organization.status.lowercased() == "verified") ? verifiedBackgroundColor : pendingBackgroundColor
        
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true

        labelsContainer.backgroundColor = .systemBackground
        labelsContainer.layer.cornerRadius = 8
        labelsContainer.layer.masksToBounds = true

        labelsContainer.layer.borderWidth = 1
        labelsContainer.layer.borderColor = UIColor.systemGray4.cgColor
        
        documentsContainer.backgroundColor = .systemBackground
        documentsContainer.layer.cornerRadius = 8
        documentsContainer.layer.masksToBounds = true

        documentsContainer.layer.borderWidth = 1
        documentsContainer.layer.borderColor = UIColor.systemGray4.cgColor
    }

    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
}

// MARK: - Table DataSource
extension OrganizationDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        organization.documents.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell",
                                                       for: indexPath) as? DocumentCell else {
            return UITableViewCell()
        }

        let fileName = organization.documents[indexPath.row]
        cell.configure(fileName: fileName, sizeText: dummySizeText(for: indexPath.row))
        return cell
    }

    private func dummySizeText(for index: Int) -> String {
        let sizes = ["PDF • 420 KB", "PDF • 1.2 MB", "PDF • 860 KB", "PDF • 300 KB", "PDF • 2.0 MB"]
        return sizes[index % sizes.count]
    }
}

// MARK: - Table Delegate
extension OrganizationDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let fileName = organization.documents[indexPath.row]
        print("Tapped document:", fileName)

    }
}

