//
//  TransactionsTVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import SwiftLoader
import FBSDKShareKit
import AMScrollingNavbar


let kPendingHeader = "Awaiting pickup"
let kProgressHeader = "Currently in progress"
let kCompleteHeader = " Completed"

/* Transactions Table View Controller holds all transactions relevant to the user */
class TransactionsTVC: UITableViewController {
    
    /* Header titles, can be changed if needed */
    let headerTitles = [kPendingHeader, kProgressHeader, kCompleteHeader]
    var offset = 0
    
    /* Arrays used to hold each section of orders */
    var pendingOrders = [Order]()
    var progressOrders = [Order]()
    var completedOrders = [Order]()
    
    /* Used in populating the table. Holds each section */
    var tableData = [[Order]]()
    
    /* Used to hold ALL orders fetch from database */
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Starts the loading spinner
        SwiftLoader.show(animated: true)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        offset = UserProfile.getType() ? 1 : 0
        
        // Sets up navigation controller so it animated away when scrolling through.
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Gets the orders from Firebase
        self.fetchAndOrganizeOrders()
        
        // Gets rid of notifications when navigated to this controller
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        tabItem.badgeValue = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Helper method to get the orders from firebase */
    func fetchAndOrganizeOrders() {
        
        // Reinitialize all orders
        pendingOrders = [Order]()
        progressOrders = [Order]()
        completedOrders = [Order]()
        tableData = [[Order]]()
        
        FirebaseClient.getOrders(Status.All, completion: {(result: [Order]) in
            self.orders = result
            self.orders.sortInPlace({ $0.endTime!.compare($1.endTime!) == NSComparisonResult.OrderedAscending })
            
            for curOrder in self.orders {
                switch (curOrder.status!) {
                    case .Pending:
                        if (FBUserInfo.id == curOrder.ownerId) {
                            self.pendingOrders.append(curOrder)
                        }
                        break
                    case .InProgress:
                        if (FBUserInfo.id == curOrder.ownerId || FBUserInfo.id == curOrder.recepientId) {
                            self.progressOrders.append(curOrder)
                        }
                        break
                    case .Completed:
                        if (FBUserInfo.id == curOrder.ownerId || FBUserInfo.id == curOrder.recepientId) {
                            self.completedOrders.append(curOrder)
                        }
                        break
                    default:
                        break
                }
            }
            self.completedOrders.sortInPlace({ $0.endTime!.compare($1.endTime!) == NSComparisonResult.OrderedDescending })
            
            // array to hold all orders by section
            if (UserProfile.getType()) {
                self.tableData = [self.progressOrders, self.completedOrders]
            }
            else {
                self.tableData = [self.pendingOrders, self.progressOrders, self.completedOrders]
            }
            
            // finished loading, so hide spinner
            SwiftLoader.hide()
            
            // refreshes the table
            self.tableView.reloadData()
            
        })
    }
    
    // MARK: - Table view data source

    /* Gets the number of sections in the table */ 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }
    

    /* Gets the number of rows in each section */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numCellsInSection = tableData[section].count
        
        if (numCellsInSection == 0) {
            return 1
        }
        
        return numCellsInSection
    }

    /* Gets the title for each section in the table */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section + offset]
        }
        
        return nil
    }
    
    /* Depending on the section, get the correct cell class to work with */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch (headerTitles[indexPath.section + offset]) {
            case kPendingHeader:
                if (self.pendingOrders.count > 0) {
                    cell = tableView.dequeueReusableCellWithIdentifier("PendingCell", forIndexPath: indexPath)
                    populatePendingCell(indexPath, cell: (cell as! PendingCell))
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell", forIndexPath: indexPath)
                }
                break
            case kProgressHeader:
                if (self.progressOrders.count > 0) {
                    cell = tableView.dequeueReusableCellWithIdentifier("ProgressCell", forIndexPath: indexPath)
                    populateProgressCell(indexPath, cell: (cell as! InProgressCell))
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell", forIndexPath: indexPath)
                }
                break
            case kCompleteHeader:
                if (self.completedOrders.count > 0) {
                    cell = tableView.dequeueReusableCellWithIdentifier("CompletedCell", forIndexPath: indexPath)
                    populateCompleteCell(indexPath, cell: (cell as! CompletedCell))
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell", forIndexPath: indexPath)
                }
                break
            default:
                break
        }
        
        return cell
    }
    
    /* Helper function for filling in Pending cell with its information */
    func populatePendingCell(indexPath: NSIndexPath, cell: PendingCell) {
        cell.tableController = self
        
        let order = pendingOrders[indexPath.row]
        let imagePath = "http://graph.facebook.com/\(order.ownerId!)/picture?width=100&height=100"
        self.downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
        
        cell.locationLabel.text = order.location
        cell.estimateCostLabel.text = order.estimate
        cell.discountLabel.text = "-" + order.discount! + "%"
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        
        let startTime = formatter.stringFromDate(order.startTime!)
        let endTime = formatter.stringFromDate(order.endTime!)
        cell.availableTimeFrameLabel.text = "Available: " + startTime + " – " + endTime
    }
    
    /* Helper function for filling in the inProgress cell with its information */
    func populateProgressCell(indexPath: NSIndexPath, cell: InProgressCell) {
        cell.tableController = self
        
        let order = progressOrders[indexPath.row]

        var pictureId : String?
        if (order.ownerId == FBUserInfo.id) {
            pictureId = order.recepientId!
        }
        else {
            pictureId = order.ownerId!
        }
        
        let imagePath = "http://graph.facebook.com/\(pictureId!)/picture?width=100&height=100"
        self.downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
        
        cell.locationLabel.text = order.location
        cell.estimateCostLabel.text = order.estimate
        cell.discountLabel.text = "–" + order.discount! + "%"
        
        cell.completeBtn.hidden = !UserProfile.getType()
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        
        let startTime = formatter.stringFromDate(order.startTime!)
        let endTime = formatter.stringFromDate(order.endTime!)
        cell.availableTimeFrameLabel.text = "Available time: " + startTime + " – " + endTime
    }
    
    /* Helper function for filling in the Complete cell with its information */
    func populateCompleteCell(indexPath: NSIndexPath, cell: CompletedCell) {
        
        let order = completedOrders[indexPath.row]
        
        var pictureId : String?
        if (order.ownerId == FBUserInfo.id) {
            pictureId = order.recepientId!
        }
        else {
            pictureId = order.ownerId!
        }
        
        let imagePath = "http://graph.facebook.com/\(pictureId!)/picture?width=100&height=100"
        self.downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
        
        cell.locationLabel.text = order.location
        cell.estimateCostLabel.text = order.estimate
        cell.discountLabel.text = "-" + order.discount! + "%"
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        
        let endTime = formatter.stringFromDate(order.endTime!)
        cell.availableTimeFrameLabel.text = "Completed on " + endTime

    }
    
    /* Downloads and sets the profile picture in a cell */
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
    
    /* Helper function that clears up local notifications that is being canceled */
    func cancelLocalNotif(keyValToDelete: String) {
        
        // Loops through all the local notifications on phone, and finds the notification based on the key in the user info 
        let notifArray = UIApplication.sharedApplication().scheduledLocalNotifications
        for (var i = 0; i < notifArray!.count; i++) {
            let notif = notifArray![i]
            let userInfoDict = notif.userInfo
            let uniqueKeyVal = userInfoDict!["UniqueKey"]! as! String
            if (uniqueKeyVal == keyValToDelete) {
                UIApplication.sharedApplication().cancelLocalNotification(notif)
                break;
            }
        }
    }
    
    
    /* Helper function that updates the tvc when a cancel button is pressed in the pending cell
     * Takes in the row of the cell we'd like to remove from pending
     * Will need to eventually fix this to act upon a delegate rather than passing an instance directly */
    func cancelTransaction(status: Status, row: Int) {
        
        var titleMsg = ""
        var msg = ""
        
        if (status == .Pending) {
            titleMsg = "Order Cancellation"
            msg = "Are you sure you want to cancel your current request?"
        } else if (status == .InProgress) {
            titleMsg = "Order Cancellation"
            msg = "Are you sure you want to cancel this transaction?"
        }
        
        let confirmDialog = UIAlertController(title: titleMsg, message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
            
            if (status == .Pending) {
                // removes order from firebase and then the table
                FirebaseClient.removeOrder(self.pendingOrders[row].id)
                self.pendingOrders.removeAtIndex(row)
            } else if (status == .InProgress) {
                // changes type of order from firebase and then the table
                FirebaseClient.cancelProgressOrder(self.progressOrders[row].id)
                if (self.progressOrders[row].ownerId == FBUserInfo.id) {
                    self.pendingOrders.append(self.progressOrders[row])
                    FirebaseClient.notifyOwnerOfOrderCancellation(self.progressOrders[row].recepientId!)
                }
                else {
                    FirebaseClient.notifyOwnerOfOrderCancellation(self.progressOrders[row].ownerId!)
                }
                
                // cancels the local notification
                self.cancelLocalNotif(self.progressOrders[row].id)
                
                self.progressOrders.removeAtIndex(row)
            }
            
            // array to hold all orders by section
            if (UserProfile.getType()) {
                self.tableData = [self.progressOrders, self.completedOrders]
            }
            else {
                self.tableData = [self.pendingOrders, self.progressOrders, self.completedOrders]
            }
            
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        confirmDialog.addAction(okAction)
        confirmDialog.addAction(cancelAction)
        
        self.presentViewController(confirmDialog, animated: true, completion: nil)
    }

    /* Will need to fix to act upon a delegate rather than passing as an instance directly */
    func completeTransaction(row: Int) {
        FirebaseClient.doesOrderExist(self.progressOrders[row].id) { (exists) in
            if (exists) {
                self.performSegueWithIdentifier("goToInputCharge", sender: row)
            }
            else {
                let alertTitle = "Sorry!"
                let alertMessage = "The order was canceled."
                let confirmDialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                confirmDialog.addAction(okAction)
                
                self.presentViewController(confirmDialog, animated: true, completion: nil)
                
                self.tableView.reloadData()
            }
        }
    }
    
    /* Callback function for when the message button is pressed on the cell.
     * Creates a new chatroom between the individuals */
    func openMessage(row: Int) {
        let order = self.progressOrders[row]
        var recepientId = ""
        
        if (order.ownerId == FBUserInfo.id) {
            recepientId = order.recepientId!
        }
        else {
            recepientId = order.ownerId!
        }
        
        let msgs = [Message]()
        let chatroom = Chatroom(ownerId: FBUserInfo.id!, recepientId: recepientId, messages: msgs)
        
        FirebaseClient.makeChatroom(chatroom) { (madeNewChatroom) in
            // Switches tab to the Messages tab
            let fromView = self.view
            let toView = self.tabBarController?.viewControllers![2].view
            
            UIView.transitionFromView(fromView, toView: toView!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: { (finished) -> Void in
                self.tabBarController?.selectedIndex = 2
            })
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "goToInputCharge") {
            let svc = segue.destinationViewController as! InputChargeVC
            svc.curOrder = self.progressOrders[(sender as! Int)]
        }
        
    }
    
    // MARK: - Scrolling navbar methods
    override func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }

}
