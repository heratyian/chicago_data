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
    var date: String!
    var communityArea: String!
    var ward: Int!
    
//    static let ID = "id"
//    static let Date = "date"
//    static let Block = "block"
//    static let IUCR = "iucr"
//    static let LocationDescription = "location_description"
//    static let Arrest = "arrest"
//    static let Domestic = "domestic"
//    static let Beat = "beat"
//    static let District = "district"
//    static let Ward = "ward"
//    static let CommunityArea = "community_area"
//    static let FBICode = "fbi_code"
//    static let XCoordinate = "x_coordinate"
//    static let YCoordinate = "y_coordinate"
//    static let Year = "year"
//    static let UpdatedOn = "updated_on"
//    static let Location = "location"
    
    
    // MARK: Initializers
    init(dictionary: [String:AnyObject]) {
        
        latitude = dictionary[PlenarioClient.ResponseKeys.Latitude] as! Double
        longitude = dictionary[PlenarioClient.ResponseKeys.Longitude] as! Double
        caseNumber = dictionary[PlenarioClient.ResponseKeys.CaseNumber] as! String
        primaryType = dictionary[PlenarioClient.ResponseKeys.PrimaryType] as! String
        description = dictionary[PlenarioClient.ResponseKeys.Description] as! String
        
        date = dictionary[PlenarioClient.ResponseKeys.Date] as! String
        communityArea = dictionary[PlenarioClient.ResponseKeys.CommunityArea] as! String
        ward = dictionary[PlenarioClient.ResponseKeys.Ward] as! Int
        
        
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