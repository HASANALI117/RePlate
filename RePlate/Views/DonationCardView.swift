import UIKit
import SDWebImage

class DonationCardView: UIView {
    
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusLabel = UILabel()
    private let detailsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        setupIconContainer()
        setupLabels()
        setupConstraints()
    }
    
    private func setupIconContainer() {
        iconContainer.layer.cornerRadius = 20
        iconContainer.addSubview(iconImageView)
        
        iconImageView.image = UIImage(systemName: "box.fill")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        
        addSubview(iconContainer)
    }
    
    private func setupLabels() {
        titleLabel.font = FontManager.donationTitle1Font
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        subtitleLabel.font = FontManager.donationSubtitle1Font
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        
        statusLabel.font = FontManager.status1Font
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        statusLabel.textAlignment = .center
        statusLabel.backgroundColor = UIColor.clear
        
        detailsLabel.font = FontManager.details1Font
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.numberOfLines = 1
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(statusLabel)
        addSubview(detailsLabel)
    }
    
    private func setupConstraints() {
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            statusLabel.heightAnchor.constraint(equalToConstant: 16),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            detailsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            detailsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailsLabel.heightAnchor.constraint(equalToConstant: 20),
            detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with donation: Donation, index: Int) {
        titleLabel.text = donation.title
        switch index {
        case 0: titleLabel.font = FontManager.donationTitle1Font
        case 1: titleLabel.font = FontManager.donationTitle2Font
        default: titleLabel.font = FontManager.donationTitle1Font
        }
        
        subtitleLabel.text = "Donated by \(donation.donor)"
        switch index {
        case 0: subtitleLabel.font = FontManager.donationSubtitle1Font
        case 1: subtitleLabel.font = FontManager.donationSubtitle2Font
        case 2: subtitleLabel.font = FontManager.donationSubtitle3Font
        case 3: subtitleLabel.font = FontManager.donationSubtitle4Font
        default: subtitleLabel.font = FontManager.donationSubtitle1Font
        }
        
        statusLabel.text = "  \(donation.status.displayText)  "
        statusLabel.textColor = donation.status.color
        statusLabel.font = index == 0 ? FontManager.status1Font : FontManager.status2Font
        
        switch donation.status {
        case .active:
            statusLabel.backgroundColor = UIColor(red: 0/255, green: 166/255, blue: 62/255, alpha: 0.1)
        case .claimed:
            statusLabel.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 0.1)
        case .expired:
            statusLabel.backgroundColor = UIColor(red: 153/255, green: 161/255, blue: 175/255, alpha: 0.1)
        case .flagged:
            statusLabel.backgroundColor = UIColor(red: 255/255, green: 56/255, blue: 60/255, alpha: 0.1)
        }
        
        let claimsText = donation.claimCount == 1 ? "claim" : "claims"
        detailsLabel.text = "\(donation.type) • \(donation.timeAgo) • \(donation.claimCount) \(claimsText)"
        switch index {
        case 0: detailsLabel.font = FontManager.details1Font
        case 1: detailsLabel.font = FontManager.details2Font
        case 2: detailsLabel.font = FontManager.details3Font
        case 3: detailsLabel.font = FontManager.details4Font
        default: detailsLabel.font = FontManager.details1Font
        }
        
        iconContainer.layer.cornerRadius = 20
        switch donation.status {
        case .active:
            iconContainer.backgroundColor = UIColor.greenTint
            iconImageView.tintColor = UIColor.primaryGreen
        case .claimed:
            iconContainer.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 0.1)
            iconImageView.tintColor = UIColor.codGray
        case .expired:
            iconContainer.backgroundColor = UIColor(red: 153/255, green: 161/255, blue: 175/255, alpha: 0.1)
            iconImageView.tintColor = UIColor.grayChateau
        case .flagged:
            iconContainer.backgroundColor = UIColor.redTint
            iconImageView.tintColor = UIColor.statusFlagged
        }
    }
    
    // MARK: - Image Loading with SDWebImage
    func loadImage(from url: String?) {
        guard let urlString = url, let imageURL = URL(string: urlString) else {
            iconImageView.image = UIImage(systemName: "box.fill")
            return
        }
        
        iconImageView.sd_setImage(
            with: imageURL,
            placeholderImage: UIImage(systemName: "box.fill"),
            options: [.progressiveLoad, .retryFailed],
            completed: { [weak self] (image, error, cacheType, url) in
                if error != nil {
                    self?.iconImageView.image = UIImage(systemName: "box.fill")
                }
            }
        )
    }
}