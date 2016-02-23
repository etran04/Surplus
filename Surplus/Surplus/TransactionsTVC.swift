//
//  TransactionsTVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

/* Transactions Table View Controller holds all transactions relevant to the user */
class TransactionsTVC: UITableViewController {

    /* Header titles, can be changed if needed */
    let headerTitles = ["Pending", "In Progress", "Completed"]
    
    /* Arrays used to hold each section of orders */
    var pendingOrders = [String]()
    var progressOrders = [String]()
    var completedOrders = [String]()
    
    /* Used in populating the table. Holds each section */
    var data = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the all the different orders
        pendingOrders.append("1")
        pendingOrders.append("2")
        pendingOrders.append("3")
        progressOrders.append("1")
        progressOrders.append("2")
        completedOrders.append("1")
        completedOrders.append("2")
        
        data = [pendingOrders, progressOrders, completedOrders]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Replaces the extra cells at the end with a clear view
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
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

        // Configure the cell...

        return cell
    }

}
