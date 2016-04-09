//
//  IntroTutorialVC.swift
//  Surplus
//
//  Created by Eric Tran on 4/8/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import UIKit
import EAIntroView

class IntroTutorialVC: UIViewController, EAIntroDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Build introduction pages
        let page1 = EAIntroPage()
        page1.title = "Page 1 Title";
        page1.desc = "This is page 1 description"
        page1.bgImage = UIImage(named: "bg-1.jpg")
        
        let page2 = EAIntroPage()
        page2.title = "Page 2 Title";
        page2.desc = "This is page 2 description"
        page2.bgImage = UIImage(named: "bg-2.jpg")
        
        // Create introduction view
        let intro = EAIntroView(frame: self.view.bounds, andPages: [page1, page2])
        intro.delegate = self
        
        // Show intro
        intro.showInView(self.view, animateDuration: 0.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - EAIntroDelegate

    func introDidFinish(introView: EAIntroView!) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasSeenTutorial")
        self.performSegueWithIdentifier("introToMain", sender: self)
    }

}
