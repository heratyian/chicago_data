//
//  PlenarioClient.swift
//  opengrid
//
//  Created by Ian Heraty on 8/20/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import Foundation

class PlenarioClient: NSObject {
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    func taskForGetMethod(parameters: [String:String], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        print(parameters)
        let url = plenarioURLFromParameters(parameters)
        let request = NSMutableURLRequest(URL: url)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
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

    
    // MARK: Shared Instance
    class func sharedInstance() -> PlenarioClient {
        struct Singleton {
            static var sharedInstance = PlenarioClient()
        }
        return Singleton.sharedInstance
    }
}