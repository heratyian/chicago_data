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
    func getLocations(completionHandlerForLocations: (students: [ParseStudent]?, error: NSError?) -> Void) {
        
        
//        http://plenar.io/v1/api/detail/?dataset_name=crimes_2001_to_present&location_geom__within={"type":"Polygon","coordinates":[[[-87.66600608825684,41.85226942321293],[-87.66643524169922,41.86687633156873],[-87.63918399810791,41.867259837816974],[-87.6384973526001,41.85271694915769],[-87.66600608825684,41.85226942321293]]]}
        
        var parameters: [String:String]?
        
        
        // https://api.parse.com/1/classes/StudentLocation?limit=100
        if let numStudents = numStudents {
            let numStudentsString = String(numStudents)
            parameters = [ParseClient.ParameterKeys.limit : numStudentsString]
        }
        
        taskForGETMethod(ParseClient.Methods.StudentLocation, parameters: parameters) { (result, error) in
            
            if let error = error {
                print(error)
            } else {
                if let result = result[JSONResponseKeys.studentResults] as? [[String:AnyObject]] {
                    let students = ParseStudent.studentsFromResults(result)
                    completionHandlerForLocations(students: students, error: nil)
                } else {
                    completionHandlerForLocations(students: nil, error: NSError(domain: "getStudentLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not parse getStudentLocations"]))
                }
            }
        }
    }
}