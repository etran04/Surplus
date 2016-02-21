//
//  FBUserInfo.swift
//  Surplus
//
//  Created by Daniel Lee on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

class FBUserInfo {
    static var name: String?
    static var id: String?
    
    class func isLoggedIn() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    class func fetchUserInfo() {
        let ref = Firebase(url: "https://calpolysurplus.firebaseio.com")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            }
            else {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                
                let id = result.valueForKey("id") as! NSString
                let usersRef = ref.childByAppendingPath("users/\(id)")
                let newUser = ["username" : "\(userName)"]
                
                usersRef.setValue(newUser)
                
                self.name = userName as String
                self.id = id as String
            }
        })
    }
}