//
//  SearchViewController.swift
//  Replate
//
//  Created by Abdulla on 29/12/2025.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    

    private var allNgos: [Ngo] = [
        Ngo(
            id: 1,
            name: "Food Aid Bahrain",
            description: "We distribute meals daily to families in need.",
            imageUrl: "https://picsum.photos/200/200?1",
            location: "Manama",
            rating: 4.7,
            totalDonations: 1200,
            focusAreas: ["Hunger Relief", "Meal Distribution"],
            verificationType: "Government Verified",
            reviews: nil
        ),
        Ngo(
            id: 2,
            name: "Green Planet",
            description: "Environmental protection and recycling programs.",
            imageUrl: "https://picsum.photos/200/200?2",
            location: "Riffa",
            rating: 4.2,
            totalDonations: 860,
            focusAreas: ["Community Support"],
            verificationType: "Platform Verified",
            reviews: nil
        ),
        Ngo(
            id: 3,
            name: "Hope Shelter",
            description: "Providing shelter and support services.",
            imageUrl: "https://picsum.photos/200/200?3",
            location: "Muharraq",
            rating: 4.9,
            totalDonations: 2450,
            focusAreas: ["Emergency Food Aid", "Food Banks"],
            verificationType: "Government Verified",
            reviews: nil
        )
    ]


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

        displayNgos = allNgos
        applySearchAndFilters()
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
        cell.ngoRatingLabel.text = String(format: "%.1f ★", ngo.rating)
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
}



// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ngo = displayNgos[indexPath.row]
        print("Selected:", ngo.name)
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



