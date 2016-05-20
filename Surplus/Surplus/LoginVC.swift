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

    var facebookButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBUserInfo.isLoggedIn()) {
            FBUserInfo.fetchUserInfo(false, completion: { (success) in
                if success {
                    if NSUserDefaults.standardUserDefaults().boolForKey("hasSeenTutorial") {
                        self.performSegueWithIdentifier("goToMainFeed", sender: self)
                    } else {
                        self.performSegueWithIdentifier("goToInitial", sender: self)
                    }
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    if let token = appDelegate.registrationToken {
                        FirebaseClient.setUserGCMRegistrationToken(token)
                    }
                }
            })
        } else {
            let point = self.view.center
            
            facebookButton.center = CGPoint(x: point.x, y: point.y + 100)
            self.view.addSubview(facebookButton)
            facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
            facebookButton.delegate = self
        }
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
                FBUserInfo.fetchUserInfo(true, completion: { (success) in
                    if (success) {
                        if ((NSUserDefaults.standardUserDefaults().boolForKey("hasSeenTutorial"))) {
                            self.performSegueWithIdentifier("goToMainFeed", sender: self)
                        } else {
                            self.performSegueWithIdentifier("goToInitial", sender: self)
                        }
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

}

