//
//  LoginPageTableViewController.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 04/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase



class LoginPageTableViewController: UITableViewController {

    var uid = Auth.auth().currentUser!.uid
    var chats = [Chat]()
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChats()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setUserOnline()
    }
    override func viewDidAppear(_ animated: Bool) {
        observeChats()
        tableView.reloadData()
    }
    func setUserOnline(){
        let currentUserRef = Database.database().reference(withPath: "online").child(Auth.auth().currentUser!.uid)
        currentUserRef.setValue(Auth.auth().currentUser!.email)
        currentUserRef.onDisconnectRemoveValue()
    }
    func observeChats() {
        
        let ref = Firestore.firestore().collection("chats")
        
        ref.whereField("participantIds", arrayContains: Auth.auth().currentUser?.uid).order(by: "lastMessageTimestamp", descending: true).addSnapshotListener { (snapshot, error) in
            
            var tempChats = [Chat]()
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            for document in snapshot!.documents {
                let id = document["id"] as! String
                let lastMessage = document["lastMessage"] as! String
                let lastMessageTimestamp = document["lastMessageTimestamp"] as? Timestamp
                let date = lastMessageTimestamp?.dateValue()
                let chat = Chat(chatId: id, lastMessage: lastMessage, lastMessageTimestamp: date, participantIds: document["participantIds"] as! [String])
                tempChats.append(chat)
            }
            
            self.chats = tempChats
            self.tableView.reloadData()
        }
    }
    @IBAction func logOutButton(_ sender: Any) {
        if signOut() == true {
 
            self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Ошибка", message:
                "Что-то пошло не так!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        cell.configureCell(chat: chats[indexPath.row], uid: uid)
        return cell
    }
    
    func signOut() -> Bool{
        do{
            Database.database().reference(withPath: "online").child(Auth.auth().currentUser!.uid).removeValue()
            try Auth.auth().signOut()
            return true
        }catch{
            return false
        }
    }
    
    @IBAction func newChat(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToTheAllUsers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTheChat"{
            if let viewController = segue.destination as? ChatViewController, let index = tableView.indexPathForSelectedRow?.row{
                viewController.chatId = chats[index].chatId
            }
        }
        if segue.identifier == "GoToTheAllUsers"{
            if let viewController = segue.destination as? AllUsersTableViewController{
                viewController.chats = self.chats
            }
        }
    }
}
