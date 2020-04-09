//
//  Chat.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 07/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Chat {
    var chatId: String?
    var lastMessage: String?
    var lastMessageTimestamp: Date?
    var participantIds: [String] = []
    var participants: [User] = []
}
