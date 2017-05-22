//
//  PlenarioConvenience.swift
//  opengrid
//
//  Created by Ian Heraty on 8/20/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import Foundation
import MapKit

extension PlenarioClient {
    
    // MARK: GET convenience methods
    func getCrimeLocations(_ geoJSONString: String, completionHandlerForLocations: @escaping (_ points: [PlenarioDataPoint]?, _ error: NSError?) -> Void) {
        
        // parameters
        let parameters: [String:String] = [PlenarioClient.ParameterKeys.LocationGeomWithin : geoJSONString]
        
        // create URL for crime data
        let url = plenarioCrimeURLFromParameters(parameters as [String : AnyObject])
        
        taskForGetMethod(url) { (result, error) in
            if let error = error {
                print(error)
            } else {
                if let result = result?[ResponseKeys.Objects] as? [[String:AnyObject]] {
                    let points = PlenarioDataPoint.pointsFromResults(result)
                    completionHandlerForLocations(points, nil)
                } else {
                    completionHandlerForLocations(nil, NSError(domain: "getLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not parse getLocations"]))
                }
            }
        }
    }
    
    func plenarioCrimeURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        // input: take parameters as [String:AnyObject]
        // return url
        
        var components = URLComponents()
        components.scheme = PlenarioClient.Plenario.APIScheme
        components.host = PlenarioClient.Plenario.APIHost
        components.path = PlenarioClient.Plenario.APIPath
        
        components.queryItems = [URLQueryItem]()
        
        // set first query item to crime dataset
        let queryItem = URLQueryItem(name: PlenarioClient.ParameterKeys.DatasetName, value: "\(PlenarioClient.ParameterValues.DatasetNameCrime)")
        components.queryItems!.append(queryItem)
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // TODO: add timeline and dataset parameters
    func getPlenarioDataPoints(_ centerCoordinate: CLLocationCoordinate2D, latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees, completionHandlerForPlenarioDataPoints: @escaping (_ points:[PlenarioDataPoint]?, _ error: NSError?) -> Void) {
        // input: time start, time end (default today), center coordinate, lat/long delta, dataset
        // return an array of PlenarioDataPoint
        
        // getCornerCoordinates() sw/ne
        // createGeoJSON polygon string
        // getCrimeLocations with GeoJSONString
        // return points
        
        let (sw,ne) = getCornerCoordinates(centerCoordinate, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let geoJSONString = geoJSONPolygonStringFromCoordinates(sw, topRight: ne)
        
//        var pointsArray: [PlenarioDataPoint] = [PlenarioDataPoint]()
        
//        getCrimeLocations(geoJSONString) { (points, error) in
//            if let error = error {
//                print(error)
//                let userInfo = [NSLocalizedDescriptionKey: error]
//                completionHandler(result: nil, error: NSError(domain: "getDataPointsFromPlenarioAPI", code: 1, userInfo: userInfo))
//            } else {
//                if let points = points {
//                    pointsArray = points
//                    completionHandler(result: pointsArray, error: nil)
//                } else {
//                    print("fail")
//
//                    completionHandler(result: nil, error: nil)
//                }
//            }
//        }
//        return pointsArray
        
        // parameters
        let parameters: [String:String] = [PlenarioClient.ParameterKeys.LocationGeomWithin : geoJSONString]
        
        // create URL for crime data
        let url = plenarioCrimeURLFromParameters(parameters as [String : AnyObject])
        
        taskForGetMethod(url) { (result, error) in
            if let error = error {
                print(error)
            } else {
                if let result = result?[ResponseKeys.Objects] as? [[String:AnyObject]] {
                    let points = PlenarioDataPoint.pointsFromResults(result)
                    completionHandlerForPlenarioDataPoints(points, nil)
                } else {
                    completionHandlerForPlenarioDataPoints(nil, NSError(domain: "getLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not parse getLocations"]))
                }
            }
        }

    }
    
//    func getPlenarioDataPointsWithinTimeframe
    func getPlenarioDataPointsWithTimeframe(_ centerCoordinate: CLLocationCoordinate2D, latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees, startDate: Date, endDate: Date, completionHandlerForPlenarioDataPoints: @escaping (_ points:[PlenarioDataPoint]?, _ error: NSError?) -> Void) {
        
        // create dates
        let stringStartDate = plenarioDateStringFromNSDate(startDate)
        let stringEndDate = plenarioDateStringFromNSDate(endDate)
        
        let (sw,ne) = getCornerCoordinates(centerCoordinate, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let geoJSONString = geoJSONPolygonStringFromCoordinates(sw, topRight: ne)
        
        // parameters
        let parameters: [String:String] = [PlenarioClient.ParameterKeys.LocationGeomWithin : geoJSONString,
                                           PlenarioClient.ParameterKeys.StartDate : stringStartDate,
                                           PlenarioClient.ParameterKeys.EndDate : stringEndDate]
        
        // create URL for crime data
        let url = plenarioCrimeURLFromParameters(parameters as [String : AnyObject])
        
        taskForGetMethod(url) { (result, error) in
            if let error = error {
                print(error)
            } else {
                if let result = result?[ResponseKeys.Objects] as? [[String:AnyObject]] {
                    let points = PlenarioDataPoint.pointsFromResults(result)
                    completionHandlerForPlenarioDataPoints(points, nil)
                } else {
                    completionHandlerForPlenarioDataPoints(nil, NSError(domain: "getLocations", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not parse getLocations"]))
                }
            }
        }
    }
    
    fileprivate func getCornerCoordinates(_ centerCoordinate: CLLocationCoordinate2D, latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees) -> (sw: [Double], ne: [Double]) {
        // return tuple with sw,ne [latitude, longitude] coordinates
//        let centerCoordinate = CLLocationCoordinate2DMake(self.mapView.region.center.latitude, self.mapView.region.center.longitude)
        
        // CLLocationCoordinate2D(latitude: 41.883229, longitude: -87.632397999999995)
        
//        let latD = self.mapView.region.span.latitudeDelta
//        let longD = self.mapView.region.span.longitudeDelta
        
        let lat1 = centerCoordinate.latitude + latitudeDelta/2
        let lat2 = centerCoordinate.latitude - latitudeDelta/2
        let long1 = centerCoordinate.longitude + longitudeDelta
        let long2 = centerCoordinate.longitude - longitudeDelta
        
        // origin = lat1, long2
        let sw = [long2,lat2]
        let ne = [long1,lat1]
        
        return (sw,ne)
    }
    
    fileprivate func geoJSONPolygonStringFromCoordinates(_ bottomLeft: [Double], topRight: [Double]) -> String {
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
    
    fileprivate func plenarioDateStringFromNSDate(_ date: Date) -> String {
        // input: NSDate object
        // output: YYYY-MM-DD
        
        // set date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-M-d"
        return formatter.string(from: date)
    }
    
    

}
