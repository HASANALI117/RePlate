import UIKit

class QuickActionButton: UIButton {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    var actionType: QuickActionType = .manageUsers
    
    enum QuickActionType {
        case manageUsers
        case reviewNGOs
        case viewDonations
        case flaggedContent
        
        var title: String {
            switch self {
            case .manageUsers: return "Manage Users"
            case .reviewNGOs: return "Review NGOs"
            case .viewDonations: return "View Donations"
            case .flaggedContent: return "Flagged Content"
            }
        }
        
        var icon: String {
            switch self {
            case .manageUsers: return "person.2.fill"
            case .reviewNGOs: return "building.2.fill"
            case .viewDonations: return "shippingbox.fill"
            case .flaggedContent: return "exclamationmark.triangle.fill"
            }
        }
        
        var iconColor: UIColor {
            switch self {
            case .manageUsers: return .dodgerBlue
            case .reviewNGOs: return .heliotrope
            case .viewDonations: return .seaGreen
            case .flaggedContent: return .redOrange
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        setupSubviews()
        setupConstraints()
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = false
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.isUserInteractionEnabled = false
        
        [iconImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with type: QuickActionType) {
        actionType = type
        titleLabel.text = type.title
        iconImageView.image = UIImage(systemName: type.icon)
        iconImageView.tintColor = type.iconColor
    }
    
    @objc private func buttonTapped() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Add scale animation
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}