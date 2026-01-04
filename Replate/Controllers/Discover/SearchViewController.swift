//
//  SearchViewController.swift
//  Replate
//
//  Created by Abdulla on 29/12/2025.
//

import UIKit
import FirebaseFirestore
final class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    

    private var allNgos: [Ngo] = []


    private var displayNgos: [Ngo] = []

    // Filters
    var selectedOption: String = "All"
    var selectedAreas = Set<String>()
    var selectedFocusAreas = Set<SearchFilterViewController.FocusArea>()

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        modalPresentationStyle = .currentContext

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        tableView.separatorStyle = .none
        displayNgos = allNgos
        
        
        Task {
            try await loadData()
        }
    }

    private func applySearchAndFilters() {
        let text = (searchBar.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        var result = allNgos

        // 1) Areas filter (location)
        if !selectedAreas.isEmpty {
            result = result.filter { selectedAreas.contains($0.location) }
        }

        // 2) Focus Areas filter (ANY match)
        if !selectedFocusAreas.isEmpty {
            let selected = Set(selectedFocusAreas.map { $0.rawValue })
            result = result.filter { ngo in
                let ngoAreas = Set(ngo.focusAreas )
                return !ngoAreas.intersection(selected).isEmpty
            }
        }

        // 3) Verification option filter
        if selectedOption != "All" {
            result = result.filter { ($0.verificationType) == selectedOption }
        }

        // 4) Search text filter
        if !text.isEmpty {
            result = result.filter { ngo in
                let areasText = (ngo.focusAreas).joined(separator: " ").lowercased()
                return ngo.name.lowercased().contains(text)
                    || ngo.description.lowercased().contains(text)
                    || ngo.location.lowercased().contains(text)
                    || areasText.contains(text)
            }
        }

        displayNgos = result
        tableView.reloadData()
    }


    @IBAction func filterTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(
               withIdentifier: "SearchFilterViewController"
           ) as? SearchFilterViewController else { return }


           vc.selectedAreas = selectedAreas
           vc.selectedFocusAreas = selectedFocusAreas
           vc.selectedOption = selectedOption

           vc.onApply = { [weak self] option, focusAreas, areas in
               guard let self else { return }
               self.selectedOption = option
               self.selectedFocusAreas = focusAreas
               self.selectedAreas = areas
               self.applySearchAndFilters()
           }

           vc.modalPresentationStyle = .pageSheet
           if let sheet = vc.sheetPresentationController {
               sheet.detents = [.medium(), .large()]   
               sheet.prefersGrabberVisible = true
               sheet.preferredCornerRadius = 20
           }

           present(vc, animated: true)
    }
    
    func loadData() async throws {
        
        allNgos = try await NgoController.shared.getAllNgo()
        applySearchAndFilters()
    }
    
    func ratingAttributedText(rate: Double) -> NSAttributedString {
        let result = NSMutableAttributedString(
            string: String(format: "%.1f ", rate),
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ]
        )

        let imageName: String
        switch rate {
        case 4.0...5.0:
            imageName = "great"
        case 2.5..<4.0:
            imageName = "fine"
        default:
            imageName = "bad"
        }

        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)

        // Adjust image size & alignment
        let imageSize: CGFloat = 14
        attachment.bounds = CGRect(x: 0, y: -2, width: imageSize, height: imageSize)

        result.append(NSAttributedString(attachment: attachment))
        return result
    }

}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayNgos.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NgoCell",
                                                       for: indexPath) as? NgoCell else {
            return UITableViewCell()
        }

        let ngo = displayNgos[indexPath.row]

        cell.ngoNameLabel.text = ngo.name
        cell.ngoDescriptionLabel.text = ngo.description
        cell.ngoLocationLabel.text = ngo.location
        cell.ngoRatingLabel.attributedText = ratingAttributedText(rate: ngo.rating)
        cell.totalDonations.text = "Donations: \(ngo.totalDonations)"
      
        
        cell.ngoImageView.image = UIImage(systemName: "photo")
        loadImage(urlString: ngo.imageUrl) { [weak tableView, weak cell] image in
            guard let tableView, let cell else { return }
            if tableView.indexPath(for: cell) == indexPath {
                cell.ngoImageView.image = image ?? UIImage(systemName: "photo")
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NgoProfileViewController" {
            if let vc  = segue.destination as? NgoProfileViewController,
               let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                vc.ngo = displayNgos[indexPath.row]
            }
        }
    }
}



// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NgoProfileViewController", sender: tableView.cellForRow(at: indexPath))
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySearchAndFilters()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Image Loader
private extension SearchViewController {
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



