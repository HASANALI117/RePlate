//
//  OrganizationDetailsViewController.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

final class OrganizationDetailsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var regDateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var labelsContainer: UIStackView!
    @IBOutlet weak var documentsContainer: UIStackView!
    @IBOutlet weak var actionButton: UIButton!

    // MARK: - Colors
    private let verifiedTextColor = UIColor(red: 22/255, green: 101/255, blue: 52/255, alpha: 1)
    private let verifiedBackgroundColor = UIColor(red: 220/255, green: 252/255, blue: 231/255, alpha: 1)

    private let pendingTextColor = UIColor(red: 133/255, green: 77/255, blue: 14/255, alpha: 1)
    private let pendingBackgroundColor = UIColor(red: 254/255, green: 249/255, blue: 195/255, alpha: 1)

    private let rejectedTextColor = UIColor(red: 153/255, green: 27/255, blue: 27/255, alpha: 1)
    private let rejectedBackgroundColor = UIColor(red: 254/255, green: 226/255, blue: 226/255, alpha: 1)

    // MARK: - Data
    var organization: Organization!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard organization != nil else {
            assertionFailure("OrganizationDetailsViewController.organization was not set before presenting")
            return
        }

        setupUI()
        configureActionButton()
        setupTable()
    }

    // MARK: - UI Setup
    private func setupUI() {
        nameLabel.text = organization.name
        locationLabel.text = organization.location
        regDateLabel.text = organization.regestrationDate
        emailLabel.text = organization.email
        phoneLabel.text = organization.phone

        statusLabel.text = organization.status
        applyStatusStyle(organization.status)

        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true
        statusLabel.textAlignment = .center

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

    private func applyStatusStyle(_ status: String) {
        switch status.lowercased() {
        case "verified":
            statusLabel.textColor = verifiedTextColor
            statusLabel.backgroundColor = verifiedBackgroundColor
        case "pending":
            statusLabel.textColor = pendingTextColor
            statusLabel.backgroundColor = pendingBackgroundColor
        case "rejected":
            statusLabel.textColor = rejectedTextColor
            statusLabel.backgroundColor = rejectedBackgroundColor
        default:
            statusLabel.textColor = .label
            statusLabel.backgroundColor = .systemGray5
        }
    }

    private func configureActionButton() {
        let isPending = organization.status.lowercased() == "pending"
        actionButton.isEnabled = isPending
        actionButton.alpha = isPending ? 1.0 : 0.5
        actionButton.setTitle(isPending ? "Review Organization" : "Already Reviewed", for: .normal)
    }

    // MARK: - Table Setup
    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrganizationVerificationForm" {
            guard let destination = segue.destination as? OrganizationVerificationForm else { return }
            destination.id = organization.id
        }
    }
}

// MARK: - UITableViewDataSource
extension OrganizationDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        organization.documents.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "DocumentCell",
            for: indexPath
        ) as? DocumentCell else {
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

// MARK: - UITableViewDelegate
extension OrganizationDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fileName = organization.documents[indexPath.row]
        print("Tapped document:", fileName)
    }
}


