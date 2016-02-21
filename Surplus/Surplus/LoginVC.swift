//
//  ViewController.swift
//  Surplus
//
//  Created by Daniel Lee on 1/31/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FBSDKShareKit

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let facebookButton = FBSDKLoginButton()
        facebookButton.center = self.view.center
        self.view.addSubview(facebookButton)
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookButton.delegate = self
        
        // Create a UIButton styled for sharing to messenger. You can leave
        // the size at its default (365, 45) or change the size yourself
        let messengerButton = FBSDKMessengerShareButton.circularButtonWithStyle(.Blue)
        messengerButton.addTarget(self, action: "shareButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(messengerButton)
    }
    
    func shareButtonPressed() {
        print("share putton pressed")
        FBSDKMessengerSharer.openMessenger()
    }
    
    func saveUserInfo() {
        let ref = Firebase(url: "https://calpolysurplus.firebaseio.com")
        let facebookLogin = FBSDKLoginManager()
        
        //facebookLogin.
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                //saveUserInfo()
                returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let ref = Firebase(url: "https://calpolysurplus.firebaseio.com")

        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                
                let id = result.valueForKey("id") as! NSString
                let usersRef = ref.childByAppendingPath("users/\(id)")
                let newUser = ["username" : "\(userName)"]
                
                usersRef.setValue(newUser)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

