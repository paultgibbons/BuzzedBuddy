//
//  CUMTDjson.swift
//  HackIllinois-2015
//
//  Created by Brandon Groff on 2/28/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class CUMTDjson{
    //var jsonDict:NSDictionary = NSDictionary()//Should be changed in init
    
    
    
    
    func getURLFromLatLon(origin_latitude:String, origin_longitude:String,dest_latitude:String,dest_longitude:String)->NSURL{
        let version = "v2.2"
        let format = "json"
        let method = "GetPlannedTripsByLatLon"
        let key = "bc049e9f423e49e7946f069af686ca3d"
        
        let url = NSURL(string: "https://developer.cumtd.com/api/\(version)/\(format)/\(method)?key=\(key)&origin_lat=\(origin_latitude)&origin_lon=\(origin_longitude)&destination_lat=\(dest_latitude)&destination_lon=\(dest_longitude)&minimize=walking")
        return url!
    }
    
    
    func generateBusMap() ->NSDictionary{
        var lcontroller:LocationController = LocationController()
        lcontroller.updateLocation()
        var currentLocation = lcontroller.getLocation()
        
        var curLat:String = "\(currentLocation.coordinate.latitude)"
        var curLon:String = "\(currentLocation.coordinate.longitude)"
        
        let homeLat:String = NSUserDefaults.standardUserDefaults().doubleForKey("latitude").description;
        let homeLon:String = NSUserDefaults.standardUserDefaults().doubleForKey("longitude").description;
        
        var url:NSURL = getURLFromLatLon(curLat, origin_longitude: curLon, dest_latitude: homeLat, dest_longitude: homeLon)
        println(url)
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        var session = NSURLSession.sharedSession()
        
        var error: NSError?
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError) as NSData?
        if let httpResponse = response as NSHTTPURLResponse? {
            println("response code: \(httpResponse.statusCode)")
            var jsonDict = NSJSONSerialization.JSONObjectWithData(urlData!, options: nil, error: &error) as NSDictionary
            let status = jsonDict["status"] as NSDictionary
            if(status["code"] as Int != 200){
                NSException(name: "Failed to get bus schedule",reason: status["msg"] as? String, userInfo: nil).raise()
                return NSDictionary()
            }
            return jsonDict
        } else {
            return NSDictionary()
            //NSException(name: "Failed to get bus schedule",reason: "Could not connect to Internet", userInfo: nil).raise()
            
        }
       //return jsonDict
        //return NSDictionary()
    }
}