//
//  PhotoCell.swift
//  Replate
//
//  Created by Abdulla on 30/12/2025.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func configure(urlString: String) {
        image.image = nil

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image.image = image
            }
        }.resume()
    }
}
