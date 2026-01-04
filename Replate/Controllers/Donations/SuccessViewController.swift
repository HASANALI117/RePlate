//
//  SuccessViewController.swift
//  Replate
//
//  Created on 2025-12-20.
//

import UIKit

class SuccessViewController: UIViewController {

    // MARK: - Properties
    private let successTitle: String
    private let successMessage: String
    private let onDismiss: (() -> Void)?

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let checkmarkView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryGreen
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryGreen
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initialization
    init(title: String, message: String, onDismiss: (() -> Void)? = nil) {
        self.successTitle = title
        self.successMessage = message
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        animatePresentation()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(containerView)
        containerView.addSubview(checkmarkView)
        checkmarkView.addSubview(checkmarkImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(okButton)

        titleLabel.text = successTitle
        messageLabel.text = successMessage

        NSLayoutConstraint.activate([
            // Container view
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            // Checkmark view
            checkmarkView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            checkmarkView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 100),
            checkmarkView.heightAnchor.constraint(equalToConstant: 100),

            // Checkmark image
            checkmarkImageView.centerXAnchor.constraint(equalTo: checkmarkView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: checkmarkView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 50),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 50),

            // Title label
            titleLabel.topAnchor.constraint(equalTo: checkmarkView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            // Message label
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            // OK button
            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32),
            okButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            okButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            okButton.heightAnchor.constraint(equalToConstant: 50),
            okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }

    private func setupActions() {
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }

    private func animatePresentation() {
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
        }
    }
    private func goToHome() {
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: false)
            return
        }

        // حل احتياطي (لو كان presented)
        self.view.window?.rootViewController?.dismiss(animated: true)
    }


    // MARK: - Actions
    @objc private func okButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.alpha = 0
            self.view.backgroundColor = .clear
        }) { _ in
            self.dismiss(animated: false) {
                self.onDismiss?()
            }
        }
    }
}
