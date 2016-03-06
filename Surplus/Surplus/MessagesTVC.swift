//
//  MessagesTVC.swift
//  Surplus
//
//  Created by Daniel Lee on 3/2/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class MessagesTVC: UITableViewController {
    
    // Holds all conversations of the current user
    var chatrooms = [Chatroom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseClient.getMessages { (result) -> Void in
            self.chatrooms = result
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  81
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath)
    
        // Configure the cell...
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: check which message cell is selected, and bring up a messages VC accordingly
        self.performSegueWithIdentifier("goToMessage", sender: self)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let newMessageVC = segue.destinationViewController as! MessageVC
        
    }

    
}

