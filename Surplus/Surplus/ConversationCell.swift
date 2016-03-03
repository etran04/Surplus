//
//  ConversationCell.swift
//  Surplus
//
//  Created by Eric Tran on 3/3/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

    // Reference to the label for other person user is talking to
    @IBOutlet weak var otherPersonLabel: UILabel!
    
    // Reference to label with most recent message between the two
    @IBOutlet weak var mostRecentMessageLabel: UILabel!
    
    // Reference to the label with time of when most recent msg was recieved/sent
    @IBOutlet weak var lastMsgTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
