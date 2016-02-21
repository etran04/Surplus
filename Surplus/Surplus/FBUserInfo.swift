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
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
                
            }
            else {
                print("fetched user: \(result)")
                let name = result.valueForKey("name") as! String
                let id = result.valueForKey("id") as! String
                
                FirebaseClient.saveUser(name, id: id)
                self.name = name
                self.id = id
            }
        })
    }
}