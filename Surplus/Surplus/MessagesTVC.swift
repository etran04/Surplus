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
        
        FirebaseClient.getChatrooms({ (result) -> Void in
            self.chatrooms = result
            self.tableView.reloadData()
        })
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell", forIndexPath: indexPath) as! ConversationCell
        
        let currentChat = chatrooms[indexPath.row]
        let imagePath = "http://graph.facebook.com/\(currentChat.recepientId)/picture?type=large"
        downloadImage(NSURL(string: imagePath)!, picture: cell.picture)
        print(currentChat.recepientId)
        FirebaseClient.getUsername(currentChat.recepientId) { (result) -> Void in
            cell.otherPersonLabel.text = result
        }
    
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

