import UIKit

class TabBarView: UIView {
    
    private var tabButtons: [UIButton] = []
    private var selectedIndex: Int = 0
    
    var onTabSelected: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        let tabData = [
            ("Dashboard", "house.fill", FontManager.tab1Font),
            ("Users", "person.2.fill", FontManager.tab2Font),
            ("Donations", "box.fill", FontManager.tab3Font),
            ("NGOs", "building.2.fill", FontManager.tab4Font),
            ("Settings", "gearshape.fill", FontManager.tab1Font)
        ]
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        for (index, (title, iconName, font)) in tabData.enumerated() {
            let button = createTabButton(title: title, iconName: iconName, font: font, index: index)
            tabButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createTabButton(title: String, iconName: String, font: UIFont, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        
        // Tab bar with 5 equal-width buttons (82.8px each)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        button.setImage(icon, for: .normal)
        
        // Arrange icon above text
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.textAlignment = .center
        button.contentVerticalAlignment = .center
        
        // Set initial colors (unselected state)
        button.tintColor = .tabUnselected // #99A1AF
        button.setTitleColor(.tabTextUnselected, for: .normal) // #6A7282
        
        button.tag = index
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        
        // Adjust button layout
        if let imageView = button.imageView, let titleLabel = button.titleLabel {
            button.titleEdgeInsets = UIEdgeInsets(top: 8, left: -imageView.frame.width, bottom: -8, right: 0)
            button.imageEdgeInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: -titleLabel.frame.width)
        }
        
        return button
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        selectTab(at: sender.tag)
        onTabSelected?(sender.tag)
    }
    
    func selectTab(at index: Int) {
        guard index >= 0 && index < tabButtons.count else { return }
        
        // Update previous selected tab to unselected state
        let previousButton = tabButtons[selectedIndex]
        previousButton.tintColor = .tabUnselected
        previousButton.setTitleColor(.tabTextUnselected, for: .normal)
        
        // Update new selected tab
        selectedIndex = index
        let selectedButton = tabButtons[selectedIndex]
        selectedButton.tintColor = .tabSelected // #2E8B57
        selectedButton.setTitleColor(.tabSelected, for: .normal)
    }
}