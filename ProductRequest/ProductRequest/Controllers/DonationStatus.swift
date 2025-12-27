//
//  DonationStatus.swift
//  ProductRequest
//
//  Created by wael on 27/12/2025.
//

import UIKit

class DonationStatus: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "StatusCell", bundle: nil), forCellReuseIdentifier: "StatusCell")
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        
    }

    

    @IBAction func clos(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension DonationStatus: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell") as? StatusCell else {
            return UITableViewCell()
        }


        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    
}
