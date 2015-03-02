//
//  DinerChoiceViewController.swift
//  HackIllinois-2015
//
//  Created by Brandon Groff on 2/28/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//
import MapKit
import UIKit
import MapKit

class DinerChoiceViewController : UIViewController {
    
    var choices: [MKMapItem]!
    
    @IBOutlet var locationButtons: [UIButton]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Get the choices
        if DinerChoices.typeChoice == "burger" {
            choices = DinerChoices.burgersPlaces
        } else if DinerChoices.typeChoice == "taco" {
            choices = DinerChoices.tacosPlaces
        } else if DinerChoices.typeChoice == "pizza" {
            choices = DinerChoices.pizzaPlaces
        }
        
        for i in 0...(locationButtons.count - 1) {
            var button = locationButtons[i]
            button.setTitle(choices[i].name, forState: UIControlState.Normal)
        }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func locationClick(sender: UIButton) {
        for i in 0...(locationButtons.count - 1) {
            if locationButtons[i] == sender {
                DinerChoices.placeChoice = choices[i]
            }
        }
    }
    
    
}