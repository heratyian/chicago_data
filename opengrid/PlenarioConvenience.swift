//
//  PlenarioConvenience.swift
//  opengrid
//
//  Created by Ian Heraty on 8/20/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import Foundation

extension PlenarioClient {
    
    // MARK: GET convenience methods
    func getLocations(geoJSONString: String, completionHandlerForLocations: (points: [PlenarioDataPoint]?, error: NSError?) -> Void) {
        
        let parameters: [String:String] = [ PlenarioClient.ParameterKeys.LocationGeomWithin : geoJSONString ]
        
        taskForGetMethod(parameters) { (result, error) in
            if let error = error {
                print(error)
            } else {
                
                if let result = result[ResponseKeys.Objects] as? [[String:AnyObject]] {
//                    print(result)
                    let points = PlenarioDataPoint.pointsFromResults(result)
                    print(points)
                    completionHandlerForLocations(points: points, error: nil)
                } else {
                    completionHandlerForLocations(points: nil, error: NSError(domain: "getLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not parse getLocations"]))
                }
            }
        }
    }
}