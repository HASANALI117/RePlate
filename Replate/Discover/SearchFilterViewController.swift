//
//  SearchFilterViewController.swift
//  Replate
//
//  Created by Abdulla on 29/12/2025.
//

import UIKit

final class SearchFilterViewController: UIViewController {

    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var option5Button: UIButton!
    @IBOutlet weak var option6Button: UIButton!
    
    enum FocusArea: String, CaseIterable {
        case hungerRelief = "Hunger Relief"
        case foodSecurity = "Food Security"
        case communitySupport = "Community Support"
        case emergencyFoodAid = "Emergency Food Aid"
        case mealDistribution = "Meal Distribution"
        case foodBanks = "Food Banks"
    }
    
    var selectedFocusAreas = Set<FocusArea>()
    var selectedAreas = Set<String>()
    var selectedOption: String = "All"
    
    var onApply: ((String, Set<FocusArea>, Set<String>) -> Void)?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDropdown()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        setupCheckboxes()

    }

    @IBAction func focusAreaTapped(_ sender: UIButton){
        guard let area = FocusArea.allCases[safe: sender.tag] else { return }

        if selectedFocusAreas.contains(area) {
            selectedFocusAreas.remove(area)
            sender.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            selectedFocusAreas.insert(area)
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }

        sender.tintColor = .systemGray  

    }
    
    @IBAction func applyTapped(_ sender: UIButton) {
        onApply?(selectedOption, selectedFocusAreas, selectedAreas)
        dismiss(animated: true)
    }
    
    private func setupCheckboxes() {
        let buttons = [option1Button, option2Button, option3Button, option4Button, option5Button, option6Button]

        buttons.forEach {
            $0?.setImage(UIImage(systemName: "square"), for: .normal)
            $0?.tintColor = .systemGray
            $0?.adjustsImageWhenHighlighted = false
            $0?.adjustsImageWhenDisabled = false
            $0?.layer.borderWidth = 0
        }
    }

    private let bahrainAreas: [String] = [
        "Manama","Muharraq","Riffa","Isa Town","Hamad Town","A'ali","Sitra","Budaiya",
        "Juffair","Seef","Sanabis","Saar","Janabiyah","Zinj","Adliya","Tubli","Barbar",
        "Diraz","Bani Jamra","Karzakan","Malikiya","Jidhafs","Bilad Al Qadeem","Hidd",
        "Arad","Busaytin","Galali","Diyar Al Muharraq","Al Jasra","Jurdab","Salmaniya",
        "Um Al Hassam","Hoora"
    ]

    private let options = ["All", "Government Verified", "Platform Verified"]



    private func setupDropdown() {
        let actions = options.map { option in
            UIAction(title: option, state: option == selectedOption ? .on : .off) { [weak self] _ in
                guard let self else { return }
                self.selectedOption = option
                self.optionsButton.setTitle(option, for: .normal)
                print("Selected filter:", option)
            }
        }

        optionsButton.menu = UIMenu(title: "Sort/Filter", options: .singleSelection, children: actions)
        optionsButton.showsMenuAsPrimaryAction = true
        optionsButton.changesSelectionAsPrimaryAction = true
        optionsButton.setTitle(selectedOption, for: .normal)
    }

    private func toggleArea(_ area: String) {
        if selectedAreas.contains(area) {
            selectedAreas.remove(area)
        } else {
            selectedAreas.insert(area)
        }
        print("Selected areas:", Array(selectedAreas).sorted())
    }
}

// MARK: - UITableViewDataSource
extension SearchFilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bahrainAreas.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AreaOptionCell",
                                                       for: indexPath) as? AreaOptionCell else {
            return UITableViewCell()
        }

        let area = bahrainAreas[indexPath.row]
        let isChecked = selectedAreas.contains(area)

        cell.configure(title: area, isChecked: isChecked)

        cell.onToggle = { [weak self, weak tableView] in
            guard let self else { return }
            self.toggleArea(area)
            tableView?.reloadRows(at: [indexPath], with: .none)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchFilterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = bahrainAreas[indexPath.row]
        toggleArea(area)
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

