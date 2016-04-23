//
//  StartTimePickerCell.swift
//  Surplus
//
//  Created by Eric Tran on 2/24/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation
import UIKit
import DatePickerCell

class StartTimePickerCell: DatePickerCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.leftLabel.text = "Start Time"
        super.rightLabel.text = "Choose an available time"
        super.datePicker.datePickerMode = .Time
        super.datePicker.minuteInterval = 15
        super.datePicker.addTarget(self, action: #selector(StartTimePickerCell.datePickerChanged), forControlEvents: .ValueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func datePickerChanged() {
        let components = NSCalendar.currentCalendar().components(
            [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday, NSCalendarUnit.WeekdayOrdinal, NSCalendarUnit.WeekOfYear],
            fromDate: super.datePicker.date)
        
        if components.hour < 7 {
            components.hour = 7
            components.minute = 0
            super.datePicker.setDate(NSCalendar.currentCalendar().dateFromComponents(components)!, animated: true)
        }
        else if components.hour > 21 {
            components.hour = 21
            components.minute = 59
            super.datePicker.setDate(NSCalendar.currentCalendar().dateFromComponents(components)!, animated: true)
        }
        else {
            print("Everything is good.")
        }
    }
    
}
