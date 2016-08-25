//
//  PlenarioDataPoint.swift
//  opengrid
//
//  Created by Ian Heraty on 8/21/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import Foundation

struct PlenarioDataPoint {
    // MARK: Properties
    var latitude: Double!
    var longitude: Double!
    var caseNumber: String!
    var primaryType: String!
    var description: String!
    
    // MARK: Initializers
    init(dictionary: [String:AnyObject]) {
        
        latitude = dictionary[PlenarioClient.ResponseKeys.Latitude] as! Double
        longitude = dictionary[PlenarioClient.ResponseKeys.Longitude] as! Double
        caseNumber = dictionary[PlenarioClient.ResponseKeys.CaseNumber] as! String
        primaryType = dictionary[PlenarioClient.ResponseKeys.PrimaryType] as! String
        description = dictionary[PlenarioClient.ResponseKeys.Description] as! String
        
        
    }
    
    static func pointsFromResults(results: [[String:AnyObject]]) -> [PlenarioDataPoint] {
        
        var points = [PlenarioDataPoint]()
 
        for result in results {
//            print(result)
//            print(result["case_number"]!)
            let dataPoint = PlenarioDataPoint(dictionary: result)
//            print(dataPoint)
            points.append(dataPoint)
        }
        
        return points
    }
}

// MARK: Equatable
extension PlenarioDataPoint: Equatable {}

func ==(lhs: PlenarioDataPoint, rhs: PlenarioDataPoint) -> Bool {
    return lhs.caseNumber == rhs.caseNumber
}