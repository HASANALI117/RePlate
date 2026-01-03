import UIKit

class AdminDashboardViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var metricsStackView: UIStackView!
    @IBOutlet weak var pendingActionsView: UIView!
    @IBOutlet weak var recentActivityView: UIView!
    @IBOutlet weak var quickActionsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMetrics()
        setupPendingActions()
        setupRecentActivity()
        setupQuickActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        headerView.backgroundColor = .primaryGreen
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        titleLabel.text = "Admin Dashboard"
        titleLabel.font = FontManager.largeTitle
        titleLabel.textColor = .white
        
        subtitleLabel.text = "Platform Overview & Management"
        subtitleLabel.font = FontManager.subheadline
        subtitleLabel.textColor = .textWhite80
    }
    
    private func setupMetrics() {
        // Clear existing arranged subviews
        metricsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let metrics = [
            ("Total Users", "2,847", .primaryGreen),
            ("Active Donations", "432", .secondaryGreen),
            ("Verified NGOs", "47", .primaryGreen),
            ("Total Impact", "12.4K", .secondaryGreen)
        ]
        
        for (title, value, color) in metrics {
            let metricCard = createMetricCard(title: title, value: value, color: color)
            metricsStackView.addArrangedSubview(metricCard)
        }
    }
    
    private func createMetricCard(title: String, value: String, color: UIColor) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.masksToBounds = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = FontManager.subheadline
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = FontManager.title2
        valueLabel.textColor = color
        valueLabel.textAlignment = .center
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    private func setupPendingActions() {
        pendingActionsView.backgroundColor = .secondarySystemBackground
        pendingActionsView.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = "Pending Actions"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .textPrimary
        
        let badgeLabel = UILabel()
        badgeLabel.text = "3"
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .red
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.clipsToBounds = true
        badgeLabel.textAlignment = .center
        
        // Add action items
        let actions = [
            "New Hope Foundation: NGO Verification (2 hours ago)",
            "Flagged donation content: User Report (5 hours ago)", 
            "Community Kitchen: NGO Verification (1 day ago)"
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        for action in actions {
            let actionLabel = UILabel()
            actionLabel.text = action
            actionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            actionLabel.textColor = .gray
            actionLabel.numberOfLines = 0
            stackView.addArrangedSubview(actionLabel)
        }
        
        pendingActionsView.addSubview(titleLabel)
        pendingActionsView.addSubview(badgeLabel)
        pendingActionsView.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: pendingActionsView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: pendingActionsView.leadingAnchor, constant: 16),
            
            badgeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            badgeLabel.trailingAnchor.constraint(equalTo: pendingActionsView.trailingAnchor, constant: -16),
            badgeLabel.widthAnchor.constraint(equalToConstant: 20),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: pendingActionsView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: pendingActionsView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: pendingActionsView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupRecentActivity() {
        recentActivityView.backgroundColor = .secondarySystemBackground
        recentActivityView.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = "Recent Activity"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .textPrimary
        
        recentActivityView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: recentActivityView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: recentActivityView.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupQuickActions() {
        quickActionsView.backgroundColor = .clear
        
        let actions = [
            ("Manage Users", "person.2.fill", #selector(openUserManagement)),
            ("Review NGOs", "building.2.fill", #selector(openNGOVerification)),
            ("View Donations", "box.fill", #selector(openDonationOversight)),
            ("Resolve Disputes", "exclamationmark.triangle.fill", #selector(openDisputeResolution))
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        for i in stride(from: 0, to: actions.count, by: 2) {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 16
            rowStackView.distribution = .fillEqually
            
            let action1 = createQuickActionButton(title: actions[i].0, iconName: actions[i].1, action: actions[i].2)
            rowStackView.addArrangedSubview(action1)
            
            if i + 1 < actions.count {
                let action2 = createQuickActionButton(title: actions[i + 1].0, iconName: actions[i + 1].1, action: actions[i + 1].2)
                rowStackView.addArrangedSubview(action2)
            }
            
            stackView.addArrangedSubview(rowStackView)
        }
        
        quickActionsView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: quickActionsView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: quickActionsView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: quickActionsView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: quickActionsView.bottomAnchor)
        ])
    }
    
    private func createQuickActionButton(title: String, iconName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 12
        // Subtle drop shadows (radius: 4, y: 2) as per design spec
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        button.setImage(icon, for: .normal)
        button.setTitle(title, for: .normal)
        button.tintColor = .primaryGreen
        button.setTitleColor(.textPrimary, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        // Arrange icon above text
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.textAlignment = .center
        button.contentVerticalAlignment = .center
        
        if let imageView = button.imageView, let titleLabel = button.titleLabel {
            button.titleEdgeInsets = UIEdgeInsets(top: 8, left: -imageView.frame.width, bottom: -8, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: -titleLabel.frame.width)
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
    @objc private func openUserManagement() {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        if let userManagementVC = storyboard.instantiateViewController(withIdentifier: "UserManagementViewController") as? UserManagementViewController {
            navigationController?.pushViewController(userManagementVC, animated: true)
        }
    }
    
    @objc private func openNGOVerification() {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        if let ngoVerificationVC = storyboard.instantiateViewController(withIdentifier: "NGOVerificationViewController") as? NGOVerificationViewController {
            navigationController?.pushViewController(ngoVerificationVC, animated: true)
        }
    }
    
    @objc private func openDonationOversight() {
        // Navigate to existing donation management
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1 // Donations tab
        }
    }
    
    @objc private func openDisputeResolution() {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        if let disputeResolutionVC = storyboard.instantiateViewController(withIdentifier: "DisputeResolutionViewController") as? DisputeResolutionViewController {
            navigationController?.pushViewController(disputeResolutionVC, animated: true)
        }
    }
}