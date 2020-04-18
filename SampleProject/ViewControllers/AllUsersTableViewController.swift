//
//  AllUsersTableViewController.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 07/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class AllUsersTableViewController: UITableViewController {
    
    var uid = Auth.auth().currentUser!.uid
    var users = [User]()
    var chats = [Chat]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.systemGreen
        setupTableView()
        observeUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           observeUsers()
           tableView.reloadData()
       }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func observeUsers() {
        let ref = Firestore.firestore().collection("users")
        ref.addSnapshotListener { (snapshot, error) in
            var tempUsers = [User]()
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            for document in snapshot!.documents {
                let uid = document["uid"] as! String
                let email = document["email"] as! String
                let username = document["username"] as! String
                
                let user = User(uid: uid, email: email, username: username)
                tempUsers.append(user)
            }
            self.users = tempUsers
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.configureCell(user: users[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTheChat"{
            if let viewController = segue.destination as? ChatViewController, let index = tableView.indexPathForSelectedRow?.row{
                for chat in chats {
                    if chat.chatId == uid + users[index].uid {
                        viewController.chatId = chat.chatId
                        return
                    }
                }
                Firestore.firestore().collection("chats").document(uid + users[index].uid).setData([
                    "id": uid + users[index].uid,
                    "lastMessage": "",
                    "lastMessageTimestamp": Timestamp(),
                    "participantIds": [uid, users[index].uid]
                    ]
                )
                viewController.chatId = uid + users[index].uid
            }
        }
    }
}
