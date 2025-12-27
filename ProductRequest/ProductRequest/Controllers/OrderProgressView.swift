//
//  OrderProgressView.swift
//  ProductRequest
//
//  Created by wael on 27/12/2025.
//

import UIKit

class DonationProgressView: UIView {

    var steps = ["Posted", "Accepted", "Scheduled", "In Progress", "Completed"]
    var currentIndex: Int = 0 { didSet { updateUI() } }

    private let vStack = UIStackView()
    private let lineContainer = UIView()
    private let lineBG = UIView()
    private let lineFG = UIView()
    private let circlesStack = UIStackView()
    private let labelsStack = UIStackView()
    private var circleViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear

        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // LINE CONTAINER
        lineContainer.translatesAutoresizingMaskIntoConstraints = false
        lineContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        vStack.addArrangedSubview(lineContainer)

        // BACKGROUND LINE
        lineBG.backgroundColor = UIColor.systemGray4
        lineBG.translatesAutoresizingMaskIntoConstraints = false
        lineContainer.addSubview(lineBG)
        NSLayoutConstraint.activate([
            lineBG.heightAnchor.constraint(equalToConstant: 3),
            lineBG.leadingAnchor.constraint(equalTo: lineContainer.leadingAnchor, constant: 20),
            lineBG.trailingAnchor.constraint(equalTo: lineContainer.trailingAnchor, constant: -20),
            lineBG.centerYAnchor.constraint(equalTo: lineContainer.centerYAnchor)
        ])

        // FOREGROUND LINE (progress)
        lineFG.backgroundColor = UIColor.systemGreen
        lineFG.translatesAutoresizingMaskIntoConstraints = false
        lineContainer.addSubview(lineFG)

        // CIRCLES
        circlesStack.axis = .horizontal
        circlesStack.alignment = .center
        circlesStack.distribution = .equalSpacing
        circlesStack.translatesAutoresizingMaskIntoConstraints = false
        lineContainer.addSubview(circlesStack)

        NSLayoutConstraint.activate([
            circlesStack.leadingAnchor.constraint(equalTo: lineBG.leadingAnchor),
            circlesStack.trailingAnchor.constraint(equalTo: lineBG.trailingAnchor),
            circlesStack.centerYAnchor.constraint(equalTo: lineBG.centerYAnchor)
        ])

        // LABELS
        labelsStack.axis = .horizontal
        labelsStack.alignment = .center
        labelsStack.distribution = .equalSpacing
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(labelsStack)

        createCircles()
    }

    private func createCircles() {
        circlesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        labelsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        circleViews.removeAll()

        for i in 0..<steps.count {
            let circle = UIView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = 12
            circle.widthAnchor.constraint(equalToConstant: 24).isActive = true
            circle.heightAnchor.constraint(equalToConstant: 24).isActive = true
            circlesStack.addArrangedSubview(circle)
            circleViews.append(circle)

            let label = UILabel()
            label.text = steps[i]
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .gray
            labelsStack.addArrangedSubview(label)
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateUI()      // <-- at this moment frame is valid
    }

    private func updateUI() {
        guard lineBG.bounds.width > 0 else { return }

        let total = CGFloat(steps.count - 1)
        let width = lineBG.bounds.width * CGFloat(currentIndex) / total

        // update progress line width
        lineFG.frame = CGRect(
            x: lineBG.frame.origin.x,
            y: lineBG.frame.origin.y,
            width: width,
            height: 3
        )

        // update circles
        for (i, c) in circleViews.enumerated() {
            c.subviews.forEach { $0.removeFromSuperview() }
            c.layer.borderWidth = 0
            c.backgroundColor = .clear

            let label = labelsStack.arrangedSubviews[i] as! UILabel
            label.textColor = .gray

            if i < currentIndex {
                c.backgroundColor = .systemGreen
                let check = UIImageView(image: UIImage(systemName: "checkmark"))
                check.tintColor = .white
                check.translatesAutoresizingMaskIntoConstraints = false
                c.addSubview(check)
                NSLayoutConstraint.activate([
                    check.centerXAnchor.constraint(equalTo: c.centerXAnchor),
                    check.centerYAnchor.constraint(equalTo: c.centerYAnchor)
                ])
            }
            else if i == currentIndex {
                c.layer.borderWidth = 2
                c.layer.borderColor = UIColor.systemGreen.cgColor
                c.backgroundColor = .white
                label.textColor = .systemGreen
            }
            else {
                c.backgroundColor = UIColor.systemGray4
            }
        }
    }
}

