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
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController : UITabBarController = storyboard.instantiateViewControllerWithIdentifier("mainFeedController") as! UITabBarController
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            // TODO: Set this to false and call it on both conditions
            FBUserInfo.fetchUserInfo(true)
            appDelegate.window?.rootViewController = viewController
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        facebookButton.center = self.view.center
        self.view.addSubview(facebookButton)
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookButton.delegate = self
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
                FBUserInfo.fetchUserInfo(true)

                if ((NSUserDefaults.standardUserDefaults().boolForKey("hasSeenTutorial"))) {
                    self.performSegueWithIdentifier("goToMainFeed", sender: self)
                } else {
                    self.performSegueWithIdentifier("goToIntro", sender: self)
                }
            
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

}

