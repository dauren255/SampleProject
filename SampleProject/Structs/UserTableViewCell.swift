//
//  UserTableViewCell.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 07/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
        
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    
    func configureCell(user: User){
        username.text = user.username
        email.text = user.email
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
