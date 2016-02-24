//
//  RecentOrdersTVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import SwiftLoader

/* List of recent orders being requested */
class OrdersTVC: UITableViewController {
    
    var orders = [Order]()

    @IBOutlet weak var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        // Gets the orders from Firebase to display
        self.fetchOrders()
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Initial set up for pull down to refresh
        self.setUpRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchOrders() {
        // Starts the loading spinner
        SwiftLoader.show(animated: true)
        FirebaseClient.getOrders(Status.Pending, completion: {(result: [Order]) in
            self.orders = result
            SwiftLoader.hide()
            self.tableView.reloadData()
        })
    }
    
    func downloadImage(url: NSURL, picture: UIImageView){
        //print("Download Started")
        //print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {(data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                //print(response?.suggestedFilename ?? "")
                //print("Download Finished")
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
        self.refresh.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
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
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
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
    }
    
    /* Callback for when confirm is pressed on claiming an order */
    func confirmPressed(index: Int) {
        
        FirebaseClient.claimOrder(self.orders[index].id)
        
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
}
