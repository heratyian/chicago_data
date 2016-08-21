//
//  ViewController.swift
//  opengrid
//
//  Created by Ian Heraty on 8/20/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import UIKit
import GeoJSON
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var placemark: MKPlacemark?
    
    @IBAction func touchedMyButton(sender: AnyObject) {
        let centerCoordinate = CLLocationCoordinate2DMake(self.mapView.region.center.latitude, self.mapView.region.center.longitude)
        
//        CLLocationCoordinate2D(latitude: 41.883229, longitude: -87.632397999999995)
        print(centerCoordinate)
        
        
        // call plenario api
        
        // get bottom / left
        // get top / right
        let latD = self.mapView.region.span.latitudeDelta
        let longD = self.mapView.region.span.longitudeDelta
        
        let lat1 = centerCoordinate.latitude + latD/2
        let lat2 = centerCoordinate.latitude - latD/2
        let long1 = centerCoordinate.longitude + longD
        let long2 = centerCoordinate.longitude - longD
        
        
        // origin = lat1, long2
        // sw = lat2, long2
        // ne = lat1, long1
        let sw = [long2,lat2]
        let ne = [long1,lat1]
        print(sw)
        print(ne)
        
        let geoJSONString = geoJSONPolygonStringFromCoordinates(sw, topRight: ne)
        print(geoJSONString)
        

        /* create URL */
        
        let methodParameters: [String: AnyObject!] = [ PlenarioClient.ParameterKeys.LocationGeomWithin : geoJSONString ]
        
        let url = plenarioURLFromParameters(methodParameters)
        
        print(url)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let hardCodedCity = "Chicago, IL"
        self.setLocation(hardCodedCity)
        
        
    }
    
    private func setLocation(city: String) {
        let geocoder = CLGeocoder()
        
        
        geocoder.geocodeAddressString(city) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else {
                print("could not find placemarks")
                return
            }
            
            guard placemarks.count > 0 else {
                print("no results")
                return
            }
            
            let topResult: CLPlacemark = placemarks[0]
            self.placemark = MKPlacemark(placemark: topResult)
            
            var region: MKCoordinateRegion = self.mapView.region
            region.center = (self.placemark!.location?.coordinate)!
            region.span.longitudeDelta /= 2200.0
            region.span.latitudeDelta /= 2200.0
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(self.placemark!)
        }
        
        
    }
    
    private func geoJSONPolygonStringFromCoordinates(bottomLeft: [Double], topRight: [Double]) -> String {
        // input: bottom left and top right coordinates, return geoJSON string
        // output:
        // {"type":"Polygon","coordinates":[[[-87.66600608825684,41.85226942321293],[-87.66643524169922,41.86687633156873],[-87.63918399810791,41.867259837816974],[-87.6384973526001,41.85271694915769],[-87.66600608825684,41.85226942321293]]]}
        
        let topLeft = [topRight[0], bottomLeft[1]]
        let bottomRight = [bottomLeft[0], topRight[1]]
        
        let coordinates = "[[\(topRight),\(bottomRight),\(bottomLeft),\(topLeft),\(topRight)]]"
        
        let geoJSONDictionary = "{\"type\":\"Polygon\",\"coordinates\":\(coordinates)}"
        print(geoJSONDictionary)
        return geoJSONDictionary
    }
    
    private func plenarioURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        // take parameters, return url
        
        
        let components = NSURLComponents()
        components.scheme = PlenarioClient.Plenario.APIScheme
        components.host = PlenarioClient.Plenario.APIHost
        components.path = PlenarioClient.Plenario.APIPath
        
        components.queryItems = [NSURLQueryItem]()
        
        let queryItem = NSURLQueryItem(name: PlenarioClient.ParameterKeys.DatasetName, value: "\(PlenarioClient.ParameterValues.DatasetNameCrime)")
        components.queryItems!.append(queryItem)
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }


    
    
    

}

