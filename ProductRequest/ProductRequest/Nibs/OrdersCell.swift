//
//  OrdersCell.swift
//  ZAJEL
//
//  Created by wael on 24/05/2025.
//

import UIKit

class OrdersCell: UITableViewCell {

    @IBOutlet weak var statusBackground: RoundedLabel!
    @IBOutlet weak var orderStatus: UILabel!

    @IBOutlet weak var progressStack1: UIStackView!
    @IBOutlet weak var progressStack2: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
