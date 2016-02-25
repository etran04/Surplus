//
//  InputChargeVC.swift
//  Surplus
//
//  Created by Eric Tran on 2/23/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit

class InputChargeVC: UIViewController {

    var curOrder: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
}
