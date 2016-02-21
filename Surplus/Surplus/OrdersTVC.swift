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
    
    let imagePath = "http://graph.facebook.com/1139255816085563/picture?type=large"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadImage(url: NSURL, picture: UIImageView){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: imagePath)!, completionHandler: {(data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                picture.image = UIImage(data: data)
            }
        }).resume()
    }

    // MARK: - Table view data source

    /* Default to 1: number of sections */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /* Details the number of orders in the tableview */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    /* Configure each order cell */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrderCell
        
        
        
        // Configure the cell...
    
        return cell
    }
    
    /* Callback for when a cell is selected */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertTitle = "Confirm Order"
        let alertMessage = "Are you sure you want to pick up the order?"
        
        let confirmDialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        //warning finish the handler
        let okAction = UIAlertAction(title: "Yes", style: .Default, handler: nil)
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
        confirmDialog.addAction(okAction)
        confirmDialog.addAction(cancelAction)

        self.presentViewController(confirmDialog, animated: true, completion: nil)
    }
    
}
