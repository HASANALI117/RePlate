//
//  FilterButton.swift
//  Replate
//
//  Created on 2025-12-20.
//

import UIKit

@IBDesignable
class FilterButton: UIButton {
    
    // MARK: - Inspectable Properties
    @IBInspectable var filterTitle: String = "Filter" {
        didSet {
            setTitle(filterTitle, for: .normal)
        }
    }
    
    @IBInspectable var selectedColor: UIColor = Constants.Colors.primaryGreen {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable var cornerRadiusValue: CGFloat = 20 {
        didSet {
            layer.cornerRadius = cornerRadiusValue
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    // MARK: - Initialization
    init(title: String) {
        super.init(frame: .zero)
        self.filterTitle = title
        setTitle(title, for: .normal)
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
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        layer.cornerRadius = cornerRadiusValue
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        setTitle(filterTitle, for: .normal)
        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = selectedColor
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = UIColor.systemGray6
            setTitleColor(.darkGray, for: .normal)
        }
    }
}
