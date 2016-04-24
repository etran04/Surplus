//
//  RecentOrdersTVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import AMScrollingNavbar
import EAIntroView

/* List of recent orders being requested */
class OrdersTVC: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EAIntroDelegate {
    
    @IBOutlet weak var newOrderButton: UIBarButtonItem!
    var orders = [Order]()

    @IBOutlet weak var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserProfile.setType(true)
        if (UserProfile.getType()) {
            navigationItem.rightBarButtonItems = []
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Sets up navigation controller so it animated away when scrolling through.
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        
        // Gets the orders from Firebase to display
        self.fetchOrders()
        
        // Sets the tableview settings for empty data
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // Extends sepeartor lines for tableview
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Initial set up for pull down to refresh
        self.setUpRefresh()
        
        print(UserProfile.getType())

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchOrders() {
        // Starts the loading spinner
        //SwiftLoader.show(animated: true)
        FirebaseClient.getOrders(Status.Pending, completion: {(result: [Order]) in
            self.orders = result
            var tempOrders = [Order]()
            //SwiftLoader.hide()
            FirebaseClient.getPaymentPreferences(FBUserInfo.id!, completion: { (result: [String]) -> Void in
                let myPaymentPrefs = result
                
                for item in self.orders {
                    FirebaseClient.getPaymentPreferences(item.ownerId!, completion: { (result2 : [String]) -> Void in
                        let otherPaymentPrefs = result2
                        var notTrash = false
                        
                        for payment : String in myPaymentPrefs {
                            if otherPaymentPrefs.contains(payment) {
                                notTrash = true
                            }
                        }
                        
                        if notTrash {
                            tempOrders.append(item)
                        }
                        
                        if(self.orders.last!.id == item.id) {
                            self.orders = tempOrders
                            self.tableView.reloadData()
                        }
                    })
                }
                
            })
        })
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

    /* Resets the refresh UI control */
    func setUpRefresh() {
        /* Set the callback for when pulled down */
        self.refresh.addTarget(self, action: #selector(OrdersTVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /* Callback method for when user pulls down to refresh */
    func refresh(sender:AnyObject) {
        self.fetchOrders()
        self.refresh.endRefreshing()
    }
    
    // MARK: - Table view data source

    /* Default to 1: number of sections */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /* Details the number of orders in the tableview */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    /* Configure each order cell */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrderCell
        let order = orders[indexPath.row]
        let imagePath = "http://graph.facebook.com/\(order.ownerId!)/picture?type=large"
        
        downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
        
        cell.locationLabel.text = order.location
        cell.estimateCostLabel.text = order.estimate
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle

        let startTime = formatter.stringFromDate(order.startTime!)
        let endTime = formatter.stringFromDate(order.endTime!)
        cell.availableTimeFrameLabel.text = "Available time: " + startTime + " – " + endTime
        
        // Allows for extension of insets
        cell.preservesSuperviewLayoutMargins = false;
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        
    
        return cell
    }
    
    /* Callback for when a cell is selected */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Makes sure order you selected is not yourself, otherwise, signal it
        if (self.orders[indexPath.row].ownerId != FBUserInfo.id) {
            
            let alertTitle = "Confirm Order"
            let alertMessage = "Are you sure you want to pick up the order?"
            
            let confirmDialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Confirm", style: .Default) { (UIAlertAction) -> Void in
                self.confirmPressed(indexPath.row)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) in
            })
            
            confirmDialog.addAction(okAction)
            confirmDialog.addAction(cancelAction)
            
            self.presentViewController(confirmDialog, animated: true, completion: nil)
            
        } else {
            let alertTitle = "Sorry!"
            let alertMessage = "You can't pick up your own order."
            
            let confirmDialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            confirmDialog.addAction(okAction)
            
            self.presentViewController(confirmDialog, animated: true, completion: nil)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    /* Callback for when confirm is pressed on claiming an order */
    func confirmPressed(index: Int) {
        
        FirebaseClient.claimOrder(self.orders[index])
        
        let window = UIApplication.sharedApplication().delegate?.window
        
        if window!!.rootViewController as? UITabBarController != nil {
            let tabbarController = window!!.rootViewController as! UITabBarController
            let fromView = tabbarController.selectedViewController!.view
            let toView = tabbarController.viewControllers![1].view
            
            UIView.transitionFromView(fromView, toView: toView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: { (finished) -> Void in
                tabbarController.selectedIndex = 1
            })
        }
    }
    
    // MARK: DZNEmptySet Delegate methods
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "There are no orders available for pickup!"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Please check back later."
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
//    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "taylor-swift")
//    }
    
//    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
//        let str = "Placeholder for a button"
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//    
//    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
//        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "Hurray", style: .Default, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
//    }
    
    // MARK: Scrolling navbar methods
    override func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }
}
