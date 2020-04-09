//
//  ChatViewController.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 08/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    var uid = Auth.auth().currentUser!.uid
    var chatId: String?
    var messages = [Message]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observeMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeMessages()
        tableView.reloadData()
    }
    func setupTableView() {
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

    }
    func scrollToBottomRow() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.visibleSize.height + self.messageField.intrinsicContentSize.height), animated: true)
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        guard (Auth.auth().currentUser?.uid) != nil else { return }
                
        if !messageField.text!.isEmpty {
            Firestore.firestore().collection("messages").addDocument(data:
                [
                    "senderId": uid,
                    "message": messageField.text!,
                    "timestamp": Timestamp(),
                    "chatId": self.chatId!
                ]
            )
            Firestore.firestore().collection("chats").document(chatId!).updateData(
                [
                    "lastMessage" : messageField.text!,
                    "lastMessageTimestamp" : Timestamp()

                ]
            )
            
        }
        observeMessages()
        scrollToBottomRow()
        messageField.text = ""
        
    }
    func observeMessages() {
        
        let ref = Firestore.firestore().collection("messages")
        
        ref.whereField("chatId", isEqualTo: chatId!).order(by: "timestamp", descending: false).addSnapshotListener { snapshot, error in
            
            var tempMessages = [Message]()
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            for document in snapshot!.documents {
                let senderId = document["senderId"] as! String
                let messageText = document["message"] as! String
                let timestamp = document["timestamp"] as! Timestamp
                let date = timestamp.dateValue()

                let message = Message(senderId: senderId, messageText: messageText, timeStamp: date)
                tempMessages.append(message)
            }
            self.messages = tempMessages
            self.tableView.reloadData()
        }
        scrollToBottomRow()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageTableViewCell
        cell.configureCell(newMessage: messages[indexPath.row])
        return cell
    }
    
    
}


