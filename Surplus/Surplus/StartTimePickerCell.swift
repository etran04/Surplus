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
        super.datePicker.minuteInterval = 1
        super.datePicker.minimumDate = NSDate()
        super.datePicker.addTarget(self, action: #selector(StartTimePickerCell.datePickerChanged), forControlEvents: .ValueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func selectedInTableView(tableView: UITableView) {
        super.selectedInTableView(tableView)
        // initialized choice to first option when cell is opened for the first time
        if (rightLabel.text == "Choose an available time") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            dateFormatter.timeStyle = .ShortStyle
            rightLabel.text = dateFormatter.stringFromDate(super.datePicker.date)
        }
        
    }
    
    func datePickerChanged() {
//        var oneSecondAfterPickersDate = datePicker.date.dateByAddingTimeInterval(1)
//        if (datePicker.date.compare(datePicker.minimumDate == NSOrderedSame ) {
//            datePicker.date = oneSecondAfterPickersDate ;
//        }
//        else if ( [datePicker.date compare:datePicker.maximumDate] == NSOrderedSame ) {
//            datePicker.date = oneSecondAfterPickersDate ;
//        }
    }
    
}
