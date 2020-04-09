//
//  ChatTableViewCell.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 07/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var lastTime: UILabel!
    var newUId: String?
    func configureCell(chat: Chat, uid: String){
        for uuid in chat.participantIds {
            if uid != uuid {
                newUId = uuid
            }
        }
        let ref = Firestore.firestore().collection("users")
        
        ref.whereField("uid", isEqualTo: newUId).addSnapshotListener { (snapshot, error) in
        
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            for document in snapshot!.documents {
                self.name.text = document["username"] as? String
            }
        }
        if newUId == nil{
            name.text = "My own chat"
        }
        lastMessage.text = chat.lastMessage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let localDate = dateFormatter.string(from: chat.lastMessageTimestamp!)
        lastTime.text = localDate
    }
}
