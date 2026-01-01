import UIKit

struct Message {
    let name: String
    let lastMessage: String
    let time: String
}

class MessagesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let messages: [Message] = [
        Message(name: "Ali Hassan", lastMessage: "Thanks for confirming the pickup!", time: "7:25 PM"),
        Message(name: "+973 3999 8755", lastMessage: "Can you collect the food tomorrow?", time: "6:40 PM"),
        Message(name: "Hope Charity", lastMessage: "We appreciate your donation.", time: "Yesterday"),
        Message(name: "Food Bank Bahrain", lastMessage: "Pickup scheduled at 4 PM.", time: "Yesterday"),
        Message(name: "Al Noor Foundation", lastMessage: "Donation request received.", time: "2 days ago")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showChat", sender: messages[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat",
           let chatVC = segue.destination as? ChatWindowViewController,
           let message = sender as? Message {
            chatVC.recipientName = message.name
        }
    }
}
