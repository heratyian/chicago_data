//
//  ViewController.swift
//  opengrid
//
//  Created by Ian Heraty on 8/20/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import UIKit
import GeoJSON

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let coordinate_a = [-87.66600608825684,41.85226942321293]
        let coordinate_b = [-87.66643524169922,41.86687633156873]
        let coordinate_c = [-87.63918399810791,41.867259837816974]
        let coordinate_d = [-87.6384973526001,41.85271694915769]
        
        let coordinates = [[coordinate_a, coordinate_b, coordinate_c, coordinate_d, coordinate_a]]
        
        let geoJSONDictionary: [String: AnyObject] = [
            "coordinates": coordinates,
            "type": "Polygon"
        ]
        
        guard let polygon = GeoJSONPolygon(dictionary: geoJSONDictionary) else { return }
        print(polygon.dictionaryRepresentation)
        
        /*
         [properties: {
         }, geometry: {
         coordinates =     (
         "-77.59545300000001",
         "43.155059"
         );
         type = Point;
         }, type: Feature] 
         */
    }

    
    
    

}

