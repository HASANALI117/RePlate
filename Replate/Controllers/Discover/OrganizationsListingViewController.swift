//
//  OrganizationsListingViewController.swift
//  Replate
//
//  Created by Abdulla on 31/12/2025.
//

import UIKit

final class OrganizationsListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var organizations: [Organization] = []
    private var selectedOrganization: Organization?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            do { try await loadData() }
            catch { print("❌ loadData:", error) }
        }
    }

    private func loadData() async throws {
        let data = try await NgoController.shared.getAllOrganizations()
        await MainActor.run {
            self.organizations = data
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrganizationDetailsViewController" {
            guard
                let destination = segue.destination as? OrganizationDetailsViewController,
                let org = selectedOrganization
            else { return }

            destination.organization = org
        }
    }

    
    @objc private func detailsButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedOrganization = organizations[index]
        performSegue(withIdentifier: "OrganizationDetailsViewController", sender: self)
    }

}

extension OrganizationsListingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        organizations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCell",
                                                       for: indexPath) as? OrganizationCell else {
            return UITableViewCell()
        }
        cell.configure(with: organizations[indexPath.row])
        cell.detailsButton.tag = indexPath.row
        cell.detailsButton.addTarget(self, action: #selector(detailsButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
}

extension OrganizationsListingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOrganization = organizations[indexPath.row]
        performSegue(withIdentifier: "OrganizationDetailsViewController", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}



