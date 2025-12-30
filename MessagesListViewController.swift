//
//  MessagesListViewController.swift
//  RePlate
//
//  Created by BP-36-201-17 on 21/12/2025.
//

import UIKit

// MARK: - Model
struct Message {
    let name: String
    let lastMessage: String
    let time: String
}

// MARK: - View Controller
class MessagesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Sample Data
    let messages: [Message] = [
        Message(name: "Ali Hassan",
                lastMessage: "Thanks for confirming the pickup!",
                time: "7:25 PM"),

        Message(name: "+973 3999 8755",
                lastMessage: "Can you collect the food tomorrow?",
                time: "6:40 PM"),

        Message(name: "Hope Charity",
                lastMessage: "We appreciate your donation.",
                time: "Yesterday"),

        Message(name: "Food Bank Bahrain",
                lastMessage: "Pickup scheduled at 4 PM.",
                time: "Yesterday"),

        Message(name: "Al Noor Foundation",
                lastMessage: "Donation request received.",
                time: "2 days ago")
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MessageCell",
            for: indexPath
        ) as! MessageCell

        let message = messages[indexPath.row]

        cell.recipientNameLabel.text = message.name
        cell.lastMessageLabel.text = message.lastMessage
        cell.timeLabel.text = message.time

        return cell
    }

    // MARK: - UITableViewDelegate (next step)
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Navigation to Chat Window will be added next
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat" {
            let chatVC = segue.destination as! ChatWindowViewController

            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedMessage = messages[indexPath.row]
                chatVC.recipientName = selectedMessage.name
            }
        }
    }
}

