//
//  FoodViewController.swift
//  HackIllinois-2015
//
//  Created by Brandon Groff on 2/28/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//

import UIKit
import MapKit

class FoodViewController : UIViewController {
    
    
    @IBOutlet var foodSelectionButtons: [UIButton]!
    var locationController: LocationController!
    
    enum Weekdays: Int {
        case Sunday = 1
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in foodSelectionButtons {
            //Disable all the buttons at first
            button.enabled = false
        }
        
        locationController = LocationController()
        doSearch("burger")
        doSearch("taco")
        doSearch("pizza")
    }
    
    @IBAction func bugerButtonClick(sender: UIButton) {
        DinerChoices.typeChoice = "burger"
    }
    
    @IBAction func tacoButtonClick(sender: UIButton) {
        DinerChoices.typeChoice = "taco"
    }
    
    @IBAction func pizzaButtonClick(sender: UIButton) {
        DinerChoices.typeChoice = "pizza"
    }
    
    @IBAction func crackedButtonClick(sender: UIButton) {
        //Figure out where the trucks are
        let currentLocation = locationController.getLocation()
        let billMurrayCoords = getBillMurrayCoords()?
        let ronSwansonCoords = getRonSwansonCoords()?
        
        var billMurrayPlacemark: MKPlacemark?
        var ronSwansonPlacemark: MKPlacemark?
        var billMurray: MKMapItem?
        var ronSwanson: MKMapItem?
        if billMurrayCoords != nil {
            billMurrayPlacemark = MKPlacemark(
                coordinate: billMurrayCoords!,
                addressDictionary: nil)
            billMurray = MKMapItem(placemark: billMurrayPlacemark)
            billMurray!.name = "Cracked (Bill Murray)"
        }
        if ronSwansonCoords != nil {
            ronSwansonPlacemark = MKPlacemark(
                coordinate: ronSwansonCoords!,
                addressDictionary: nil)
            ronSwanson = MKMapItem(placemark: ronSwansonPlacemark)
            ronSwanson!.name = "Cracked (Ron Swanson)"
        }
        
        //Pick the closest truck
        if billMurray == nil && ronSwanson == nil {
            //Both are closed. Pop up and don't let the user continue.
            let alert = UIAlertController(title: "Cracked is Closed",
                message: "Sorry! Cracked isn't open.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if billMurray == nil {
            DinerChoices.placeChoice = ronSwanson
            return
        }
        
        if ronSwanson == nil {
            DinerChoices.placeChoice = billMurray
            return
        }
        
        if distance(billMurrayCoords!, b: currentLocation.coordinate) <
            distance(ronSwansonCoords!, b: currentLocation.coordinate) {
                DinerChoices.placeChoice = billMurray
        } else {
            DinerChoices.placeChoice = ronSwanson
        }
    }
    
    func getBillMurrayCoords() -> CLLocationCoordinate2D? {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitWeekday, fromDate: date)
        let hour = components.hour
        let weekday = components.weekday
        
        var coords: CLLocationCoordinate2D!
        
        if weekday >= Weekdays.Wednesday.rawValue &&
            weekday <= Weekdays.Friday.rawValue &&
            hour >= 8 &&
            hour < 15 {
                //GOODWIN & OREGON
                coords = CLLocationCoordinate2D(latitude: 40.107484, longitude: -88.223840)
        } else if (weekday == Weekdays.Monday.rawValue &&
                hour >= 23) ||
            (weekday == Weekdays.Tuesday.rawValue &&
                hour < 3) {
                //MONDAY NIGHT JOE’S
                coords = CLLocationCoordinate2D(latitude: 40.109734, longitude: -88.232021)
        } else if (weekday == Weekdays.Tuesday.rawValue &&
                hour >= 23) ||
            (weekday == Weekdays.Wednesday.rawValue &&
                hour < 3) ||
            (weekday == Weekdays.Wednesday.rawValue &&
                hour >= 23) ||
            (weekday == Weekdays.Thursday.rawValue &&
                hour < 3)  ||
            (weekday == Weekdays.Thursday.rawValue &&
                hour >= 23) ||
            (weekday == Weekdays.Friday.rawValue &&
                hour < 3) {
                //4TH & GREEN ST.
                coords = CLLocationCoordinate2D(latitude: 40.110237, longitude: -88.233388)
        } else if (weekday == Weekdays.Saturday.rawValue ||
            weekday == Weekdays.Sunday.rawValue) &&
            hour >= 10 &&
            hour < 15 {
                //GREEN & WRIGHT ST.
                coords = CLLocationCoordinate2D(latitude: 40.110237, longitude: -88.228905)
        } else {
            coords = nil
        }
        return coords
    }
    
    func getRonSwansonCoords() -> CLLocationCoordinate2D? {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitWeekday, fromDate: date)
        let hour = components.hour
        let weekday = components.weekday
        
        var coords: CLLocationCoordinate2D!
        
        if ((weekday == Weekdays.Monday.rawValue ||
            weekday == Weekdays.Thursday.rawValue) &&
            hour >= 8 &&
            hour < 16) ||
            ((weekday == Weekdays.Tuesday.rawValue ||
                weekday == Weekdays.Wednesday.rawValue ||
                weekday == Weekdays.Friday.rawValue) &&
                hour >= 8 &&
                hour < 17) {
                //MATHEWS & SPRINGFIELD
                coords = CLLocationCoordinate2D(latitude: 40.112687, longitude: -88.225605)
        } else if (weekday == Weekdays.Saturday.rawValue &&
            hour >= 23) ||
            (weekday == Weekdays.Sunday.rawValue &&
                hour < 3) {
                    //NEIL & UNIVERSITY
                    coords = CLLocationCoordinate2D(latitude: 40.116293, longitude: -88.243530)
        } else {
            coords = nil
        }

        return coords
    }
    
    func doSearch(foodType: String) {
        //Get the location
        let location = locationController.updateLocation()
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = foodType
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            self.updateDinerChoices(response.mapItems as [MKMapItem], foodType: foodType)
        }
        
    }
    
    func distance(a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> Double {
        let latDist = a.latitude - b.latitude
        let longDist = a.longitude - b.longitude
        return sqrt(pow(latDist, 2) + pow(longDist, 2))
    }
    
    func updateDinerChoices(places: [MKMapItem], foodType: String) {
        var p = places
        let location = locationController.getLocation()
        p.sort({ self.distance($0.placemark.coordinate, b: location.coordinate) < self.distance($1.placemark.coordinate, b: location.coordinate) })
        if foodType == "burger" {
            DinerChoices.burgersPlaces = p
        } else if foodType == "taco" {
            DinerChoices.tacosPlaces = p
        } else if foodType  == "pizza" {
            DinerChoices.pizzaPlaces = p
        }
        
        if !DinerChoices.burgersPlaces.isEmpty &&
            !DinerChoices.tacosPlaces.isEmpty &&
            !DinerChoices.pizzaPlaces.isEmpty {
                //Enable all the buttons if everything has loaded
                for button in foodSelectionButtons {
                    button.enabled = true
                }
        }
    }
    
}