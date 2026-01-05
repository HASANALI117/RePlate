//
//  PhotoUploadView.swift
//  Replate
//
//  Created on 2026-01-02.
//

import UIKit

@IBDesignable
class PhotoUploadView: UIView {

    // MARK: - Properties
    var onTap: (() -> Void)?

    private var selectedImage: UIImage? {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let placeholderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let cameraIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.circle.fill")
        imageView.tintColor = Constants.Colors.primaryGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Constants.Colors.primaryGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear

        // Add subviews
        addSubview(containerView)
        containerView.addSubview(photoImageView)
        containerView.addSubview(placeholderStackView)

        placeholderStackView.addArrangedSubview(cameraIconView)
        placeholderStackView.addArrangedSubview(addPhotoLabel)

        // Setup tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true

        // Layout
        NSLayoutConstraint.activate([
            // Container fills view
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Photo image view fills container
            photoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // Placeholder stack centered
            placeholderStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            // Camera icon size
            cameraIconView.widthAnchor.constraint(equalToConstant: 50),
            cameraIconView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    @objc private func handleTap() {
        onTap?()
    }

    // MARK: - Public Methods
    func setImage(_ image: UIImage?) {
        selectedImage = image
    }

    func getImage() -> UIImage? {
        return selectedImage
    }

    func setCameraIcon(_ image: UIImage?) {
        cameraIconView.image = image
    }

    private func updateUI() {
        if let image = selectedImage {
            photoImageView.image = image
            photoImageView.isHidden = false
            placeholderStackView.isHidden = true
        } else {
            photoImageView.isHidden = true
            placeholderStackView.isHidden = false
        }
    }

    // MARK: - Interface Builder Support
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
    }
}
