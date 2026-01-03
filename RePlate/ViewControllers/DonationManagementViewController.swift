import UIKit

class DonationManagementViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var headerView: UIView!
    private var searchBar: UIView!
    private var statsContainer: UIView!
    private var donationListContainer: UIView!
    
    private let donations = [
        Donation(id: "1", title: "Box of Assorted Pastries", donor: "Corner Bakery", type: "Cooked Meals", status: .active, timeAgo: "2 hours ago", claimCount: 3, imageURL: nil),
        Donation(id: "2", title: "Fresh Organic Vegetables", donor: "Green Market", type: "Fresh Produce", status: .active, timeAgo: "5 hours ago", claimCount: 1, imageURL: nil),
        Donation(id: "3", title: "Home-cooked Indian Dinner", donor: "Priya's Kitchen", type: "Cooked Meals", status: .claimed, timeAgo: "1 day ago", claimCount: 1, imageURL: nil),
        Donation(id: "4", title: "Deli Sandwiches", donor: "Downtown Deli", type: "Cooked Meals", status: .expired, timeAgo: "2 days ago", claimCount: 0, imageURL: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Apply main container shadow and corner radius as per CSS
        view.layer.cornerRadius = 30
        ShadowHelper.applyMainContainerShadow(to: view)
        
        setupScrollView()
        setupHeader()
        setupSearchBar()
        setupStatsCards()
        setupDonationList()
        setupBottomTabBar()
        setupHomeIndicator()
    }
    
    private func setupScrollView() {
        // Main container scroll view as per CSS: position: absolute; width: 430px; height: 608px; top: 210px; overflow: scroll;
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 210, width: 430, height: 608)
        scrollView.contentSize = CGSize(width: 430, height: 504)
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 430, height: 504)
        scrollView.addSubview(contentView)
    }
    
    private func setupHeader() {
        // Header Section (206.67px height) with background #357B49
        headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: 430, height: 206.67)
        headerView.backgroundColor = .donationHeaderGreen
        view.addSubview(headerView)
        
        // Status bar with time (17px, SF Pro, 590 weight)
        let timeLabel = UILabel()
        timeLabel.text = "9:41"
        timeLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(590/1000))
        timeLabel.textColor = .white
        timeLabel.frame = CGRect(x: 20, y: 44, width: 50, height: 20)
        headerView.addSubview(timeLabel)
        
        // Battery and signal icons (placeholder)
        let batteryLabel = UILabel()
        batteryLabel.text = "100%"
        batteryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        batteryLabel.textColor = .white
        batteryLabel.textAlignment = .right
        batteryLabel.frame = CGRect(x: 350, y: 44, width: 60, height: 20)
        headerView.addSubview(batteryLabel)
        
        // Title: "Donation Management" (30px, white) - exact spec
        let titleLabel = UILabel()
        titleLabel.text = "Donation Management"
        titleLabel.font = FontManager.largeTitle
        titleLabel.textColor = .white
        titleLabel.frame = CGRect(x: 20, y: 80, width: 390, height: 36)
        headerView.addSubview(titleLabel)
        
        // Subtitle: "Platform Overview & Management" (13.3px, white 80%) - exact spec
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Platform Overview & Management"
        subtitleLabel.font = FontManager.subheadline
        subtitleLabel.textColor = .textWhite80
        subtitleLabel.frame = CGRect(x: 20, y: 120, width: 390, height: 20)
        headerView.addSubview(subtitleLabel)
    }
    
    private func setupSearchBar() {
        // Search bar: 398x43.67px, #F9FAFB background, 14px radius - capsule shape
        searchBar = UIView()
        searchBar.frame = CGRect(x: 16, y: 150, width: 398, height: 43.67)
        searchBar.backgroundColor = .lightGray
        searchBar.layer.cornerRadius = 21.84 // Capsule shape (height/2)
        headerView.addSubview(searchBar)
        
        // Search icon (20x20px, gray)
        let searchIcon = UIImageView()
        searchIcon.frame = CGRect(x: 16, y: 11.84, width: 20, height: 20)
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .gray
        searchBar.addSubview(searchIcon)
        
        // Placeholder: "Search donations..." (14.5px, #0A0A0A at 50% opacity) - exact spec
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Search donations..."
        placeholderLabel.font = FontManager.searchPlaceholderFont
        placeholderLabel.textColor = .textSecondary
        placeholderLabel.frame = CGRect(x: 48, y: 13.34, width: 200, height: 17)
        searchBar.addSubview(placeholderLabel)
    }
    
    private func setupStatsCards() {
        // Statistics Cards Section (72px height)
        statsContainer = UIView()
        statsContainer.frame = CGRect(x: 0, y: 0, width: 430, height: 72)
        contentView.addSubview(statsContainer)
        
        let stats = [
            ("432", "Total", UIColor.greenTint, FontManager.statNumber1Font, FontManager.statLabel1Font),
            ("264", "Active", UIColor.white, FontManager.statNumber2Font, FontManager.statLabel2Font),
            ("128", "Claimed", UIColor.white, FontManager.statNumber3Font, FontManager.statLabel3Font),
            ("2", "Flagged", UIColor.redTint, FontManager.statNumber4Font, FontManager.statLabel1Font)
        ]
        
        for (index, stat) in stats.enumerated() {
            let cardView = createStatCard(
                number: stat.0,
                label: stat.1,
                backgroundColor: stat.2,
                numberFont: stat.3,
                labelFont: stat.4,
                isActive: index == 1
            )
            cardView.frame = CGRect(x: 20 + (index * (77 + 16)), y: 0, width: 77, height: 72)
            statsContainer.addSubview(cardView)
        }
    }
    
    private func createStatCard(number: String, label: String, backgroundColor: UIColor, numberFont: UIFont, labelFont: UIFont, isActive: Bool = false) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = backgroundColor
        cardView.layer.cornerRadius = 16 // Design spec: 16pt corner radius
        
        if backgroundColor == .white {
            // Subtle drop shadows (radius: 4, y: 2) as per design spec
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 4
            cardView.layer.masksToBounds = false
        }
        
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = numberFont
        numberLabel.textColor = isActive ? .donationHeaderGreen : .textPrimary
        numberLabel.textAlignment = .center
        numberLabel.frame = CGRect(x: 0, y: 16, width: 77, height: 32)
        
        let labelLabel = UILabel()
        labelLabel.text = label
        labelLabel.font = labelFont
        labelLabel.textColor = .gray
        labelLabel.textAlignment = .center
        labelLabel.frame = CGRect(x: 0, y: 48, width: 77, height: 16)
        
        cardView.addSubview(numberLabel)
        cardView.addSubview(labelLabel)
        
        return cardView
    }
    
    private func setupDonationList() {
        // Donation List Section (504px scrollable height)
        donationListContainer = UIView()
        donationListContainer.frame = CGRect(x: 0, y: 88, width: 430, height: 504)
        contentView.addSubview(donationListContainer)
        
        for (index, donation) in donations.enumerated() {
            let cardView = createDonationCard(donation: donation, index: index)
            cardView.frame = CGRect(x: 23.67, y: index * 128, width: 382.67, height: 112)
            donationListContainer.addSubview(cardView)
        }
    }
    
    private func createDonationCard(donation: Donation, index: Int) -> UIView {
        let cardView = DonationCardView()
        cardView.configure(with: donation, index: index)
        // Load image if available
        cardView.loadImage(from: donation.imageURL)
        return cardView
    }
    
    private func setupHomeIndicator() {
        // Home indicator: 144x5px black rounded bar at bottom
        let homeIndicator = UIView()
        homeIndicator.frame = CGRect(x: 143, y: 915, width: 144, height: 5)
        homeIndicator.backgroundColor = .black
        homeIndicator.layer.cornerRadius = 2.5
        view.addSubview(homeIndicator)
    }
    
    private func setupBottomTabBar() {
        // Bottom Tab Bar (51px height) - Standard UITabBar appearance with specific icon tinting
        let tabBarView = UIView()
        tabBarView.frame = CGRect(x: 0, y: 881, width: 430, height: 51)
        tabBarView.backgroundColor = .white
        tabBarView.layer.borderTopWidth = 0.67
        tabBarView.layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1).cgColor
        
        let tabTitles = ["Dashboard", "Users", "Donations", "NGOs", "Settings"]
        let tabIcons = ["house.fill", "person.2.fill", "box.fill", "building.2.fill", "gearshape.fill"]
        
        for (index, title) in tabTitles.enumerated() {
            let tabButton = UIButton()
            tabButton.frame = CGRect(x: CGFloat(index) * 86, y: 4, width: 86, height: 43)
            
            // Icons are 24x24px with 2px border as per design spec
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
            let icon = UIImage(systemName: tabIcons[index], withConfiguration: config)
            tabButton.setImage(icon, for: .normal)
            tabButton.setTitle(title, for: .normal)
            
            // Standard UITabBar appearance with specific icon tinting (.accentColor(Color.green))
            if index == 2 { // Donations tab selected
                tabButton.tintColor = .primaryGreen // Use primary green for accent color
                tabButton.setTitleColor(.primaryGreen, for: .normal)
            } else {
                tabButton.tintColor = .tabUnselected // #99A1AF
                tabButton.setTitleColor(.tabTextUnselected, for: .normal) // #6A7282
            }
            
            tabButton.titleLabel?.font = UIFont.systemFont(ofSize: 9.5, weight: .regular)
            tabButton.imageView?.contentMode = .scaleAspectFit
            tabButton.titleLabel?.textAlignment = .center
            
            // Arrange icon above text
            tabButton.titleEdgeInsets = UIEdgeInsets(top: 8, left: -24, bottom: -8, right: 0)
            tabButton.imageEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: -tabButton.titleLabel!.intrinsicContentSize.width)
            
            tabBarView.addSubview(tabButton)
        }
        
        view.addSubview(tabBarView)
    }
}