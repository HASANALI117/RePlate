import UIKit

class YourImpactViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var statsStackView: UIStackView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var achievementsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStats()
        setupChart()
        setupAchievements()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Header styling - rounded bottom corners on the green container (approx. 30pt radius)
        headerView.backgroundColor = .primaryGreen
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        titleLabel.text = "Your Impact"
        titleLabel.font = FontManager.largeTitle // .largeTitle weight .bold
        titleLabel.textColor = .white
        
        subtitleLabel.text = "See how you're making a difference"
        subtitleLabel.font = FontManager.subheadline // .subheadline color .secondary
        subtitleLabel.textColor = .textWhite80
    }
    
    private func setupStats() {
        // Clear existing arranged subviews
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let stats = [
            ("Donations Made", "24", .primaryGreen),
            ("People Helped", "140", .secondaryGreen),
            ("Food Rescued", "287 lbs", .primaryGreen),
            ("Impact Score", "95 - Top 10%", .secondaryGreen)
        ]
        
        for (title, value, color) in stats {
            let statCard = createStatCard(title: title, value: value, color: color)
            statsStackView.addArrangedSubview(statCard)
        }
    }
    
    private func createStatCard(title: String, value: String, color: UIColor) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16 // Design spec: 16pt corner radius
        // Subtle drop shadows (radius: 4, y: 2) as per design spec
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.masksToBounds = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = FontManager.subheadline // .subheadline color .secondary
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = FontManager.headline // .title2 or .headline weight .semibold
        valueLabel.textColor = color
        valueLabel.textAlignment = .center
        valueLabel.numberOfLines = 0
        
        // Add green checkmark for positive trends
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = .greenHaze
        checkmarkImageView.contentMode = .scaleAspectFit
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(valueLabel)
        cardView.addSubview(checkmarkImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            
            checkmarkImageView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 8),
            checkmarkImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 16),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 16),
            checkmarkImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
        
        return cardView
    }
    
    private func setupChart() {
        chartView.backgroundColor = .lightGray
        chartView.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = "Monthly Trend (Jan-Apr)"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .textPrimary
        
        // Simple bar chart representation
        let chartContainer = UIView()
        chartContainer.backgroundColor = .clear
        
        let months = ["Jan", "Feb", "Mar", "Apr"]
        let values = [0.4, 0.6, 0.5, 0.9] // Relative heights for 4, 6, 5, 9 donations
        
        for (index, month) in months.enumerated() {
            let barContainer = UIView()
            
            let bar = UIView()
            bar.backgroundColor = .primaryGreen
            bar.layer.cornerRadius = 8 // Thick, rounded linear bars
            
            let monthLabel = UILabel()
            monthLabel.text = month
            monthLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            monthLabel.textColor = .gray
            monthLabel.textAlignment = .center
            
            barContainer.addSubview(bar)
            barContainer.addSubview(monthLabel)
            chartContainer.addSubview(barContainer)
            
            barContainer.translatesAutoresizingMaskIntoConstraints = false
            bar.translatesAutoresizingMaskIntoConstraints = false
            monthLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                barContainer.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: CGFloat(index * 60) + 20),
                barContainer.topAnchor.constraint(equalTo: chartContainer.topAnchor),
                barContainer.widthAnchor.constraint(equalToConstant: 40),
                barContainer.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor),
                
                bar.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
                bar.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor),
                bar.bottomAnchor.constraint(equalTo: monthLabel.topAnchor, constant: -8),
                bar.heightAnchor.constraint(equalTo: barContainer.heightAnchor, multiplier: values[index] * 0.6),
                
                monthLabel.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
                monthLabel.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor),
                monthLabel.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
                monthLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        chartView.addSubview(titleLabel)
        chartView.addSubview(chartContainer)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -16),
            
            chartContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            chartContainer.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
            chartContainer.trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
            chartContainer.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupAchievements() {
        achievementsView.backgroundColor = .lightGray
        achievementsView.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = "Achievements"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .textPrimary
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Coming soon..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        placeholderLabel.textColor = .gray
        
        achievementsView.addSubview(titleLabel)
        achievementsView.addSubview(placeholderLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: achievementsView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: achievementsView.leadingAnchor, constant: 16),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: achievementsView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: achievementsView.centerYAnchor)
        ])
    }
}