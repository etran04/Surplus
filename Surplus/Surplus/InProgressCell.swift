//
//  InProgressCell.swift
//  Surplus
//
//  Created by Eric Tran on 2/23/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import Popover

class InProgressCell: UITableViewCell {

    /* References to UI elements */
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var availableTimeFrameLabel: UILabel!
    @IBOutlet weak var estimateCostLabel: UILabel!
    
    @IBOutlet weak var completeBtn: UIButton!
    
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

    @IBAction func messagePressed(sender: UIButton) {
        FBSDKMessengerSharer.openMessenger()
    }
    
    @IBAction func completedPressed(sender: UIButton) {
        tableController.performSegueWithIdentifier("goToInputCharge", sender: self)

        //let aView = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        //let popover = Popover()
        //popover.show(aView, point: sender.bounds.origin)
    }
    
}
