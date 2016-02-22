//
//  RecentOrderCell.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

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
    
}
