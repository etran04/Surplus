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
    /* Reference to the save button */
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /* Constants and local vars */
    let kDefaultCellHeight = 44
    var cells : NSArray = []
    var curOrder : Order = Order()
    
    var locationsDownPicker: DownPicker!
    var locationChoices = [String]()
    
    /* Called when view is loaded */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.saveButton.enabled = false
    }
    
    /* Called when view appears */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.curOrder.estimate = "$"
    }
    
    /* Helper function for initializing tableview to allow for collapsible datepickercell */
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = CGFloat(kDefaultCellHeight)
        
        // Sets up scroll picker cell for locations
        let locationPickerCell = ScrollPickerCell(style: .Default, reuseIdentifier: nil)
        self.locationChoices = ["The Avenue", "VG Cafe", "Campus Market", "Village Market", "19 Metro Station", "Sandwich Factory"]
        locationPickerCell.setChoices(self.locationChoices)
        
        // Sets up Start Time DatePickerCell
        let startPickerCell = StartTimePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        // Uses custom class to set up duration DatePickerCell
        let durationPickerCell = DurationPickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        // Cells is a cells to be used
        cells = [locationPickerCell, startPickerCell, durationPickerCell]
        
        // Replaces the extra cells at the end with a clear view 
        tableView.tableFooterView = UIView(frame: CGRect.zero)

    }
    
    /* Callback for when the estimate segment control is changed, to change estimate label */
    @IBAction func estimateChanged(sender: UISegmentedControl) {
        switch (estimatesControl.selectedSegmentIndex) {
        case 0:
            estimateLabel.text = "$0 – $5"
            curOrder.estimate = "$"
            break
        case 1:
            estimateLabel.text = "$5 – $10"
            curOrder.estimate = "$$"
            break
        case 2:
            estimateLabel.text = "$10 – $20"
            curOrder.estimate = "$$$"
            break
        case 3:
            estimateLabel.text = "$20 – $50"
            curOrder.estimate = "$$$$"
            break
        default:
            print("estimateChanged - error")
            break
        }
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
            
            // TODO: Check and make sure all fields are filled in
            
            let order = Order(
                startTime: (cells[1] as! DatePickerCell).date,
                endTime: NSDate(timeInterval: (cells[2] as! DatePickerCell).datePicker.countDownDuration , sinceDate: (cells[1] as! DatePickerCell).date),
                location: (cells[0] as! ScrollPickerCell).getChoice(),
                estimate: curOrder.estimate!,
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
        else if (cell.isKindOfClass(ScrollPickerCell)) {
            return (cell as! ScrollPickerCell).datePickerHeight()
        }
        
        return CGFloat(kDefaultCellHeight)
    }
    
    /* Callback for when cell is selected */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Deselect automatically if the cell is a DatePickerCell.
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DatePickerCell)) {
            let pickerTableViewCell = cell as! DatePickerCell
            pickerTableViewCell.selectedInTableView(tableView)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Collapses all other cells
            for (var i = 0; i < cells.count; i++) {
                if (i != indexPath.row && cells[i].expanded == true) {
                    cells[i].selectedInTableView(tableView)
                }
            }
        }
        else if (cell.isKindOfClass(ScrollPickerCell)) {
            let pickerTableViewCell = cell as! ScrollPickerCell
            pickerTableViewCell.selectedInTableView(tableView)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Collapses all other cells
            for (var i = 0; i < cells.count; i++) {
                if (i != indexPath.row && cells[i].expanded == true) {
                    cells[i].selectedInTableView(tableView)
                }
            }
        }
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
        self.saveButton.enabled = true;
    }
    
    /* Called to determine number of sections in tableView */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /* Called to determine number of rows in tableView */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    /* Configures each cell in tableView */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row] as! UITableViewCell
        return cell
    }

}
