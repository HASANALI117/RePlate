import UIKit

class SearchBarView: UIView {
    
    private let searchIcon = UIImageView()
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 14
        
        // Search icon setup
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        
        // Text field setup
        textField.placeholder = "Search donations..."
        textField.font = FontManager.searchPlaceholderFont
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        
        addSubview(searchIcon)
        addSubview(textField)
        
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: controlEvents)
    }
}