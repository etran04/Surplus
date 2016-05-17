//
//  DurationPickerCell.swift
//  Surplus
//
//  Created by Eric Tran on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation
import UIKit
import DatePickerCell

/* Wrapper class for DatePickerCell to use as a countdown timer */
class DurationPickerCell: DatePickerCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.leftLabel.text = "Duration"
        super.rightLabel.text = "Choose how long you are free"
        super.datePicker.datePickerMode = .CountDownTimer
        super.datePicker.minuteInterval = 15
        super.datePicker.addTarget(self, action: #selector(DurationPickerCell.saveCountdown), forControlEvents: UIControlEvents.AllEvents)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func selectedInTableView(tableView: UITableView) {
        super.selectedInTableView(tableView)
        // initialized choice to first option when cell is opened for the first time
        if (super.rightLabel.text == "Choose how long you are free") {
            saveCountdown()
        }
    }
    
    func saveCountdown() {
        let countdown = datePicker.countDownDuration
        let hours = Int(countdown) / 3600
        var minutes = Int(countdown) / 60 % 60
        
        if (minutes == 1) {
            minutes = 15
            super.datePicker.countDownDuration = 15
        }
        
        if (hours > 1 && minutes > 1) {
            super.rightLabel.text = String(hours) + " hours, " + String(minutes) + " minutes"
        } else if (hours > 1) {
            super.rightLabel.text = String(hours) + " hours, " + String(minutes) + " minute"
        } else if (minutes > 1) {
            super.rightLabel.text = String(hours) + " hour, " + String(minutes) + " minutes"
        } else {
            super.rightLabel.text = String(hours) + " hour, " + String(minutes) + " minute"
        }
    }

}