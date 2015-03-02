//
//  MapsController.swift
//  HackIllinois-2015
//
//  Created by Brandon Groff on 2/28/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//

import MapKit

public class MapsController : MKMapView, MKMapViewDelegate {
    
    //var routeMap:MKMapView
    
    override init(){
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.showsUserLocation = true
//        self.delegate = self
//        var a:CUMTDjson = CUMTDjson()
//        let jsonDict = a.generateBusMap()
//        parseJSONDict(jsonDict)
//        //fatalError("init(coder:) has not been implemented")
//        //mapView(this,
    }

    
//    func addNewRoute(source: MKMapItem, destination: MKMapItem ){
//        let request:MKDirectionsRequest = MKDirectionsRequest()
//        request.setDestination(destination)
//        request.setSource(source)
//        request.requestsAlternateRoutes = false
//        
//        let directions = MKDirections(request:request)
//        
//        directions.calculateDirectionsWithCompletionHandler({(response:MKDirectionsResponse!, error: NSError!) in
//            if error != nil{
//                //Handle error
//                println("THERE'S AN ERROR")
//            }
//            else{
//                println("Printing route?")
//                self.showRoute(response)
//            }
//        })
//    }
//    func showRoute(response: MKDirectionsResponse){
//        for route in response.routes as [MKRoute]{
//            println("There is a route")
//            self.addOverlay(route.polyline,level:MKOverlayLevel.AboveRoads)
//           // for step in route.steps{
//             //   println(step.instructions)
//            //}
//        }
//        
//    }
//    
//    func parseJSONDict(jsonDict:NSDictionary){
//        //println("running")
//        // println(jsonDict)
//        let itineraries = jsonDict["itineraries"] as NSArray
//        let itinleg = itineraries[0] as NSDictionary
//        let legs =  itinleg["legs"] as NSArray
//        //println(jsonDict)
//        //println(itineraries)
//        println(legs)
//        for i in 0...legs.count - 1 {
//            let leg = legs[i] as NSDictionary
//            if leg["type"] as NSString == "Walk" {
//                
//                let begin = (leg["walk"] as NSDictionary)["begin"] as NSDictionary
//                // walk leg
//                let end = (leg["walk"] as NSDictionary)["end"] as NSDictionary
//                let beginlocation = CLLocationCoordinate2D(latitude: begin["lat"] as CLLocationDegrees, longitude: begin["lon"] as CLLocationDegrees)
//                //CLLocationCoordinate2D(latitude: <#CLLocationDegrees#>, longitude: <#CLLocationDegrees#>)
//                let endlocation = CLLocationCoordinate2D(latitude: end["lat"] as CLLocationDegrees, longitude: end["lon"] as CLLocationDegrees)
//                //MKPlacemark(coordinate: <#CLLocationCoordinate2D#>, addressDictionary: <#[NSObject : AnyObject]!#>)
//                let beginplacemark = MKPlacemark(coordinate: beginlocation, addressDictionary: nil)
//                let endplacemark = MKPlacemark(coordinate:endlocation, addressDictionary: nil)
//                let beginPoint = MKMapItem(placemark: beginplacemark)
//                let endPoint = MKMapItem(placemark: endplacemark)
//                addNewRoute(beginPoint,destination: endPoint)
//                let testStart = CLLocationCoordinate2DMake(40.000, -88.0000)
//                let testEnd = CLLocationCoordinate2DMake(41.000,  -89.0000)
//                
//                let testStartPlacemark = MKPlacemark(coordinate: testStart, addressDictionary:nil)
//                let testEndPlacemark = MKPlacemark(coordinate: testEnd, addressDictionary:nil)
//                let testBeginPoint = MKMapItem(placemark: testStartPlacemark)
//                let testEndPoint = MKMapItem(placemark: testEndPlacemark)
//                
//                addNewRoute(testBeginPoint, destination: testEndPoint)
//                
//                
//            } else {
//                // service leg
//                //for service in
//            }
//        }
//    }
}