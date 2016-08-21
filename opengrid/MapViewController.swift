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

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var placemark: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hardCodedCity = "Chicago, IL"
        self.setLocation(hardCodedCity)
        
        /* Create geo json dict */
        // bottom left
        let CERMAK_ASHLAND = [-87.66643524169922, 41.86681241363702]
        // top right
        let ROOSEVELT_CANAL = [-87.639255, 41.866802]

        
//        let coordinate_a = [-87.66600608825684,41.85226942321293] top right
//        let coordinate_b = [-87.66643524169922,41.86687633156873] bottom right
//        let coordinate_c = [-87.63918399810791,41.867259837816974] bottom left
//        let coordinate_d = [-87.6384973526001,41.85271694915769] top left
        
//        let coordinates = [coordinate_a, coordinate_b, coordinate_c, coordinate_d, coordinate_a]
        
        let geoJSONDictionaryString = geoJSONPolygonStringFromCoordinates(CERMAK_ASHLAND, topRight: ROOSEVELT_CANAL)
        
        /* create URL */
        
        let methodParameters: [String: AnyObject!] = [ PlenarioClient.ParameterKeys.LocationGeomWithin : geoJSONDictionaryString ]
       
        let url = plenarioURLFromParameters(methodParameters)
        
        print(url)
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
            region.span.longitudeDelta /= 1200.0
            region.span.latitudeDelta /= 1200.0
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

