//
//  NgoProfile.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit
import FirebaseAuth

final class NgoProfileViewController: UIViewController {

    var ngo: Ngo!

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

    private var focusAreas: [String] = []
    private var isFollowing = false

    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFocusAreasCollection()
        setupUI()
        refreshFollowState()
        
    }

    private func setupUI() {
        nameStatusLabel.text = ngo.name
        descriptionLabel.text = ngo.description
        regID.text = ngo.registrationId
        regYear.text = ngo.registraionDate

        focusAreas = ngo.focusAreas
        focusAreasCollection.reloadData()

        profileImage.image = UIImage(systemName: "photo")
        loadImage(urlString: ngo.imageUrl) { [weak self] image in
            self?.profileImage.image = image ?? UIImage(systemName: "photo")
        }
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
    }

    private func updateFollowButtonUI() {
        followButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
    }

    private func refreshFollowState() {
        guard let uid = currentUserId else { return }

        Task {
            do {
                let following = try await NgoController.shared.isUserFollowingNgo(ngoID: ngo.id, userID: uid)
                await MainActor.run {
                    self.isFollowing = following
                    self.updateFollowButtonUI()
                }
            } catch {
                print("❌ Failed to read follow state:", error)
            }
        }
    }

    private func setupFocusAreasCollection() {
        focusAreasCollection.dataSource = self
        focusAreasCollection.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        focusAreasCollection.collectionViewLayout = layout
        focusAreasCollection.contentInsetAdjustmentBehavior = .never
    }

    @IBAction func followButtonTapped(_ sender: Any) {
        guard let uid = currentUserId else { return }

        isFollowing.toggle()
        updateFollowButtonUI()

        Task {
            do {
                try await NgoController.shared.toggleNgoFollow(ngoID: ngo.id, userID: uid)
            } catch {
                await MainActor.run {
                    self.isFollowing.toggle()
                    self.updateFollowButtonUI()
                }
                print("❌ Toggle follow failed:", error)
            }
        }
    }

    @IBAction func communitySupportButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showGallery", sender: self)
    }

    @IBAction func ReviewsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showReviews", sender: self)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReviews" {
            if let destination = segue.destination as? NgoReviewsViewController {
                destination.ngo = ngo
            }
        }
        else if segue.identifier == "showGallery" {
            if let destination = segue.destination as? NgoPhotoGalleryViewController {
                destination.ngo = ngo
            }
        }
    }
}

// MARK: - Collection
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

        cell.configure(text: focusAreas[indexPath.item])
        return cell
    }
}

// MARK: - Image Loader
private extension NgoProfileViewController {
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            let img = data.flatMap(UIImage.init(data:))
            DispatchQueue.main.async { completion(img) }
        }.resume()
    }
}


