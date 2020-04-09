//
//  MessageTableViewCell.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 08/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseAuth
class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var time: UILabel!
    
    func configureCell(newMessage: Message){
        message.text = newMessage.messageText!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let localDate = dateFormatter.string(from: newMessage.timeStamp!)
        time.text = localDate
        if newMessage.senderId == Auth.auth().currentUser?.uid {
            message.textAlignment = NSTextAlignment.right
            time.textAlignment = NSTextAlignment.right

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
