//
//  PaymentMethodCell.swift
//  Surplus
//
//  Created by Ryan Lee on 2/27/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentMethodSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func changedPaymentPref(sender: AnyObject) {
        let obj = sender as! UISwitch
        
        // IF switch is from account type
        if (obj.tag == 1) {
            UserProfile.setType(obj.on)
        }
        else {
            FirebaseClient.getPaymentPreferences(FBUserInfo.id!, completion: { (result: [String]) -> Void in
                var currentPrefs = result
                
                if(self.paymentMethodSwitch.on && !currentPrefs.contains(self.paymentMethodLabel.text!)) {
                    currentPrefs.append(self.paymentMethodLabel.text!)
                }
                else if(!self.paymentMethodSwitch.on && currentPrefs.contains(self.paymentMethodLabel.text!)) {
                    currentPrefs.removeAtIndex(currentPrefs.indexOf(self.paymentMethodLabel.text!)!)
                }
                //print(currentPrefs)
                
                FirebaseClient.setPaymentPreferences(currentPrefs)
            })
        }
    }
}
