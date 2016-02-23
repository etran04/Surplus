//
//  RecentOrdersTVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

/* List of recent orders being requested */
class OrdersTVC: UITableViewController {
    
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    var orders = [Order]()

    @IBOutlet weak var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
//        self.loadingActivityView.startAnimating()
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.setUpRefresh()
        self.fetchOrders()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchOrders() {
        FirebaseClient.getOrders({(result: [Order]) in
            self.orders = result
            self.tableView.reloadData()
//            self.loadingActivityView.stopAnimating()
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
        let alertTitle = "Confirm Order"
        let alertMessage = "Are you sure you want to pick up the order?"
        
        let confirmDialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        //warning finish the handler
        let okAction = UIAlertAction(title: "Confirm", style: .Default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        confirmDialog.addAction(okAction)
        confirmDialog.addAction(cancelAction)

        self.presentViewController(confirmDialog, animated: true, completion: nil)
    }
    
}
