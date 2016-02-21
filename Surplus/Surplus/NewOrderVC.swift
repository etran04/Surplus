//
//  NewOrderVC.swift
//  Surplus
//
//  Created by Daniel Lee on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import DatePickerCell

class NewOrderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        if let navController = self.navigationController {
            let order = Order(startTime: NSDate(), endTime: NSDate(timeIntervalSinceNow: 3), location: "Village Market", estimate: "$", status: Status.Pending, ownerId: FBUserInfo.id!)
            FirebaseClient.addOrder(order)
            
            navController.popViewControllerAnimated(true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
