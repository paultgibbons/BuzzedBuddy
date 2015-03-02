//
//  ViewController.swift
//  HackIllinois-2015
//
//  Created by Alex Cordonnier on 2/27/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var exButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleText()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        exButton.hidden = !NSUserDefaults.standardUserDefaults().boolForKey("specialSettings");
    }
    
    @IBAction func foodButtonClick(sender: UIButton) {
        
        
    }
    
    @IBAction func homeButtonClick(sender: UIButton) {
        var json:CUMTDjson = CUMTDjson()
        
    }
    
    @IBAction func dialExClick(sender: AnyObject) {
        let number:String = NSUserDefaults.standardUserDefaults().integerForKey("phoneNumber").description;
        var url:NSURL = NSURL(string: "tel://1\( number)")!
        UIApplication.sharedApplication().openURL(url)
    }

    func setTitleText(){
        var food:NSAttributedString = NSAttributedString(string: "Food", attributes: [
            NSForegroundColorAttributeName: (UIColor .whiteColor()) ,NSStrokeWidthAttributeName: -3, NSStrokeColorAttributeName : (UIColor .blackColor())
            ])
        var home:NSAttributedString = NSAttributedString(string: "Home", attributes: [
            NSForegroundColorAttributeName: (UIColor .whiteColor()) , NSStrokeWidthAttributeName: -3, NSStrokeColorAttributeName : (UIColor .blackColor())
            ])
        var ex:NSAttributedString = NSAttributedString(string: "Ex", attributes: [
            NSForegroundColorAttributeName: (UIColor .whiteColor()) , NSStrokeWidthAttributeName: -3, NSStrokeColorAttributeName : (UIColor .blackColor())
            ])
        foodButton.setAttributedTitle(food, forState: UIControlState.Normal);
        homeButton.setAttributedTitle(home, forState: UIControlState.Normal);
        exButton.setAttributedTitle(ex, forState: UIControlState.Normal);
    }

}

