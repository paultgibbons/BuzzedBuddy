//
//  HomeViewController.swift
//  HackIllinois-2015
//
//  Created by Brandon Groff on 2/28/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var homeMapView: MKMapView!
    
    @IBOutlet weak var navigatorText: UITextView!
    var directions: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad();
        homeMapView.showsUserLocation = true
        homeMapView.delegate = self //May be needed
        var a:CUMTDjson = CUMTDjson()
        
        let jsonDict = a.generateBusMap()
        if(jsonDict == NSDictionary()){
            //The error occured
            let alert = UIAlertController(title: "Failed to get MTD Data", message: "Turn your Icard around and call safe rides",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
                handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        parseJSONDict(jsonDict)
    }
    
    func concatanateStringArray(array: [String]) -> String{
        var result:String = ""
        var i:Int = 1
        for elem in array{
            result += "\(i). " + elem + "\r\n"
            i++
            
        }
        return result
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline{
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            if(overlay.title == "Walk"){
                polylineRenderer.strokeColor = UIColor.blueColor()
            }
            else{
                var color:String = overlay.title!
                var rString:String = color.substringToIndex(advance(color.startIndex, 2))
                var gString:String = color.substringFromIndex(advance(color.startIndex,2)).substringToIndex(advance(color.startIndex,2))
                var bString:String = color.substringFromIndex(advance(color.startIndex,4)).substringToIndex(advance(color.startIndex,2))
                var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
                NSScanner(string: rString).scanHexInt(&r)
                NSScanner(string: gString).scanHexInt(&g)
                NSScanner(string: bString).scanHexInt(&b)
                polylineRenderer.strokeColor = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
            }
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func addNewRoute(source: MKMapItem, destination: MKMapItem, color: String, isWalk: Bool ){
        let request:MKDirectionsRequest = MKDirectionsRequest()
        request.setDestination(destination)
        request.setSource(source)
        request.requestsAlternateRoutes = false
        
        let directionSteps = MKDirections(request:request)
        let i = directions.count
        directions.append("")
        directionSteps.calculateDirectionsWithCompletionHandler({(response:MKDirectionsResponse!, error: NSError!) in
            if error != nil{
                //Handle error
                println("THERE'S AN ERROR")
            }
            else{
                self.showRoute(response, color: color, isWalk: isWalk, index:i)
            }
        })
    }
    func showRoute(response: MKDirectionsResponse, color: String, isWalk: Bool, index: Int){
        for route in response.routes as [MKRoute]{
            route.polyline.title = String(color)
            
            if(isWalk){
                
                for step in route.steps{
                    println(step.instructions)
                    directions[index] += step.instructions + "\n" //.append(step.instructions)
                }
            }
            homeMapView.addOverlay(route.polyline,level:MKOverlayLevel.AboveRoads)
        }
        
//        println(directions)
//        if index == directions.count-1 {
            navigatorText.text = concatanateStringArray(directions)
            navigatorText.textColor = (UIColor .whiteColor())
//            println(navigatorText.text)
//        }
    }
    
    func parseJSONDict(jsonDict:NSDictionary){
        directions = []
        let itineraries = jsonDict["itineraries"] as NSArray
        let itinleg = itineraries[0] as NSDictionary
        let legs =  itinleg["legs"] as NSArray
        println(legs)
        for leg in legs {
            println("Leg \(leg)")
            if leg["type"] as NSString == "Walk" {
                
                let begin = (leg["walk"] as NSDictionary)["begin"] as NSDictionary
                // walk leg
                let end = (leg["walk"] as NSDictionary)["end"] as NSDictionary
                
                let beginlocation = CLLocationCoordinate2D(latitude: begin["lat"] as CLLocationDegrees, longitude: begin["lon"] as CLLocationDegrees)
                let endlocation = CLLocationCoordinate2D(latitude: end["lat"] as CLLocationDegrees, longitude: end["lon"] as CLLocationDegrees)
                let beginplacemark = MKPlacemark(coordinate: beginlocation, addressDictionary: nil)
                let endplacemark = MKPlacemark(coordinate:endlocation, addressDictionary: nil)
                let beginPoint = MKMapItem(placemark: beginplacemark)
                let endPoint = MKMapItem(placemark: endplacemark)
                addNewRoute(beginPoint,destination: endPoint, color: "Walk",isWalk: true)
                homeMapView.addAnnotation(endplacemark)
                
                var deltaLon:CLLocationDegrees = CLLocationDegrees(0.05)
                var deltaLat = CLLocationDegrees(0.05)
                var span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLon)
                var region:MKCoordinateRegion = MKCoordinateRegion(center: beginlocation, span: span)
                homeMapView.setRegion(region,animated:true)
            } else {
                // service leg
                for _service in (leg["services"] as NSArray) {
                    let service = _service as NSDictionary
                    let begin = service["begin"] as NSDictionary
                    let end = service["end"] as NSDictionary
                    
                    let beginlocation = CLLocationCoordinate2D(latitude: begin["lat"] as CLLocationDegrees, longitude: begin["lon"] as CLLocationDegrees)
                    let endlocation = CLLocationCoordinate2D(latitude: end["lat"] as CLLocationDegrees, longitude: end["lon"] as CLLocationDegrees)
                    let beginplacemark = MKPlacemark(coordinate: beginlocation, addressDictionary: nil)
                    let endplacemark = MKPlacemark(coordinate:endlocation, addressDictionary: nil)
                    let beginPoint = MKMapItem(placemark: beginplacemark)
                    let endPoint = MKMapItem(placemark: endplacemark)
                    let color = (service["route"] as NSDictionary)["route_color"] as String
                    addNewRoute(beginPoint,destination: endPoint, color: color, isWalk: false)
                    homeMapView.addAnnotation(endplacemark)
                    
                    let route = service["route"] as NSDictionary
                    let route_id = route["route_id"] as String
                    let stop_id = begin["name"] as String
                    directions.append("Get on the \(route_id) at \(stop_id)")
                    
                    var deltaLon:CLLocationDegrees = CLLocationDegrees(0.05)
                    var deltaLat = CLLocationDegrees(0.05)
                    var span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLon)
                    var region:MKCoordinateRegion = MKCoordinateRegion(center: beginlocation, span: span)
                    homeMapView.setRegion(region,animated:true)
                }
            }
        }
    }
}