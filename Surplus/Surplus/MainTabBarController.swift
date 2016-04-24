//
//  MainTabBarController.swift
//  Surplus
//
//  Created by Daniel Lee on 2/27/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var newMessages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listens for remote notifications
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarController.displayReceivedMessage(_:)),
            name: appDelegate.messageKey, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func displayReceivedMessage(notification: NSNotification) {
        if let info = notification.userInfo as? Dictionary<String,AnyObject> {
            if let aps = info["aps"] as? Dictionary<String, AnyObject> {
//                if let alert = aps["alert"] as? Dictionary<String, String> {
//                     TODO: Use given information to reflect change in UI
//                }
                print("message received \(aps["alert"] as! NSDictionary)")
                
                let tabArray = self.tabBar.items as NSArray!
                let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
                self.newMessages += 1
                tabItem.badgeValue = "\(self.newMessages)"
            }
        }
        else {
            print("Software failure. Guru meditation.")
        }
    }
}
