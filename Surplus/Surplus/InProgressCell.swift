//
//  InProgressCell.swift
//  Surplus
//
//  Created by Eric Tran on 2/23/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class InProgressCell: UITableViewCell {

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

    @IBAction func messagePressed(sender: UIButton) {
        FBSDKMessengerSharer.openMessenger()
    }
    
    @IBAction func completedPressed(sender: UIButton) {
        //TODO
    }
    
}
