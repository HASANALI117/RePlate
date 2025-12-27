//
//  OrdersController.swift
//  ProductRequest
//
//  Created by wael on 27/12/2025.
//


import UIKit

class OrdersController: UIViewController {

    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var categotyCollection: UICollectionView!
    var selectedIndexPath: IndexPath?
    let orderStatuses: [String] = [
        "Available",
        "Scheduled",
        "In Progress",
        "Completed",
        "Cancelled"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "OrdersCell", bundle: nil), forCellReuseIdentifier: "OrdersCell")
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        SetUpCollectionView()
        setui()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func SetUpCollectionView(){
        
        categotyCollection.register(UINib(nibName: "typesCell", bundle: nil), forCellWithReuseIdentifier: "typesCell")
        categotyCollection.delegate = self
        categotyCollection.dataSource = self
        if let layout = categotyCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

    }
    
    func setui(){

        DispatchQueue.main.async {
            let firstIndexPath = IndexPath(item: 0, section: 0)
            self.selectedIndexPath = firstIndexPath
            self.categotyCollection.selectItem(at: firstIndexPath, animated: false, scrollPosition: [])
            
            self.collectionView(self.categotyCollection, didSelectItemAt: firstIndexPath)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
}
extension OrdersController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell") as? OrdersCell else {
            return UITableViewCell()
        }

        let status = orderStatuses[indexPath.row]

        cell.orderStatus.text = status
        cell.statusBackground.backgroundColor = status.orderStatusColor
        
        let isInProgress = (status == "In Progress")
        cell.progressStack1.isHidden = !isInProgress
        cell.progressStack2.isHidden = !isInProgress

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultController = storyboard.instantiateViewController(withIdentifier: "DonationStatus") as? DonationStatus

        resultController?.modalPresentationStyle = .fullScreen
        self.present(resultController ?? ViewController() , animated: true, completion: nil)
    }

    
}

extension OrdersController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return orderStatuses.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typesCell", for: indexPath) as? typesCell else {
            return UICollectionViewCell()
        }
        let labelText = orderStatuses[indexPath.item]
        cell.typeTitle.text = labelText

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selected = selectedIndexPath, selected != indexPath {
            collectionView.deselectItem(at: selected, animated: false)
        }
        
        selectedIndexPath = indexPath
        let selectedFilter = orderStatuses[indexPath.row]
        self.table.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let labelText = orderStatuses[indexPath.item] // or whatever array you're using
        let font = UIFont.systemFont(ofSize: 17, weight: .medium)
        let padding: CGFloat = 20 // horizontal padding (left + right)
        
        let labelSize = (labelText as NSString).size(withAttributes: [.font: font])
        let cellWidth = labelSize.width + padding
        
        return CGSize(width: cellWidth, height: 35)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}

extension String {
    var orderStatusColor: UIColor {
        switch self {
        case "Available":
            return .systemBlue
        case "Scheduled":
            return .orange
        case "In Progress":
            return .systemPurple
        case "Completed":
            return .systemGreen
        case "Cancelled":
            return .systemRed
        default:
            return .gray
        }
    }
}
