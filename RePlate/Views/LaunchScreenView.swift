import UIKit

class LaunchScreenView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLaunchScreen()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLaunchScreen()
    }
    
    private func setupLaunchScreen() {
        backgroundColor = .primaryGreen
        
        // App logo
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(systemName: "leaf.fill")
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        
        // App name
        let appNameLabel = UILabel()
        appNameLabel.text = "RePlate"
        appNameLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        
        // Tagline
        let taglineLabel = UILabel()
        taglineLabel.text = "Reducing Food Waste, One Meal at a Time"
        taglineLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        taglineLabel.textColor = .textWhite80
        taglineLabel.textAlignment = .center
        
        addSubview(logoImageView)
        addSubview(appNameLabel)
        addSubview(taglineLabel)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taglineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            taglineLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 8),
            taglineLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            taglineLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            taglineLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
}