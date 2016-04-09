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
    
    /* Used to save a user's infomation into the Firebase */
    class func saveUser(name: String, id: String) {
        let usersRef = ref.childByAppendingPath("Users/\(id)")
        let newUser = ["name" : "\(name)", "gcm_token" : "null"]
        
        usersRef.setValue(newUser)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let token = appDelegate.registrationToken {
            setUserGCMRegistrationToken(token)
        }
        
        setPaymentPreferences(["Venmo", "Square Cash", "Cash"])
    }
    
    class func getUsername(id: String, completion : (result: String) -> Void) {
        let usersRef = ref.childByAppendingPath("Users/\(id)/name")
        
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot -> Void in
            if snapshot.value is String {
                let result = snapshot.value as! String
                completion(result: result)
            }
        })
    }
    
    /* Used to add a new order into the databse */
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
    
    /* Used to retrieve orders from Firebase. Sort flag used to choose orders of 
     * a specific status (Pending, inProgress, Completed */
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
                
                results.sortInPlace({ $0.endTime!.compare($1.endTime!) == NSComparisonResult.OrderedDescending })
                
                completion(result: results)
            }
            else {
                print("getOrders error")
            }
            
        })
    }
    
    /**
     * Sets the status of the order as 'In Progress' and notifies the owner of the change.
     */
    class func claimOrder(order: Order) {
        let orderRef = ref.childByAppendingPath("Orders/\(order.id)/")
        let recepientId = orderRef.childByAppendingPath("recepient_id")
        let status = orderRef.childByAppendingPath("status")
        
        recepientId.setValue(FBUserInfo.id)
        status.setValue(Status.InProgress.rawValue)
        notifyOwnerOfOrder(order.ownerId!)
    }
    
    /**
     * Converts an in progress order to a pending order.
     * Used primarily to cancel in progress orders.
     */
    class func cancelProgressOrder(id: String) {
        let orderRef = ref.childByAppendingPath("Orders/\(id)/")
        let status = orderRef.childByAppendingPath("status")
        
        status.setValue(Status.Pending.rawValue)
    }
    
    /**
     * Removes an order entirely from the database. 
     * Used primarily to cancel pending orders.
     */
    class func removeOrder(id: String) {
        let orderRef = ref.childByAppendingPath("Orders/\(id)/")
        orderRef.removeValue()
    }
    
    /**
     * Turns an in progress order to complete.
     * Used primarily to complete in progress orders.
     */
    class func completeOrder(id: String) {
        let orderRef = ref.childByAppendingPath("Orders/\(id)/")
        let status = orderRef.childByAppendingPath("status")
        let endTime = orderRef.childByAppendingPath("end_time")
        
        endTime.setValue(String(NSDate()))
        status.setValue(Status.Completed.rawValue)
    }
    
    class func setUserGCMRegistrationToken(token: String) {
        let usersRef = ref.childByAppendingPath("Users/\(FBUserInfo.id!)")
        let updatedUser = ["name" : "\(FBUserInfo.name!)", "gcm_token" : "\(token)"]
        
        usersRef.setValue(updatedUser)
    }
    
    class func setPaymentPreferences(paymentPrefs : [String]) {
        let usersRef = ref.childByAppendingPath("Users/\(FBUserInfo.id!)/payment_prefs")
        usersRef.setValue(paymentPrefs)
    }
    
    class func getPaymentPreferences(id : String, completion : (result: [String]) -> Void) {
        let usersRef = ref.childByAppendingPath("Users/\(id)/payment_prefs")
        var results = [String]()
        
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot -> Void in
            if snapshot.value is NSArray {
                results = snapshot.value as! [String]                
            }
            completion(result : results)
        })
    }
    
    /**
     * Grabs the owner's gcm registration token and sends a message to the owner
     * using the token.
     */
    class func notifyOwnerOfOrder(ownerId: String) {
        let tokenRef = ref.childByAppendingPath("Users/\(ownerId)/gcm_token")
        
        tokenRef.observeSingleEventOfType(.Value, withBlock: { snapshot -> Void in
            if snapshot.value is NSString {
                if let token = snapshot.value as! String? {
                    if (token != "null") {
                        GCMClient.postOrder(token)
                    }
                }
            }
        })
    }
    
    class func getChatrooms(completion: (result: [Chatroom]) -> Void) {
        let chatRef = ref.childByAppendingPath("Chatrooms/")
        var results = [Chatroom]()
        
        chatRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                let chatrooms = snapshot.value as! NSDictionary
                
                for (key, value) in chatrooms {
                    let chatroom = value as! NSDictionary
                    let ownerId = chatroom["owner_id"] as! String
                    let recepId = chatroom["recepient_id"] as! String
                    let id = key as! String
                    var messages = [Message]()
                    
                    if (chatroom["messages"] != nil && !(chatroom["messages"] is NSNull) && (ownerId == FBUserInfo.id || recepId == FBUserInfo.id)) {
                        for (_, val) in chatroom["messages"] as! NSDictionary {
                            let message = val as! NSDictionary
                            let senderId = message["sender_id"] as! String
                            let text = message["text"] as! String
                            
                            messages.append(Message(senderId: senderId, text: text))
                        }
                    }
                    
                    var tempChatroom: Chatroom
                    if (ownerId == FBUserInfo.id)
                    {
                        tempChatroom = Chatroom(ownerId: ownerId, recepientId: recepId, messages: messages)
                    }
                    else
                    {
                        tempChatroom = Chatroom(ownerId: recepId, recepientId: ownerId, messages: messages)
                    }
                    tempChatroom.id = id
                    results.append(tempChatroom)
                }
                completion(result: results)
            }
            else {
                print("getChatrooms error")
            }
        })
    }
    
    class func makeChatroom(chatroom: Chatroom) {
        let chatRef = ref.childByAppendingPath("Chatrooms/")
        let uniqueRef = chatRef.childByAutoId()
        var messages = [NSDictionary]()
        var resultOwnerId = chatroom.ownerId
        var resultRecepId = chatroom.recepientId
        
        for message in chatroom.messages {
            messages.append(["sender_id": message.senderId, "text": message.text])
        }
        
        chatRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                let chatrooms = snapshot.value as! NSDictionary
                
                for (_, value) in chatrooms {
                    let currentChatroom = value as! NSDictionary
                    let ownerId = currentChatroom["owner_id"] as! String
                    let recepId = currentChatroom["recepient_id"] as! String
                    
                    if ((chatroom.ownerId == ownerId || chatroom.ownerId == recepId) &&
                        (chatroom.recepientId == ownerId || chatroom.recepientId == recepId))
                    {
                        resultOwnerId = ownerId
                        resultRecepId = recepId
                        break;
                    }
                }
            }
            else {
                print("getChatrooms error")
            }
        })
        
        let chat = ["owner_id": resultOwnerId,
                    "recepient_id": resultRecepId,
                    "messages": messages]
        
        uniqueRef.setValue(chat)
    }
    
    class func sendMessage(chatroom: Chatroom, message: Message) {
        let chatRef = ref.childByAppendingPath("Chatrooms/\(chatroom.id)/messages")
        let messageObj: NSDictionary = ["sender_id": message.senderId, "text": message.text]
        
        chatRef.childByAutoId().setValue(messageObj)
    }
}
