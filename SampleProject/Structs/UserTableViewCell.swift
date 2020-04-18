//
//  UserTableViewCell.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 07/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserTableViewCell: UITableViewCell {
        
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var online: UILabel!
    
    func configureCell(user: User){
        username.text = user.username
        email.text = user.email
        Database.database().reference(withPath: "online").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(user.uid){
                self.online.text = "Online"
            } else {
                self.online.text = "Offline"
            }
        })
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
