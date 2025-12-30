//
//  NgoPhotoGalleryViewController.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

class NgoPhotoGalleryViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var id:String!

    private let imageUrls: [String] = [
        "https://picsum.photos/300/300?1",
        "https://picsum.photos/300/300?2",
        "https://picsum.photos/300/300?3",
        "https://picsum.photos/300/300?4",
        "https://picsum.photos/300/300?5",
        "https://picsum.photos/300/300?6",
        "https://picsum.photos/300/300?7",
        "https://picsum.photos/300/300?8",
        "https://picsum.photos/300/300?9"
    ]
    override func viewDidLoad() {
          super.viewDidLoad()

          collectionView.dataSource = self
          collectionView.delegate = self

          if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
              layout.minimumInteritemSpacing = 2
              layout.minimumLineSpacing = 2
              layout.sectionInset = .zero
          }
        
        setUpNavigationItem()
      }

      override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          configureGrid()
      }
    
    func setUpNavigationItem() {
        // Change back arrow image
          let arrow = UIImage(named: "back_button")
          navigationController?.navigationBar.backIndicatorImage = arrow
          navigationController?.navigationBar.backIndicatorTransitionMaskImage = arrow
            navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = "Community support"
          // Back button title
          let backItem = UIBarButtonItem(title: "Community support", style: .plain, target: nil, action: nil)
          navigationItem.backBarButtonItem = backItem
            
          // Style text
          let attributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.systemFont(ofSize: 17, weight: .medium),
              .foregroundColor: UIColor.label
          ]

          UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
          UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }

    private func configureGrid() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        layout.estimatedItemSize = .zero

        let columns: CGFloat = 3
        let spacing = layout.minimumInteritemSpacing
        let insets = layout.sectionInset.left + layout.sectionInset.right

        let totalSpacing = (columns - 1) * spacing + insets
        let itemWidth = floor((collectionView.bounds.width - totalSpacing) / columns)

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.invalidateLayout()
    }

  }

extension NgoPhotoGalleryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoCell",
            for: indexPath
        ) as? PhotoCell else {
            return UICollectionViewCell()
        }

        let urlString = imageUrls[indexPath.item]
        cell.configure(urlString: urlString)
        return cell
    }
}


  extension NgoPhotoGalleryViewController: UICollectionViewDelegate {}




