//
//  InitialVC.swift
//  Surplus
//
//  Created by Daniel Lee on 5/18/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func transitionToProfile() {
        let window = UIApplication.sharedApplication().delegate?.window
        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("mainFeedController") as! UITabBarController
        let fromView = self.view
        let toView = tabBarController.viewControllers![3].view
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasSeenTutorial")
        
        FirebaseClient.setPaymentPreferences(["Venmo", "Square Cash", "Cash"])
        
        UIView.transitionFromView(fromView, toView: toView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: { (finished) -> Void in
            window!!.rootViewController = tabBarController
            tabBarController.selectedIndex = 3
        })
    }
    
    @IBAction func yesPressed(sender: AnyObject) {
        UserProfile.setType(true)
        transitionToProfile()
    }
    
    @IBAction func noPressed(sender: AnyObject) {
        UserProfile.setType(false)
        transitionToProfile()
    }
}

