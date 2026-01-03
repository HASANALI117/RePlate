import UIKit

class DonationGridCollectionViewController: UICollectionViewController {
    
    private var donations: [Donation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadTestData()
        FirebaseManager.shared.logScreenView("DonationGrid")
    }
    
    private func setupCollectionView() {
        title = "Donations Grid"
        
        // Register cell
        collectionView.register(DonationCollectionViewCell.self, forCellWithReuseIdentifier: "DonationCell")
        
        // Setup layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        // Adaptive sizing for iPad
        let itemsPerRow: CGFloat = UniversalLayoutHelper.isIPad() ? 3 : 2
        let totalSpacing = (itemsPerRow - 1) * layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (view.frame.width - totalSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .systemBackground
    }
    
    private func loadTestData() {
        donations = [
            Donation(id: "1", title: "Fresh Vegetables", donor: "Green Market", type: "Fresh Produce", status: .active, timeAgo: "2h ago", claimCount: 2),
            Donation(id: "2", title: "Bakery Items", donor: "Corner Bakery", type: "Cooked Meals", status: .active, timeAgo: "4h ago", claimCount: 1),
            Donation(id: "3", title: "Lunch Boxes", donor: "Office Cafeteria", type: "Cooked Meals", status: .claimed, timeAgo: "1d ago", claimCount: 3),
            Donation(id: "4", title: "Expired Bread", donor: "Local Store", type: "Bakery", status: .expired, timeAgo: "3d ago", claimCount: 0)
        ]
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DonationCell", for: indexPath) as! DonationCollectionViewCell
        cell.configure(with: donations[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let donation = donations[indexPath.item]
        showDonationDetails(donation)
    }
    
    private func showDonationDetails(_ donation: Donation) {
        let alert = UIAlertController(title: donation.title, message: "Status: \(donation.status.displayText)\nClaims: \(donation.claimCount)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
}

class DonationCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primaryGreen
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(statusLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            statusLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with donation: Donation) {
        imageView.image = UIImage(systemName: "box.fill")
        titleLabel.text = donation.title
        statusLabel.text = donation.status.displayText
        statusLabel.textColor = donation.status.color
        statusLabel.backgroundColor = donation.status.color.withAlphaComponent(0.1)
        imageView.tintColor = donation.iconColor
    }
}