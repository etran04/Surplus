//
//  ViewController.swift
//  Surplus
//
//  Created by Daniel Lee on 1/31/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let facebookButton = FBSDKLoginButton()
        facebookButton.center = self.view.center
        self.view.addSubview(facebookButton)

        // Create a UIButton styled for sharing to messenger. You can leave
        // the size at its default (365, 45) or change the size yourself
        var messengerButton = FBSDKMessengerShareButton.circularButtonWithStyle(.Blue)
        messengerButton.addTarget(self, action: "shareButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(messengerButton)
    }
    
    func shareButtonPressed() {
        print("share putton pressed")
        FBSDKMessengerSharer.openMessenger()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

