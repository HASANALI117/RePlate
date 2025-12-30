//
//  ChatWindowViewController.swift
//  Replate
//
//  Created by BP-36-201-17 on 30/12/2025.
//

import UIKit

class ChatWindowViewController: UIViewController {

    var recipientName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = recipientName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
