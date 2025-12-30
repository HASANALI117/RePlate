//
//  NgoProfile.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

class NgoProfileViewController: UIViewController {
    
    var id: String!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameStatusLabel: UILabel!
    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var regID: UILabel!
    @IBOutlet weak var regYear: UILabel!
    @IBOutlet weak var focusAreasCollection: UICollectionView!
    @IBOutlet weak var communitySupportButton: UIButton!
    @IBOutlet weak var ReviewsButton: UIButton!
    
    
    private let focusAreas: [String] = [
        "Hunger Relief",
        "Meal Distribution",
        "Community Support"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFocusAreasCollection()
    }
    
    private func setupFocusAreasCollection() {
        focusAreasCollection.dataSource = self
        focusAreasCollection.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        focusAreasCollection.collectionViewLayout = layout
        focusAreasCollection.contentInsetAdjustmentBehavior = .never
        
    }
    
    @IBAction func donateButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func communitySupportButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showGallery", sender: self)

    }
    
    @IBAction func ReviewsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showReviews", sender: self)

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        segue.destination.modalPresentationStyle = .fullScreen
        segue.destination.modalTransitionStyle = .coverVertical

        if segue.identifier == "showReviews" {
            let vc = segue.destination as! NgoReviewsViewController
            // pass data
        }

        if segue.identifier == "showGallery" {
            let vc = segue.destination as! NgoPhotoGalleryViewController
            // vc.imageUrls = ...
        }
    }

    
}

extension NgoProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        focusAreas.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FocusAreaCell",
            for: indexPath
        ) as? FocusAreaCell else {
            return UICollectionViewCell()
        }

        cell.configure(text:focusAreas[indexPath.item])
        return cell
    }
}

