import UIKit

class DisputeResolutionViewController: UIViewController {
    
    @IBOutlet weak var disputesTableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    private var disputes: [Dispute] = []
    private var filteredDisputes: [Dispute] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDisputes()
    }
    
    private func setupUI() {
        title = "Dispute Resolution"
        
        filterSegmentedControl.setTitle("All", forSegmentAt: 0)
        filterSegmentedControl.setTitle("Open", forSegmentAt: 1)
        filterSegmentedControl.setTitle("Resolved", forSegmentAt: 2)
        
        disputesTableView.delegate = self
        disputesTableView.dataSource = self
    }
    
    private func loadDisputes() {
        disputes = [
            Dispute(id: "1", donationId: "d1", reporterName: "John Doe", reportedUserName: "Jane Smith", reason: "Food quality issue", description: "The donated food was spoiled", status: .open, createdDate: Date(), resolvedDate: nil),
            Dispute(id: "2", donationId: "d2", reporterName: "NGO Helper", reportedUserName: "Bob Wilson", reason: "No-show for pickup", description: "Donor didn't show up at agreed time", status: .open, createdDate: Date(), resolvedDate: nil),
            Dispute(id: "3", donationId: "d3", reporterName: "Community Kitchen", reportedUserName: "Alice Brown", reason: "Inappropriate content", description: "Donation post contained inappropriate images", status: .resolved, createdDate: Date(), resolvedDate: Date())
        ]
        filteredDisputes = disputes
        disputesTableView.reloadData()
    }
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: filteredDisputes = disputes
        case 1: filteredDisputes = disputes.filter { $0.status == .open }
        case 2: filteredDisputes = disputes.filter { $0.status == .resolved }
        default: filteredDisputes = disputes
        }
        disputesTableView.reloadData()
    }
}

extension DisputeResolutionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDisputes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisputeCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "DisputeCell")
        let dispute = filteredDisputes[indexPath.row]
        
        cell.textLabel?.text = dispute.reason
        cell.detailTextLabel?.text = "\(dispute.reporterName) vs \(dispute.reportedUserName)"
        
        switch dispute.status {
        case .open:
            cell.imageView?.image = UIImage(systemName: "exclamationmark.triangle.fill")
            cell.imageView?.tintColor = .systemRed
        case .inProgress:
            cell.imageView?.image = UIImage(systemName: "clock.fill")
            cell.imageView?.tintColor = .systemOrange
        case .resolved:
            cell.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            cell.imageView?.tintColor = .primaryGreen
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dispute = filteredDisputes[indexPath.row]
        showDisputeDetails(dispute, at: indexPath)
    }
    
    private func showDisputeDetails(_ dispute: Dispute, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Dispute Details", message: "\(dispute.reason)\n\nReporter: \(dispute.reporterName)\nReported User: \(dispute.reportedUserName)\n\nDescription: \(dispute.description)\n\nStatus: \(dispute.status.rawValue.capitalized)", preferredStyle: .alert)
        
        if dispute.status == .open {
            alert.addAction(UIAlertAction(title: "Start Investigation", style: .default) { _ in
                self.startInvestigation(dispute, at: indexPath)
            })
            
            alert.addAction(UIAlertAction(title: "Resolve - Warning Issued", style: .default) { _ in
                self.resolveWithWarning(dispute, at: indexPath)
            })
            
            alert.addAction(UIAlertAction(title: "Resolve - No Action", style: .default) { _ in
                self.resolveNoAction(dispute, at: indexPath)
            })
            
            alert.addAction(UIAlertAction(title: "Escalate", style: .destructive) { _ in
                self.escalateDispute(dispute)
            })
        }
        
        alert.addAction(UIAlertAction(title: "View Evidence", style: .default) { _ in
            self.viewEvidence(dispute)
        })
        
        alert.addAction(UIAlertAction(title: "Contact Users", style: .default) { _ in
            self.contactUsers(dispute)
        })
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func startInvestigation(_ dispute: Dispute, at indexPath: IndexPath) {
        // Update dispute status
        filteredDisputes[indexPath.row].status = .inProgress
        disputesTableView.reloadRows(at: [indexPath], with: .none)
        showAlert(message: "Investigation started for dispute #\(dispute.id)")
    }
    
    private func resolveWithWarning(_ dispute: Dispute, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Resolve Dispute", message: "Issue warning to \(dispute.reportedUserName)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Issue Warning", style: .default) { _ in
            self.filteredDisputes[indexPath.row].status = .resolved
            self.filteredDisputes[indexPath.row].resolvedDate = Date()
            self.disputesTableView.reloadRows(at: [indexPath], with: .none)
            self.showAlert(message: "Warning issued to \(dispute.reportedUserName). Dispute resolved.")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func resolveNoAction(_ dispute: Dispute, at indexPath: IndexPath) {
        filteredDisputes[indexPath.row].status = .resolved
        filteredDisputes[indexPath.row].resolvedDate = Date()
        disputesTableView.reloadRows(at: [indexPath], with: .none)
        showAlert(message: "Dispute resolved with no action required.")
    }
    
    private func escalateDispute(_ dispute: Dispute) {
        showAlert(message: "Dispute #\(dispute.id) has been escalated to senior management.")
    }
    
    private func viewEvidence(_ dispute: Dispute) {
        let alert = UIAlertController(title: "Evidence", message: "Evidence for dispute #\(dispute.id):\n\n• Screenshots attached\n• Chat logs available\n• Pickup confirmation missing", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
    
    private func contactUsers(_ dispute: Dispute) {
        let alert = UIAlertController(title: "Contact Users", message: "Send message to involved parties?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Message to send..."
        }
        alert.addAction(UIAlertAction(title: "Send", style: .default) { _ in
            self.showAlert(message: "Message sent to \(dispute.reporterName) and \(dispute.reportedUserName)")
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

struct Dispute {
    let id: String
    let donationId: String
    let reporterName: String
    let reportedUserName: String
    let reason: String
    let description: String
    var status: DisputeStatus
    let createdDate: Date
    var resolvedDate: Date?
}

enum DisputeStatus: String, CaseIterable {
    case open = "open"
    case inProgress = "in_progress"
    case resolved = "resolved"
}