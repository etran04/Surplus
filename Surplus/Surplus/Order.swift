//
//  Order.swift
//  Surplus
//
//  Created by Daniel Lee on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation

struct Order {
    var startTime: NSDate?
    var endTime: NSDate?
    var location: String?
    var estimate: String?
    var status: Status?
    var ownerId: String?
    var recepientId: String?
    var id: String
    
    init() {
        self.startTime = nil
        self.endTime = nil
        self.location = nil
        self.estimate = nil
        self.status = nil
        self.ownerId = nil
        self.recepientId = "null"
        self.id = ""
    }
    
    init(startTime: NSDate, endTime: NSDate, location: String, estimate: String, status: Status, ownerId: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.estimate = estimate
        self.status = status
        self.ownerId = ownerId
        self.recepientId = "null"
        self.id = ""
    }
}