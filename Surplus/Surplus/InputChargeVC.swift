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

    var curOrder: Order?
    var currentString = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if let navController = self.navigationController {
            FirebaseClient.completeOrder(curOrder!.id)
            navController.popViewControllerAnimated(true)
        }
    }
    
    // MARK : Textfield delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            formatCurrency(currentString)
        default:
            let array = Array(arrayLiteral: string)
            var currentStringArray = Array(arrayLiteral: currentString)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentString = ""
                for character in currentStringArray {
                    currentString += String(character)
                }
                formatCurrency(currentString)
            }
        }
        return false
    }
    
    func formatCurrency(string: String) {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        textField.text = formatter.stringFromNumber(numberFromField)
        finalChargeLabel.text = formatter.stringFromNumber(numberFromField - (numberFromField * kPercentDiscount))
    }
}
