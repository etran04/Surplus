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
        page1.title = "Do you even lift bro?";
        page1.desc = "This is page 1 description"
        page1.bgImage = UIImage(named: "bg-1.jpg")
        
        let testFrame : CGRect = CGRectMake(25,200,325,200)
        let testView : UIView = UIView(frame: testFrame)
        testView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        testView.alpha=0.5
        testView.tag = 100
        
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Test Button", forState: UIControlState.Normal)
        //button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        testView.addSubview(button)

        page1.subviews = [UIView]()
        page1.subviews.append(testView)
        
        let page2 = EAIntroPage()
        page2.title = "Select Payment Preferences";
        page2.desc = "This is page 2 description"
        page2.bgImage = UIImage(named: "bg-2.jpg")
        
        let page3 = EAIntroPage()
        page3.title = "Page 3 Title";
        page3.desc = "This is page 3 description"
        page3.bgImage = UIImage(named: "bg-3.jpg")
        
        // Create introduction view
        let intro = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])
        intro.delegate = self
        intro.skipButton.hidden = true
        
        // Show intro
        intro.showInView(self.view, animateDuration: 0.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - EAIntroDelegate

    func introDidFinish(introView: EAIntroView!) {
//        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasSeenTutorial")
        self.performSegueWithIdentifier("introToMain", sender: self)
    }

}
