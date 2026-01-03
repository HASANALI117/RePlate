import UIKit
import SDWebImage

class DonationListTableViewController: UITableViewController {
    
    private var donations: [Donation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadDonations()
        FirebaseManager.shared.logScreenView("DonationList")
    }
    
    private func setupTableView() {
        title = "All Donations"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DonationCell")
        tableView.backgroundColor = .systemBackground
        
        // Add refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        loadDonations()
    }
    
    private func loadDonations() {
        FirebaseManager.shared.fetchDonations { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                switch result {
                case .success(let donations):
                    self?.donations = donations
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath)
        let donation = donations[indexPath.row]
        
        cell.textLabel?.text = donation.title
        cell.detailTextLabel?.text = "\(donation.type) • \(donation.timeAgo)"
        
        // Load image with SDWebImage if available, otherwise use default icon
        if let imageURL = donation.imageURL, let url = URL(string: imageURL) {
            cell.imageView?.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "box.fill"),
                options: [.progressiveLoad, .retryFailed]
            ) { (image, error, cacheType, url) in
                if error != nil {
                    cell.imageView?.image = UIImage(systemName: "box.fill")
                    cell.imageView?.tintColor = donation.iconColor
                }
            }
        } else {
            cell.imageView?.image = UIImage(systemName: "box.fill")
            cell.imageView?.tintColor = donation.iconColor
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let donation = donations[indexPath.row]
        showDonationDetails(donation)
    }
    
    private func showDonationDetails(_ donation: Donation) {
        let alert = UIAlertController(title: donation.title, message: "Donor: \(donation.donor)\nStatus: \(donation.status.displayText)\nClaims: \(donation.claimCount)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
}