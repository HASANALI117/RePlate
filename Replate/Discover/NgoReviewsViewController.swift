//
//  NgoReviewsViewController.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

final class NgoReviewsViewController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starsContainer: UIStackView!
    @IBOutlet weak var reviewsCountLabel: UILabel!

    @IBOutlet weak var reliabilityProgress: UIProgressView!
    @IBOutlet weak var transparencyProgress: UIProgressView!
    @IBOutlet weak var impactProgress: UIProgressView!

    @IBOutlet weak var reliabilityLabel: UILabel!
    @IBOutlet weak var transparencyLabel: UILabel!
    @IBOutlet weak var impactLabel: UILabel!

    var id:String!

    private var reviews: [NgoRating] = [
        
    NgoRating(
        id: "r1",
        userName: "Ahmed Al-Khalifa",
        rate: 5,
        createdAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 14),
        content: "Excellent organization doing great work in the community. Very transparent about their operations."
    ),

    NgoRating(
        id: "r2",
        userName: "Sara Hussain",
        rate: 4,
        createdAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 30),
        content: "Very reliable and well managed. I would like to see more updates on ongoing projects."
    ),

    NgoRating(
        id: "r3",
        userName: "Mohammed Ali",
        rate: 5,
        createdAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 7),
        content: "Truly impactful work. You can see where your donations are going."
    ),

    NgoRating(
        id: "r4",
        userName: "Fatima Yusuf",
        rate: 4,
        createdAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 3),
        content: "Great mission and strong community presence. The impact is noticeable."
    ),

    NgoRating(
        id: "r5",
        userName: "Ali Salman",
        rate: 5,
        createdAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 1), 
        content: "Highly trustworthy NGO. Everything is clearly communicated and professionally handled."
    )
]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        renderHeader()
        setUpNavigationItem()
        
       }
    
    func setUpNavigationItem() {
          let arrow = UIImage(named: "back_button")
          navigationController?.navigationBar.backIndicatorImage = arrow
          navigationController?.navigationBar.backIndicatorTransitionMaskImage = arrow
            navigationController?.navigationBar.tintColor = .black

        let backItem = UIBarButtonItem(title: "Reviews", style: .plain, target: nil, action: nil)
          navigationItem.backBarButtonItem = backItem
            
          // Style text
          let attributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.systemFont(ofSize: 17, weight: .medium),
              .foregroundColor: UIColor.label
          ]

          UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
          UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }


    

    private func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
    }

    private func renderHeader() {
        let avg = averageRating(from: reviews)
        rateLabel.text = String(format: "%.1f", avg)
        reviewsCountLabel.text = "\(reviews.count) reviews"

        renderStars(in: starsContainer, rating: avg)

        let reliability = avg
        let transparency = max(0, min(5, avg - 0.1))
        let impact = max(0, min(5, avg - 0.2))

        setProgress(reliabilityProgress, label: reliabilityLabel, value: reliability)
        setProgress(transparencyProgress, label: transparencyLabel, value: transparency)
        setProgress(impactProgress, label: impactLabel, value: impact)
    }

    private func setProgress(_ progress: UIProgressView, label: UILabel, value: Double) {
        let normalized = Float(value / 5.0) // 0..1
        progress.progress = normalized
        label.text = String(format: "%.1f", value)
    }

    private func averageRating(from reviews: [NgoRating]) -> Double {
        guard !reviews.isEmpty else { return 0.0 }
        let sum = reviews.reduce(0) { $0 + $1.rate }
        return Double(sum) / Double(reviews.count)
    }

    private func renderStars(in stack: UIStackView, rating: Double) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let fullStars = Int(rating.rounded(.down))
        let hasHalf = (rating - Double(fullStars)) >= 0.5

        for i in 1...5 {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit

            let imgName: String
            if i <= fullStars {
                imgName = "star.fill"
            } else if i == fullStars + 1 && hasHalf {
                imgName = "star.leadinghalf.filled"
            } else {
                imgName = "star"
            }

            iv.image = UIImage(systemName: imgName)
            iv.tintColor = .systemYellow

            iv.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iv.widthAnchor.constraint(equalToConstant: 14),
                iv.heightAnchor.constraint(equalToConstant: 14)
            ])

            stack.addArrangedSubview(iv)
        }
    }
}

// MARK: - UITableViewDataSource
extension NgoReviewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell",
                                                       for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }

        let item = reviews[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}




extension NgoReviewsViewController: UITableViewDelegate {}
