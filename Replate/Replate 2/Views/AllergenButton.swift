//
//  AllergenButton.swift
//  Replate
//
//  Created on 2025-12-17.
//

import UIKit

@IBDesignable
class AllergenButton: UIButton {
    
    // MARK: - Inspectable Properties
    @IBInspectable var allergenName: String = "" {
        didSet {
            setTitle(allergenName, for: .normal)
        }
    }
    
    @IBInspectable var allergenColor: UIColor = UIColor.systemGreen {
        didSet {
            updateAppearance()
        }
    }

    // MARK: - Properties
    var allergen: Donation.AllergenInfo?

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    // MARK: - Initialization
    init(allergen: Donation.AllergenInfo) {
        self.allergen = allergen
        super.init(frame: .zero)
        self.allergenName = allergen.displayName
        self.allergenColor = getColorForAllergen(allergen)
        setupButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }

    // MARK: - Setup
    private func setupButton() {
        setTitle(allergenName, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.8
        layer.cornerRadius = 8
        heightAnchor.constraint(equalToConstant: 44).isActive = true

        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = allergen != nil ? getColorForAllergen(allergen!) : allergenColor
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = UIColor.systemGray6
            setTitleColor(.darkGray, for: .normal)
        }
    }

    private func getColorForAllergen(_ allergen: Donation.AllergenInfo) -> UIColor {
        switch allergen {
        case .containsNuts:
            return UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0)
        case .glutenFree:
            return UIColor(red: 52/255, green: 168/255, blue: 83/255, alpha: 1.0)
        case .dairyFree:
            return UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
        case .vegan:
            return UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        case .containsShellfish:
            return UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1.0)
        case .eggFree:
            return UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1.0)
        }
    }
}
