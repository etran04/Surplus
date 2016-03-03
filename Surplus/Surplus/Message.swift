//
//  Message.swift
//  Surplus
//
//  Created by Daniel Lee on 3/2/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation

struct Message {
    var senderId : String
    var text : String
    
    init(senderId: String, text: String) {
        self.senderId = senderId
        self.text = text
    }
}