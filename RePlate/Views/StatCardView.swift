import UIKit

class StatCardView: UIView {
    
    private let numberLabel = UILabel()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        
        addSubview(numberLabel)
        addSubview(titleLabel)
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            numberLabel.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        numberLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        titleLabel.textColor = .gray
    }
    
    func configure(number: String, title: String, numberFont: UIFont, titleFont: UIFont, numberColor: UIColor, backgroundColor: UIColor) {
        numberLabel.text = number
        titleLabel.text = title
        numberLabel.font = numberFont
        titleLabel.font = titleFont
        numberLabel.textColor = numberColor
        self.backgroundColor = backgroundColor
        
        if backgroundColor == .white {
            ShadowHelper.applyCardShadow(to: self)
        }
    }
}