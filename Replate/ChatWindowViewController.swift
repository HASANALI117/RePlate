import UIKit
import FirebaseFirestore

// MARK: - Model
struct ChatMessage {
    let sender: String
    let text: String
    let timestamp: Date
}

class ChatWindowViewController: UIViewController,
                                UITableViewDelegate,
                                UITableViewDataSource {

    // MARK: - Passed from Messages List
    var recipientName: String?

    // MARK: - Firebase
    let db = Firestore.firestore()

    // MARK: - Data
    var messages: [ChatMessage] = []

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = recipientName

        tableView.delegate = self
        tableView.dataSource = self

        fetchMessages()
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChatMessageCell",
            for: indexPath
        )

        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.textLabel?.numberOfLines = 0

        return cell
    }

    // MARK: - Send Message (TEST)
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        

        guard
            let text = messageTextField.text,
            !text.isEmpty,
            let recipient = recipientName
        else {
            print("❌ Guard failed")
            return
        }

       

        let messageData: [String: Any] = [
            "sender": "Komail",
            "receiver": recipient,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("❌ Firestore write error:", error)
            } else {
                print("✅ Message written to Firestore")
            }
        }

        messageTextField.text = ""
    }

    // MARK: - Fetch Messages (Realtime)
    func fetchMessages() {
        print("👂 Listening for messages...")

        db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    print("❌ Firestore listener error:", error)
                    return
                }

               

                self.messages.removeAll()

                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    print("📄 Document:", data)

                    let sender = data["sender"] as? String ?? ""
                    let receiver = data["receiver"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()

                    if sender == self.recipientName || receiver == self.recipientName {
                        self.messages.append(
                            ChatMessage(sender: sender, text: text, timestamp: timestamp)
                        )
                    }
                }

                print("📊 Messages count:", self.messages.count)
                self.tableView.reloadData()
            }
    }
}
