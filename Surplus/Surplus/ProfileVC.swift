//
//  ProfileVC.swift
//  Surplus
//
//  Created by Ryan Lee on 2/27/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var paymentMethodTable: UITableView!

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var paymentPrefs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentMethodTable.delegate = self
        self.paymentMethodTable.dataSource = self
        self.paymentMethodTable.backgroundColor = UIColor.whiteColor()
        self.profileName.text = FBUserInfo.name
        
        let imagePath = "http://graph.facebook.com/\(FBUserInfo.id!)/picture?width=150&height=150"
        downloadImage(NSURL(string: imagePath)!, picture: profilePic)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Sets up navigation controller so it animated away when scrolling through.
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(view, delay: 50.0)
        }
        
        let accountTypeCell = self.paymentMethodTable.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! PaymentMethodCell
        accountTypeCell.paymentMethodSwitch.setOn(UserProfile.getType(), animated: false)
        accountTypeCell.paymentMethodSwitch.tag = 1
        
        FirebaseClient.getPaymentPreferences(FBUserInfo.id!, completion: {(result: [String]) in
            self.paymentPrefs = result
            dump(self.paymentPrefs)
            for i in 0..<3 {
                if let cell = self.paymentMethodTable?.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 1)) as? PaymentMethodCell {
                    print(cell.paymentMethodLabel.text!)
                    cell.paymentMethodSwitch.setOn(self.paymentPrefs.contains(cell.paymentMethodLabel.text!), animated: true)
                }
//                let cell = self.paymentMethodTable.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 1)) as! PaymentMethodCell
//                
//                cell.paymentMethodSwitch.setOn(self.paymentPrefs.contains(cell.paymentMethodLabel.text!), animated: true)
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }

    @IBAction func logoutPressed(sender: UIButton) {
        FBUserInfo.logout()
        performSegueWithIdentifier("goBackLogin", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.paymentMethodTable.dequeueReusableCellWithIdentifier("paymentCell") as! PaymentMethodCell
        
        if (indexPath.section == 0) {
            cell.paymentMethodLabel.text = "Do you have plus dollars?"
        }
        else {
            if (indexPath.row == 0) {
                cell.paymentMethodLabel.text = "Venmo"
            }
            else if (indexPath.row == 1) {
                cell.paymentMethodLabel.text = "Square Cash"
            }
            else {
                cell.paymentMethodLabel.text = "Cash"
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Account Type"
        }
        else {
            return "Payment Preferences"
        }
    }
    
    func downloadImage(url: NSURL, picture: UIImageView){
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {(data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                picture.image = UIImage(data: data)
                picture.layer.cornerRadius = picture.frame.size.height / 2
                picture.layer.masksToBounds = true
                picture.layer.borderWidth = 0
            }
        }).resume()
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
