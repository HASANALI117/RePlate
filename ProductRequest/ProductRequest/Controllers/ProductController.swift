//
//  ProductController.swift
//  ProductRequest
//
//  Created by wael on 23/12/2025.
//

import UIKit

class ProductController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func requestPickClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultController = storyboard.instantiateViewController(withIdentifier: "ScheduleController") as? ScheduleController

        resultController?.modalPresentationStyle = .overFullScreen
        self.present(resultController ?? ViewController() , animated: true, completion: nil)
        
        
    }
    


}
