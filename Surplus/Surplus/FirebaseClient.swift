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
        let usersRef = ref.childByAppendingPath("Users/\(id)")
        let newUser = ["name" : "\(name)", "gcmToken" : "null"]
        
        usersRef.setValue(newUser)
    }
    
    class func addOrder(order: Order) {
        let ordersRef = ref.childByAppendingPath("Orders/")
        let uniqueRef = ordersRef.childByAutoId()
        let orderObj: NSDictionary = [
            "start_time": String(order.startTime!),
            "end_time": String(order.endTime!),
            "location": order.location!,
            "estimate": order.estimate!,
            "status": order.status!.rawValue as String,
            "owner_id": order.ownerId!,
            "recepient_id": order.recepientId!]
        
        uniqueRef.setValue(orderObj)
    }
    
    class func getOrders(sortFlag: Status, completion: (result: [Order]) -> Void) {
        let ordersRef = ref.childByAppendingPath("Orders/")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        var results = [Order]()
        
        ordersRef.queryOrderedByChild("end_time").observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                let orders = snapshot.value as! NSDictionary
                
                for (key, value) in orders {
                    let order = value as! NSDictionary
                    let startDate = dateFormatter.dateFromString(order["start_time"] as! String)
                    let endDate = dateFormatter.dateFromString(order["end_time"] as! String)
                    let location = order["location"] as! String
                    let estimate = order["estimate"] as! String
                    let status = Status(rawValue: order["status"] as! String)
                    let ownerId = order["owner_id"] as! String
                    
                    var currentOrder = Order(startTime: startDate!, endTime: endDate!, location: location, estimate: estimate, status: status!, ownerId: ownerId)
                    currentOrder.id = key as! String
                    currentOrder.recepientId = order["recepient_id"] as? String
                    
                    // If we want sorted orders, only return orders that are of selected status
                    if (sortFlag != .All) {
                        if (currentOrder.status == sortFlag) {
                            results.append(currentOrder)
                        }
                    } else {
                        results.append(currentOrder)   
                    }
                }
                
                results.sortInPlace({ $0.endTime!.compare($1.endTime!) == NSComparisonResult.OrderedAscending })
                
                completion(result: results)
            }
            else {
                print("getOrders error")
            }
            
        })
    }
    
//    private func sortOrders(orders: [Order]) -> [Order] {
//        var temp = [Order]()
//        
//        for order in orders {
//            
//        }
//        
//        return temp
//    }
//    
    class func claimOrder(id: String) {
        let orderRef = ref.childByAppendingPath("Orders/\(id)/")
        let recepientId = orderRef.childByAppendingPath("recepient_id")
        let status = orderRef.childByAppendingPath("status")
        
        recepientId.setValue(FBUserInfo.id)
        status.setValue(Status.InProgress.rawValue)
    }
    
    class func removeOrder(id: String) {
        let orderRef = ref.childByAppendingPath("Orders/\(id)/")
        orderRef.removeValue()
    }
    
    class func completeOrder(id: String) {
        let orderRef = ref.childByAppendingPath("Orders/\(id)/")
        let status = orderRef.childByAppendingPath("status")
        let endTime = orderRef.childByAppendingPath("end_time")
        
        endTime.setValue(String(NSDate()))
        status.setValue(Status.Completed.rawValue)
    }
    
    class func setUserGCMRegistrationToken(token: String) {
        let usersRef = ref.childByAppendingPath("Users/\(FBUserInfo.id)")
        let updatedUser = ["name" : "\(FBUserInfo.name)", "gcmToken" : "\(token)"]
        
        usersRef.setValue(updatedUser)
    }
}