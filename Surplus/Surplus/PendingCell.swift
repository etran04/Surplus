//
//  PendingCell.swift
//  Surplus
//
//  Created by Eric Tran on 2/22/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class PendingCell: UITableViewCell {
    
    /* References to UI elements */
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var availableTimeFrameLabel: UILabel!
    @IBOutlet weak var estimateCostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        
        print("cancel pressed")
       /* var tableView = self.superview!.superview as! UITableView
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: tableView)
        var indexPath = tableView.indexPathForRowAtPoint(buttonPosition)
        
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)*/
        
        
    }
    
}