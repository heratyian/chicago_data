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
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectID: String?
    var uniqueKey: String
    
    // MARK: Initializers
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as! Double
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as! String
        objectID = dictionary[ParseClient.JSONResponseKeys.objectID] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as! String
    }
    
    static func studentsFromResults(results: [[String:AnyObject]]) -> [ParseStudent] {
        
        var students = [ParseStudent]()
        
        for result in results {
            students.append(ParseStudent(dictionary: result))
        }
        
        return students
    }
}

// MARK: Equatable
extension PlenarioDataPoint: Equatable {}

func ==(lhs: PlenarioDataPoint, rhs: PlenarioDataPoint) -> Bool {
    return lhs.objectID == rhs.objectID
}