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
    
    class func addOrder(order: Order) {
        let ordersRef = ref.childByAppendingPath("Orders/")
        let uniqueRef = ordersRef.childByAutoId()
        let orderObj: NSDictionary = [
            "start_time": String(order.startTime),
            "end_time": String(order.endTime),
            "location": order.location,
            "estimate": order.estimate,
            "status": String(order.status),
            "owner_id": order.ownerId,
            "recepient_id": order.recepientId]
        
        uniqueRef.setValue(orderObj)
    }
    
    class func getOrders(completion: (result: [Order]) -> Void) {
        let ordersRef = ref.childByAppendingPath("Orders/")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        var results = [Order]()
        
        ordersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let orders = snapshot.value as! NSDictionary
            
            for order in orders.allValues {
                let startDate = dateFormatter.dateFromString(order["start_time"] as! String)
                let endDate = dateFormatter.dateFromString(order["end_time"] as! String)
                let location = order["location"] as! String
                let estimate = order["estimate"] as! String
                let status = Status(rawValue: order["status"] as! String)
                let ownerId = order["owner_id"] as! String

                let currentOrder = Order(startTime: startDate!, endTime: endDate!, location: location, estimate: estimate, status: status!, ownerId: ownerId)
                results.append(currentOrder)
            }
            completion(result: results)
        })
    }
}