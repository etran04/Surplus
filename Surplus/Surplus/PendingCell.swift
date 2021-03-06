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
    @IBOutlet weak var discountLabel: UILabel!
    
    /* Reference to the parent table view controller */
    var tableController : UITableViewController
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        tableController = UITableViewController()
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        tableController = UITableViewController()
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /* When cancel is pressed, callsback on the tvc method to delete the cell and clear from database */
    @IBAction func cancelPressed(sender: UIButton) {
        let tableView = self.superview!.superview as! UITableView
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(buttonPosition)
                
        let myTransactions = tableController as! TransactionsTVC
        myTransactions.cancelTransaction(Status.Pending, row: indexPath!.row)
    }
    
    @IBAction func editPressed(sender: UIButton) {
        print("edit pressed")
    }
    
}