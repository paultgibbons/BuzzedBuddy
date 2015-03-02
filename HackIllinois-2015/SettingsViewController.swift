//
//  SettingsViewController.swift
//  HackIllinois-2015
//
//  Created by Brandon Groff on 2/28/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController : UIViewController, UITextFieldDelegate {
    
    var latitude:Double = 0.0;
    var longitude:Double = 0.0;
    var address:NSString = "";
    var phoneNumber = 0;
    
    
    
    @IBOutlet weak var settingsSwitch: UISwitch!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressStatusLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.loadSettings()
        addressStatusLabel.hidden = true;
        if (!NSUserDefaults.standardUserDefaults().boolForKey("specialSettings"))
        {//if special settings are disabled, hide phone number field
            numberTextField.hidden = true;
            phoneNumberLabel.hidden = true;
            settingsSwitch.setOn(false, animated: true);
        }
        else {
            settingsSwitch.setOn(true, animated: true);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addressTextField.delegate = self
        numberTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.hashValue == addressTextField.hashValue) {
            self.validateAddress(textField.text);
        } else {
            if let number = numberTextField.text.toInt() {
                self.phoneNumber = number
            }
        }
    }
    
    @IBAction func specialSettingsSwitched(sender: UISwitch) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("specialSettings")){ //was enabled, now diabled
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "specialSettings")
            numberTextField.hidden = true
            phoneNumberLabel.hidden = true
            
        } else { //was disabled, now enabled
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "specialSettings")
            numberTextField.hidden = false
            phoneNumberLabel.hidden = false
        }
    }
    
    func specialSettingsExist()->Bool{
        var switchState:Bool = NSUserDefaults.standardUserDefaults().boolForKey("specialSettings")
        if (switchState){
            return true
        } else if (!switchState){
            return false;
        } else {
            NSUserDefaults.standardUserDefaults().setBool(SettingsKey.defaultSettingsMode, forKey: "specialSettings")
            return false;
        }
    }
    
    @IBAction func saveSettingsClick(sender: UIBarButtonItem) {
        let status: NSString = addressStatusLabel.text!;
        if (status.isEqualToString("Address found!") || self.phoneNumber != 0){
            self.saveSettings();
            savePopUp("Settings saved!", message: "Woo!");
        } else {
            savePopUp("Settings could not be saved!", message: "Please hit 'Done' before hitting save.");
        }
    }
    
    func loadSettings(){
        if(self.locationSettingsAlreadySet()){
            self.addressTextField.placeholder = NSUserDefaults.standardUserDefaults().stringForKey("homeAddress");
            
        } else {
            self.addressTextField.placeholder = SettingsKey.defaultHomeAddress;
        }
        if (self.phoneSettingsSet()){
            self.numberTextField.placeholder = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber");
        } else {
            self.numberTextField.placeholder = String(SettingsKey.defaultNumber);
        }
        //
    }
    
    func locationSettingsAlreadySet()->Bool {
        if (nil == NSUserDefaults.standardUserDefaults().stringForKey("homeAddress")?.hashValue){
            return false;
        }
        var latitude:Double = NSUserDefaults.standardUserDefaults().doubleForKey("latitude");
        var longitude:Double = NSUserDefaults.standardUserDefaults().doubleForKey("longitude");
        var address:String = NSUserDefaults.standardUserDefaults().stringForKey("homeAddress")!;
        
        if (latitude == 0.0){
            return false;
        } else if (longitude == 0.0){
            return false;
        } else if((address.isEmpty)) {
            return false;
        } else {
           return true;
        }
        
    }
    
    func phoneSettingsSet()->Bool {
        var phoneNumber: Int = NSUserDefaults.standardUserDefaults().integerForKey("phoneNumber")
        if (phoneNumber == SettingsKey.defaultNumber ||
            phoneNumber == 0){
            return false;
        } else {
            return true;
        }
    }
    
    func saveSettings(){
        NSUserDefaults.standardUserDefaults().setDouble(self.latitude, forKey: "latitude");
        NSUserDefaults.standardUserDefaults().setDouble(self.longitude, forKey: "longitude");
        if (!self.address.isEqualToString("")){ //if string NOT empty
            NSUserDefaults.standardUserDefaults().setValue(self.address as String, forKey: "homeAddress");
        }
        if (self.phoneNumber != 0){
            NSUserDefaults.standardUserDefaults().setInteger(self.phoneNumber, forKey: "phoneNumber");
        }
    }
    
    func validateAddress(address: NSString)->Void {
        var request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
        
        let localSearch: MKLocalSearch = MKLocalSearch(request: request)
        localSearch.startWithCompletionHandler { (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            if (error == nil) {
                if response.mapItems.count == 0 {
                    self.addressStatusLabel.text = "Address not found!";
                    //NSException()
                } else {
                    let loc = response.mapItems[0] as MKMapItem
                    self.latitude = loc.placemark.location.coordinate.latitude as Double;
                    self.longitude = loc.placemark.location.coordinate.longitude as Double;
                    
                    let delimiters: NSCharacterSet = NSCharacterSet(charactersInString: ",@");
                    var addressArray = loc.placemark.description
                        .componentsSeparatedByCharactersInSet(delimiters);
                    var homeAddress = addressArray[1] + "," + addressArray[2];
                    homeAddress += "," + addressArray[3];
                    
                    self.address = homeAddress;
                    self.addressStatusLabel.text = "Address found!";
                }
            } else {
                self.addressStatusLabel.text = "Address not found!";
            }
            self.addressStatusLabel.hidden = false
        }
        return;
    }
    
    func savePopUp(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}