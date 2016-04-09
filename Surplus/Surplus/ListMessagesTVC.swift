//
//  MessagesTVC.swift
//  Surplus
//
//  Created by Daniel Lee on 3/2/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class ListMessagesTVC: UITableViewController {
    
    // Holds all conversations of the current user
    var chatrooms = [Chatroom]()
    
    // Placeholder for chatroom when clicked
    var selectedChatroom : Chatroom?
    
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
        FirebaseClient.getUsername(currentChat.recepientId) { (result) -> Void in
            cell.otherPersonLabel.text = result
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: check which message cell is selected, and bring up a messages VC accordingly
        selectedChatroom = chatrooms[indexPath.row]
        self.showSingleMessageScreen()
    }
    
    // MARK: - Navigation
    
    func showSingleMessageScreen() {
        let newMessageVC = self.storyboard!.instantiateViewControllerWithIdentifier("singleMsgVC") as! SingleMsgVC
        
        FirebaseClient.getUsername((selectedChatroom?.recepientId)!) { (result) -> Void in
            newMessageVC.title = result
        }
        newMessageVC.senderDisplayName = FBUserInfo.name
        newMessageVC.senderId = selectedChatroom?.ownerId
        newMessageVC.chatroom = selectedChatroom!
        newMessageVC.ref = FirebaseClient.ref
        
        let navController = UINavigationController(rootViewController: newMessageVC) // Creating a navigation controller with VC1 at the root of the navigation stack.
        navController.navigationBar.barTintColor = UIColor(red:0.01, green:0.34, blue:0.26, alpha:1.0)
        self.presentViewController(navController, animated:true, completion: nil)
    }
}

