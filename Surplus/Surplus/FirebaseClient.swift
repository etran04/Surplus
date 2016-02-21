//
//  FirebaseClient.swift
//  Surplus
//
//  Created by Daniel Lee on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation
import Firebase

class FirebaseClient {
    static let ref = Firebase(url: "https://calpolysurplus.firebaseio.com")
    
    class func saveUser(name: String, id: String) {
        let usersRef = ref.childByAppendingPath("users/\(id)")
        let newUser = ["name" : "\(name)"]
        
        usersRef.setValue(newUser)
    }
    
    class func addOrder(startTime: NSDate, endTime: NSDate, location: String, estimate: String, status: Status, userId: String) {
        let ordersRef = ref.childByAppendingPath("Orders/")
    }
}