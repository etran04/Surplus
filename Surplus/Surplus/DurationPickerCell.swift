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

class DurationPickerCell: DatePickerCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.leftLabel.text = "Duration"
        super.rightLabel.text = "Choose a duration"
        super.datePicker.datePickerMode = .CountDownTimer
        super.datePicker.minuteInterval = 10
        super.datePicker.addTarget(self, action: "saveCountdown", forControlEvents: UIControlEvents.ValueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func saveCountdown() {
        let countdown = datePicker.countDownDuration
        let hours = Int(countdown) / 3600
        let minutes = Int(countdown) / 60 % 60
        if (hours > 1 && minutes > 1) {
            super.rightLabel.text = String(hours) + " hours, " + String(minutes) + " minutes remaining"
        } else if (hours > 1) {
            super.rightLabel.text = String(hours) + " hours, " + String(minutes) + " minute remaining"
        } else if (minutes > 1) {
            super.rightLabel.text = String(hours) + " hour, " + String(minutes) + " minutes remaining"
        } else {
            super.rightLabel.text = String(hours) + " hour, " + String(minutes) + " minute remaining"

        }
    }
    
}