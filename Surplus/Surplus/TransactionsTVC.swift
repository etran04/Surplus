//
//  TransactionsTVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import SwiftLoader

/* Transactions Table View Controller holds all transactions relevant to the user */
class TransactionsTVC: UITableViewController {

    /* Header titles, can be changed if needed */
    let headerTitles = ["Pending", "In Progress", "Completed"]
    
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
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Gets the orders from Firebase
        self.fetchAndOrganizeOrders()
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
        
        FirebaseClient.getOrders({(result: [Order]) in
            self.orders = result
            
            for curOrder in result {
                switch (curOrder.status!) {
                    case .Pending:
                        if (FBUserInfo.id == curOrder.ownerId) {
                            self.pendingOrders.append(curOrder)
                        }
                        break
                    case .InProgress:
                        self.progressOrders.append(curOrder)
                        break
                    case .Completed:
                        self.completedOrders.append(curOrder)
                        break
                }
            }
            
            // temp holder so we can see progress and completed cells
            self.progressOrders.append(Order())
            self.completedOrders.append(Order())
            
            // array to hold all orders by section
            self.tableData = [self.pendingOrders, self.progressOrders, self.completedOrders]
            
            // finished loading, so hide spinner
            SwiftLoader.hide()
            
            // refreshes the table
            self.tableView.reloadData()
            
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch (headerTitles[indexPath.section]) {
            case "Pending":
                cell = tableView.dequeueReusableCellWithIdentifier("PendingCell", forIndexPath: indexPath)
                populatePendingCell(indexPath, cell: (cell as! PendingCell))
                break
            case "In Progress":
                cell = tableView.dequeueReusableCellWithIdentifier("ProgressCell", forIndexPath: indexPath)
                break
            case "Completed":
                cell = tableView.dequeueReusableCellWithIdentifier("CompletedCell", forIndexPath: indexPath)
                break
            default:
                break
        }
        
        return cell
    }
    
    /* Helper function for filling in pending cell with its information */
    func populatePendingCell(indexPath: NSIndexPath, cell: PendingCell) {
        cell.tableController = self
        
        let order = pendingOrders[indexPath.row]
        let imagePath = "http://graph.facebook.com/\(order.ownerId!)/picture?type=large"
        self.downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
        
        cell.locationLabel.text = order.location
        cell.estimateCostLabel.text = order.estimate
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        
        let startTime = formatter.stringFromDate(order.startTime!)
        let endTime = formatter.stringFromDate(order.endTime!)
        cell.availableTimeFrameLabel.text = "Available time: " + startTime + " – " + endTime
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
    
    /* Helper function that updates the tvc when a cancel button is pressed in the pending cell 
     * Takes in the row of the cell we'd like to remove from pending
     * Will need to eventually fix this to act upon a delegate rather than passing an instance directly */
    func cancelPendingTransaction(row: Int) {
        pendingOrders.removeAtIndex(row)
        
        // array to hold all orders by section
        self.tableData = [self.pendingOrders, self.progressOrders, self.completedOrders]
        self.tableView.reloadData()
    }


}
