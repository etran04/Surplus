//
//  InputChargeVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/23/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

/* This class represents the page at which students with plus dollars will use to input how much they spent, and then
 * ask the buyer for how much is charged */
class InputChargeVC: UIViewController, UITextFieldDelegate {
    
    /* Reference to the UI components */
    @IBOutlet weak var finalChargeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var discountLabel: UILabel!
    
    /* A reference to the current order the page represents */
    var curOrder: Order?
    /* A reference to the string of the charge */
    var currentCharge = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.textAlignment = .Center
        
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InputChargeVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Disables done button until valid charge is entered
        self.doneButton.enabled = false
        
        //self.finalChargeLabel.hidden = true
        self.textField.delegate = self
        
        let discount = curOrder?.discount
        self.discountLabel.text = "After \(discount!)% discount"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Calls when cancel button is pressed
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

    // Calls when done button is pressed
    @IBAction func donePressed(sender: UIBarButtonItem) {
        if (currentCharge != "") {
            if let navController = self.navigationController {
                FirebaseClient.doesOrderExist(self.curOrder!.id, completion: { (exists) in
                    if (exists) {
                        FirebaseClient.completeOrder(self.curOrder!.id)
                    }
                })
                navController.popViewControllerAnimated(true)
            }
        }
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK : Textfield delegate
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("test")
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // TODO: Figure out why back button doesn't work on the numpad 
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            doneButton.enabled = true
            currentCharge += string
            formatCurrency(currentCharge)
        default:
            doneButton.enabled = true
            let array = Array(arrayLiteral: string)
            var currentStringArray = Array(arrayLiteral: currentCharge)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentCharge = ""
                for character in currentStringArray {
                    currentCharge += String(character)
                }
                formatCurrency(currentCharge)
            }
        }
        return false
    }
    
    func formatCurrency(string: String) {
        let formatter = NSNumberFormatter()
        let discount = Double(Int((curOrder?.discount)!)!) / 100.0
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let numberFromField = (NSString(string: currentCharge).doubleValue) / 100
        textField.text = formatter.stringFromNumber(numberFromField)
        finalChargeLabel.text = formatter.stringFromNumber(numberFromField - (numberFromField * discount))
    }
}
