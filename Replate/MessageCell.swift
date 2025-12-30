//
//  MessageCell.swift
//  Replate
//
//  Created by BP-36-201-17 on 30/12/2025.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var recipientNameLabel: UILabel!
        @IBOutlet weak var lastMessageLabel: UILabel!
        @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
