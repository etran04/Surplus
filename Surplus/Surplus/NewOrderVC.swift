//
//  NewOrderVC.swift
//  Surplus
//
//  Created by Daniel Lee on 2/21/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import DatePickerCell
import DownPicker

class NewOrderVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /* Tableview used to hold datepickercell*/
    @IBOutlet weak var tableView: UITableView!
    /* Reference to estimate label */
    @IBOutlet weak var estimateLabel: UILabel!
    /* Reference to estimates segmented control */
    @IBOutlet weak var estimatesControl: UISegmentedControl!
    /* Reference to location downpicker */
    @IBOutlet weak var locationPicker: UITextField!
    
    /* Constants and local vars */
    let kDefaultCellHeight = 44
    var cells : NSArray = []
    var curOrder : Order = Order()
    var curEstimate = "$"
    
    var locationsDownPicker: DownPicker!
    var locationChoices = [String]()
    
    /* Called when view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }
    
    /* Called when view appears */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* populate location choices */
        self.locationChoices = ["The Avenue", "VG Cafe", "Campus Market", "Village Market", "19 Metro Station", "Sandwich Factory"]
        
        self.locationsDownPicker = DownPicker(textField: self.locationPicker, withData: locationChoices)
        self.locationsDownPicker.setPlaceholder("Choose a location")
    }
    
    /* Helper function for initializing tableview to allow for collapsible datepickercell */
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = CGFloat(kDefaultCellHeight)
        
        // Sets up Start Time DatePickerCell
        let startPickerCell = DatePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        startPickerCell.leftLabel.text = "Start Time"
        startPickerCell.rightLabel.text = "Choose a start time"
        startPickerCell.datePicker.datePickerMode = .Time
        
        // Uses custom class to set up duration DatePickerCell
        let durationPickerCell = DurationPickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        // Cells is a cells to be used
        cells = [startPickerCell, durationPickerCell]
        
        // Replaces the extra cells at the end with a clear view 
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    /* Callback for when the estimate segment control is changed, to change estimate label */
    @IBAction func estimateChanged(sender: UISegmentedControl) {
        switch (estimatesControl.selectedSegmentIndex) {
        case 0:
            estimateLabel.text = "$0 – $5"
            curEstimate = "$"
            break
        case 1:
            estimateLabel.text = "$5 – $10"
            curEstimate = "$$"
            break
        case 2:
            estimateLabel.text = "$10 – $20"
            curEstimate = "$$$"
            break
        case 3:
            estimateLabel.text = "$20 – $50"
            curEstimate = "$$$$"
            break
        default:
            print("estimateChanged - error")
            break
        }
        curOrder.estimate = estimateLabel.text
    }
    
    /* Callback for when the cancel button is pressed */
    @IBAction func cancelPressed(sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    /* Callback for when the save button is pressed */
    @IBAction func savePressed(sender: AnyObject) {
        if let navController = self.navigationController {
            let order = Order(
                startTime: NSDate(),
                endTime: NSDate(timeIntervalSinceNow: 3),
                location: self.locationsDownPicker.text,
                estimate: self.curEstimate,
                status: Status.Pending,
                ownerId: FBUserInfo.id!)
            FirebaseClient.addOrder(order)
            
            navController.popViewControllerAnimated(true)
        }
    }
    
    // MARK : TableView DataSource/Delegate Methods
    
    /* Returns height of row in tableview */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DatePickerCell)) {
            return (cell as! DatePickerCell).datePickerHeight()
        }
        
        return CGFloat(kDefaultCellHeight)
    }
    
    /* Callback for when cell is selected */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DatePickerCell)) {
            let datePickerTableViewCell = cell as! DatePickerCell
            datePickerTableViewCell.selectedInTableView(tableView)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Collapses all other cells
            for (var i = 0; i < cells.count; i++) {
                if (i != indexPath.row && cells[i].expanded == true) {
                    cells[i].selectedInTableView(tableView)
                }
            }
        }
    }
    
    /* Called to determine number of sections in tableView */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* Called to determine number of rows in tableView */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    /* Configures each cell in tableView */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row] as! UITableViewCell
    }

}
