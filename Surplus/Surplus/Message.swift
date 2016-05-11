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
    var date : NSDate?
    
    init(senderId: String, text: String) {
        self.senderId = senderId
        self.text = text
        self.date = nil
    }
    
    init(senderId: String, text: String, date: NSDate) {
        self.senderId = senderId
        self.text = text
        self.date = date
    }
}