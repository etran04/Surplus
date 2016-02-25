//
//  InputChargeVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/23/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

let kPercentDiscount = 0.10

class InputChargeVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var finalChargeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var curOrder: Order?
    var currentCharge = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.textAlignment = .Center
        
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Disables done button until valid charge is entered
        self.doneButton.enabled = false
        
        //self.finalChargeLabel.hidden = true
        self.textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
        if (currentCharge != "") {
            if let navController = self.navigationController {
                FirebaseClient.completeOrder(curOrder!.id)
                navController.popViewControllerAnimated(true)
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK : Textfield delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
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
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let numberFromField = (NSString(string: currentCharge).doubleValue)/100
        textField.text = formatter.stringFromNumber(numberFromField)
        finalChargeLabel.text = formatter.stringFromNumber(numberFromField - (numberFromField * kPercentDiscount))
    }
}
