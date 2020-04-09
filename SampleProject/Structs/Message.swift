//
//  Message.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 07/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseFirestore
struct Message {
    var chatId: String?
    var senderId: String?
    var messageText: String? = nil
    var timeStamp: Date?
}
