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
    
    @IBAction func cancelPressed(sender: UIButton) {
        let tableView = self.superview!.superview as! UITableView
        
        let buttonPosition = sender.convertPoint(CGPointZero, toView: tableView)
        let indexPath = tableView.indexPathForRowAtPoint(buttonPosition)
                
        let myTransactions = tableController as! TransactionsTVC
        myTransactions.cancelPendingTransaction(indexPath!.row)
    }
    
    @IBAction func editPressed(sender: UIButton) {
        print("edit pressed")
    }
    
}