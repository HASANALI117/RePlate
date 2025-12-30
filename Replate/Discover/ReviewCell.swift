//
//  ReviewCell.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

final class ReviewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsContainer: UIStackView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private let df: DateFormatter = {
        let d = DateFormatter()
        d.dateStyle = .medium
        d.timeStyle = .none
        return d
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        starsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func configure(with review: NgoRating) {
        nameLabel.text = review.userName
        contentLabel.text = review.content
        dateLabel.text = df.string(from: review.createdAt)

        renderStars(rating: review.rate)
    }

    private func renderStars(rating: Int) {
        starsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for i in 1...5 {
            let iv = UIImageView(image: UIImage(systemName: i <= rating ? "star.fill" : "star"))
            iv.tintColor = .systemYellow
            iv.contentMode = .scaleAspectFit

            iv.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iv.widthAnchor.constraint(equalToConstant: 12),
                iv.heightAnchor.constraint(equalToConstant: 12)
            ])

            starsContainer.addArrangedSubview(iv)
        }
    }
}

