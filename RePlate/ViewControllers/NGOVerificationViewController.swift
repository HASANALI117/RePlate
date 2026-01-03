import UIKit

class NGOVerificationViewController: UIViewController {
    
    @IBOutlet weak var pendingTableView: UITableView!
    @IBOutlet weak var verifiedTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var pendingNGOs: [NGOApplication] = []
    private var verifiedNGOs: [NGO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNGOData()
    }
    
    private func setupUI() {
        title = "NGO Verification"
        
        segmentedControl.setTitle("Pending (\(pendingNGOs.count))", forSegmentAt: 0)
        segmentedControl.setTitle("Verified (\(verifiedNGOs.count))", forSegmentAt: 1)
        
        pendingTableView.delegate = self
        pendingTableView.dataSource = self
        verifiedTableView.delegate = self
        verifiedTableView.dataSource = self
        
        updateTableVisibility()
    }
    
    private func loadNGOData() {
        // Mock pending applications
        pendingNGOs = [
            NGOApplication(id: "1", name: "New Hope Foundation", email: "contact@newhope.org", documents: ["Registration Certificate", "Tax Exemption"], submissionDate: Date()),
            NGOApplication(id: "2", name: "Community Kitchen", email: "info@communitykitchen.org", documents: ["Registration Certificate"], submissionDate: Date())
        ]
        
        // Mock verified NGOs
        verifiedNGOs = [
            NGO(id: "1", name: "Food Bank Network", description: "Distributing food to communities", contactEmail: "contact@foodbank.org", contactPhone: "+1234567890", address: "123 Main St", isVerified: true, registrationDate: Date(), logoURL: nil, totalDonationsReceived: 150)
        ]
        
        updateSegmentTitles()
        pendingTableView.reloadData()
        verifiedTableView.reloadData()
    }
    
    private func updateSegmentTitles() {
        segmentedControl.setTitle("Pending (\(pendingNGOs.count))", forSegmentAt: 0)
        segmentedControl.setTitle("Verified (\(verifiedNGOs.count))", forSegmentAt: 1)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateTableVisibility()
    }
    
    private func updateTableVisibility() {
        pendingTableView.isHidden = segmentedControl.selectedSegmentIndex != 0
        verifiedTableView.isHidden = segmentedControl.selectedSegmentIndex != 1
    }
}

extension NGOVerificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == pendingTableView {
            return pendingNGOs.count
        } else {
            return verifiedNGOs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NGOCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "NGOCell")
        
        if tableView == pendingTableView {
            let ngo = pendingNGOs[indexPath.row]
            cell.textLabel?.text = ngo.name
            cell.detailTextLabel?.text = "\(ngo.email) • \(ngo.documents.count) documents"
            cell.imageView?.image = UIImage(systemName: "clock.fill")
            cell.imageView?.tintColor = .systemOrange
        } else {
            let ngo = verifiedNGOs[indexPath.row]
            cell.textLabel?.text = ngo.name
            cell.detailTextLabel?.text = "\(ngo.contactEmail) • \(ngo.totalDonationsReceived) donations"
            cell.imageView?.image = UIImage(systemName: "checkmark.seal.fill")
            cell.imageView?.tintColor = .primaryGreen
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == pendingTableView {
            let ngo = pendingNGOs[indexPath.row]
            showVerificationOptions(for: ngo, at: indexPath)
        } else {
            let ngo = verifiedNGOs[indexPath.row]
            showVerifiedNGOOptions(for: ngo)
        }
    }
    
    private func showVerificationOptions(for ngo: NGOApplication, at indexPath: IndexPath) {
        let alert = UIAlertController(title: ngo.name, message: "Review NGO Application", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View Documents", style: .default) { _ in
            self.showDocuments(for: ngo)
        })
        
        alert.addAction(UIAlertAction(title: "Approve", style: .default) { _ in
            self.approveNGO(ngo, at: indexPath)
        })
        
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive) { _ in
            self.rejectNGO(ngo, at: indexPath)
        })
        
        alert.addAction(UIAlertAction(title: "Request More Documents", style: .default) { _ in
            self.requestMoreDocuments(for: ngo)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showVerifiedNGOOptions(for ngo: NGO) {
        let alert = UIAlertController(title: ngo.name, message: "Verified NGO Options", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View Profile", style: .default) { _ in
            self.showNGOProfile(ngo)
        })
        
        alert.addAction(UIAlertAction(title: "Revoke Verification", style: .destructive) { _ in
            self.revokeVerification(for: ngo)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showDocuments(for ngo: NGOApplication) {
        let message = "Documents submitted:\n" + ngo.documents.joined(separator: "\n• ")
        let alert = UIAlertController(title: "Documents", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
    
    private func approveNGO(_ ngo: NGOApplication, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Approve NGO", message: "Approve \(ngo.name) for verification?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Approve", style: .default) { _ in
            // Move to verified list
            let verifiedNGO = NGO(id: ngo.id, name: ngo.name, description: "Verified NGO", contactEmail: ngo.email, contactPhone: "", address: "", isVerified: true, registrationDate: Date(), logoURL: nil, totalDonationsReceived: 0)
            
            self.verifiedNGOs.append(verifiedNGO)
            self.pendingNGOs.remove(at: indexPath.row)
            
            self.updateSegmentTitles()
            self.pendingTableView.deleteRows(at: [indexPath], with: .fade)
            self.verifiedTableView.reloadData()
            
            self.showAlert(message: "\(ngo.name) has been approved and verified")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func rejectNGO(_ ngo: NGOApplication, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Reject Application", message: "Provide reason for rejection:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Reason for rejection"
        }
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive) { _ in
            self.pendingNGOs.remove(at: indexPath.row)
            self.updateSegmentTitles()
            self.pendingTableView.deleteRows(at: [indexPath], with: .fade)
            self.showAlert(message: "\(ngo.name) application has been rejected")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func requestMoreDocuments(for ngo: NGOApplication) {
        showAlert(message: "Document request sent to \(ngo.name)")
    }
    
    private func showNGOProfile(_ ngo: NGO) {
        let message = "Name: \(ngo.name)\nEmail: \(ngo.contactEmail)\nTotal Donations: \(ngo.totalDonationsReceived)\nVerified: \(ngo.isVerified ? "Yes" : "No")"
        let alert = UIAlertController(title: "NGO Profile", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
    
    private func revokeVerification(for ngo: NGO) {
        let alert = UIAlertController(title: "Revoke Verification", message: "Are you sure you want to revoke verification for \(ngo.name)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Revoke", style: .destructive) { _ in
            self.showAlert(message: "Verification revoked for \(ngo.name)")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Action Complete", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

struct NGOApplication {
    let id: String
    let name: String
    let email: String
    let documents: [String]
    let submissionDate: Date
}