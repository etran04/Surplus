//
//  Chatroom.swift
//  Surplus
//
//  Created by Daniel Lee on 3/2/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation

struct Chatroom {
    var id: String
    var ownerId: String
    var recepientId: String
    var messages: [Message]
    
    init(ownerId: String, recepientId: String, messages: [Message]) {
        self.ownerId = ownerId
        self.recepientId = recepientId
        self.messages = messages
        self.id = ""
    }
}