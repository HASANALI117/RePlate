//
//  OrganizationsListingViewController.swift
//  Replate
//
//  Created by Abdulla on 31/12/2025.
//

import UIKit

class OrganizationsListingViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    private let organizations: [Organization] = [
        Organization(
            id: "ORG-001",
            name: "Sitra Community Kitchen",
            location: "Sitra, Bahrain",
            regestrationDate: "2019",
            documents: ["Reg.pdf", "Bank.pdf", "Report.pdf"],
            status: "Verified",
            email: "info@sitra.org",
            phone: "+973 3600 1234"
        ),
        Organization(
            id: "ORG-002",
            name: "Manama Food Bank",
            location: "Manama, Bahrain",
            regestrationDate: "2021",
            documents: ["Reg.pdf", "Approval.pdf"],
            status: "Pending",
            email: "contact@manamafood.org",
            phone: "+973 3300 9876"
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

extension OrganizationsListingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        organizations.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "OrganizationCell",
            for: indexPath
        ) as? OrganizationCell else {
            return UITableViewCell()
        }

        let org = organizations[indexPath.row]
        cell.configure(with: org)
        return cell
    }
}


