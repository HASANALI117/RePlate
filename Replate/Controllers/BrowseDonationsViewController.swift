//
//  BrowseDonationsViewController.swift
//  Replate
//
//  Created on 2025-12-20.
//

import UIKit

class BrowseDonationsViewController: UIViewController {

    // MARK: - Properties
    private var donations: [Donation] = []
    private var filteredDonations: [Donation] = []
    private var selectedFilter: FilterType = .all

    enum FilterType {
        case all
        case nearMe
        case availableNow
        case freshProduce
    }

    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search donations..."
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let filterScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let listMapSegment: UISegmentedControl = {
        let items = ["List", "Map"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()

    private var filterButtons: [FilterButton] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupFilters()
        loadDonations()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Browse Donations"

        // Add subviews
        view.addSubview(listMapSegment)
        view.addSubview(searchBar)
        view.addSubview(filterScrollView)
        filterScrollView.addSubview(filterStackView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            // List/Map segment
            listMapSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            listMapSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            listMapSegment.widthAnchor.constraint(equalToConstant: 120),

            // Search bar
            searchBar.topAnchor.constraint(equalTo: listMapSegment.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            // Filter scroll view
            filterScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 50),

            // Filter stack view
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -16),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor),

            // Table view
            tableView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DonationCell.self, forCellReuseIdentifier: "DonationCell")
    }

    private func setupFilters() {
        let filters: [(String, FilterType)] = [
            ("All", .all),
            ("Near Me", .nearMe),
            ("Available Now", .availableNow),
            ("Fresh Produce", .freshProduce)
        ]

        for (index, filter) in filters.enumerated() {
            let button = FilterButton(title: filter.0)
            button.isSelected = index == 0
            button.tag = index
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            filterStackView.addArrangedSubview(button)
            filterButtons.append(button)
        }
    }

    // MARK: - Data Loading
    private func loadDonations() {
        // Load donations from DonationService
        DonationService.shared.fetchDonations { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let donations):
                    self.donations = donations
                    self.applyFilter()
                case .failure(let error):
                    print("Error loading donations: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to load donations")
                }
            }
        }
    }

    private func applyFilter() {
        switch selectedFilter {
        case .all:
            filteredDonations = donations
        case .nearMe:
            // TODO: Filter by distance when location is implemented
            filteredDonations = donations
        case .availableNow:
            filteredDonations = donations.filter { $0.status == .available }
        case .freshProduce:
            filteredDonations = donations.filter { $0.category == .freshProduce }
        }

        tableView.reloadData()
    }

    // MARK: - Actions
    @objc private func filterButtonTapped(_ sender: FilterButton) {
        // Deselect all buttons
        filterButtons.forEach { $0.isSelected = false }

        // Select tapped button
        sender.isSelected = true

        // Update filter
        switch sender.tag {
        case 0: selectedFilter = .all
        case 1: selectedFilter = .nearMe
        case 2: selectedFilter = .availableNow
        case 3: selectedFilter = .freshProduce
        default: selectedFilter = .all
        }

        applyFilter()
    }
}

// MARK: - UITableViewDelegate & DataSource
extension BrowseDonationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDonations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath) as? DonationCell else {
            return UITableViewCell()
        }

        let donation = filteredDonations[indexPath.row]
        cell.configure(with: donation)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let donation = filteredDonations[indexPath.row]

        // Navigate to donation detail view
        let detailVC = DonationDetailViewController()
        detailVC.donation = donation
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Filter Button
class FilterButton: UIButton {
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        layer.cornerRadius = 20
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        updateAppearance()
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = Constants.Colors.primaryGreen
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = UIColor.systemGray6
            setTitleColor(.darkGray, for: .normal)
        }
    }
}
