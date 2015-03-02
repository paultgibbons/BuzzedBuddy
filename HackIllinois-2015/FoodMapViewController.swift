//
//  FoodMapViewController.swift
//  HackIllinois-2015
//
//  Created by Brandon Groff on 2/28/15.
//  Copyright (c) 2015 PointOfIgnition. All rights reserved.
//

import UIKit
import MapKit

class FoodMapViewController : UIViewController {
    
    @IBOutlet weak var foodMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        foodMap.showsUserLocation = true
        let lc = LocationController()
        while(DinerChoices.placeChoice == nil){}
        addResteraunt(lc.getLocation(),  endPoint: DinerChoices.placeChoice)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline{
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            if(overlay.title == "Walk"){
                polylineRenderer.strokeColor = UIColor.blueColor()
            }
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func addNewRoute(source: MKMapItem, destination: MKMapItem ){
        let request:MKDirectionsRequest = MKDirectionsRequest()
        request.setDestination(destination)
        request.setSource(source)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request:request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:MKDirectionsResponse!, error: NSError!) in
            if error != nil{
                //Handle error
                println("THERE'S AN ERROR")
            }
            else{
                self.showRoute(response)
            }
        })
    }
    
    func showRoute(response: MKDirectionsResponse){
        for route in response.routes as [MKRoute]{
            foodMap.addOverlay(route.polyline,level:MKOverlayLevel.AboveRoads)
        }
    }
    
    func addResteraunt(beginPoint: CLLocation, endPoint: MKMapItem){
        let beginplacemark = MKPlacemark( coordinate: beginPoint.coordinate, addressDictionary: nil)
        let beginItem = MKMapItem(placemark: beginplacemark)
        addNewRoute(beginItem,destination: endPoint)
        //foodMap.addAnnotation(endPoint)
        let endplacemark = endPoint.placemark!
        foodMap.addAnnotation(endplacemark)
        var deltaLon:CLLocationDegrees = CLLocationDegrees(0.05)
        var deltaLat = CLLocationDegrees(0.05)
        var span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLon)
        var region:MKCoordinateRegion = MKCoordinateRegion(center: beginPoint.coordinate, span: span)
        foodMap.setRegion(region,animated:true)
        
    }
    
}