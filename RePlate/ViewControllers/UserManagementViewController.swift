import UIKit

class UserManagementViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usersTableView: UITableView!
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUsers()
    }
    
    private func setupUI() {
        title = "User Management"
        
        filterSegmentedControl.setTitle("All", forSegmentAt: 0)
        filterSegmentedControl.setTitle("Donors", forSegmentAt: 1)
        filterSegmentedControl.setTitle("NGOs", forSegmentAt: 2)
        filterSegmentedControl.setTitle("Suspended", forSegmentAt: 3)
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func loadUsers() {
        // Mock user data
        users = [
            User(id: "1", name: "John Donor", email: "john@example.com", role: .donor, isActive: true, joinDate: Date(), profileImageURL: nil),
            User(id: "2", name: "Hope Foundation", email: "contact@hope.org", role: .ngo, isActive: true, joinDate: Date(), profileImageURL: nil),
            User(id: "3", name: "Admin User", email: "admin@replate.com", role: .admin, isActive: true, joinDate: Date(), profileImageURL: nil)
        ]
        filteredUsers = users
        usersTableView.reloadData()
    }
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: filteredUsers = users
        case 1: filteredUsers = users.filter { $0.role == .donor }
        case 2: filteredUsers = users.filter { $0.role == .ngo }
        case 3: filteredUsers = users.filter { !$0.isActive }
        default: filteredUsers = users
        }
        usersTableView.reloadData()
    }
}

extension UserManagementViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "UserCell")
        let user = filteredUsers[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(user.role.displayName) • \(user.email)"
        cell.imageView?.image = UIImage(systemName: user.isActive ? "person.circle.fill" : "person.slash.fill")
        cell.imageView?.tintColor = user.isActive ? .primaryGreen : .systemRed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = filteredUsers[indexPath.row]
        showUserActions(for: user)
    }
    
    private func showUserActions(for user: User) {
        let alert = UIAlertController(title: user.name, message: "Select an action", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View Profile", style: .default) { _ in
            self.showUserProfile(user)
        })
        
        if user.isActive {
            alert.addAction(UIAlertAction(title: "Suspend User", style: .destructive) { _ in
                self.suspendUser(user)
            })
        } else {
            alert.addAction(UIAlertAction(title: "Reactivate User", style: .default) { _ in
                self.reactivateUser(user)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Send Warning", style: .default) { _ in
            self.sendWarning(to: user)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showUserProfile(_ user: User) {
        let alert = UIAlertController(title: "User Profile", message: "Name: \(user.name)\nEmail: \(user.email)\nRole: \(user.role.displayName)\nStatus: \(user.isActive ? "Active" : "Suspended")\nJoined: \(DateFormatter.localizedString(from: user.joinDate, dateStyle: .medium, timeStyle: .none))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
    
    private func suspendUser(_ user: User) {
        let alert = UIAlertController(title: "Suspend User", message: "Are you sure you want to suspend \(user.name)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Suspend", style: .destructive) { _ in
            // Update user status
            self.showAlert(message: "User \(user.name) has been suspended")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func reactivateUser(_ user: User) {
        showAlert(message: "User \(user.name) has been reactivated")
    }
    
    private func sendWarning(to user: User) {
        showAlert(message: "Warning sent to \(user.name)")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Action Complete", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension UserManagementViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { user in
                user.name.lowercased().contains(searchText.lowercased()) ||
                user.email.lowercased().contains(searchText.lowercased())
            }
        }
        usersTableView.reloadData()
    }
}