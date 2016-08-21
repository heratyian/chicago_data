//
//  PlenarioConstants.swift
//  opengrid
//
//  Created by Ian Heraty on 8/20/16.
//  Copyright © 2016 Ian Heraty. All rights reserved.
//

import Foundation

extension PlenarioClient {
    
    struct Plenario {
        static let APIScheme = "http"
        static let APIHost = "plenar.io"
        static let APIPath = "/v1/api/detail/"
    }
    
    struct ParameterKeys {
        static let DatasetName = "dataset_name"
        static let LocationGeomWithin = "location_geom__within"
    }
    
    struct ParameterValues {
        static let DatasetNameCrime = "crimes_2001_to_present"
    }
    
    struct ResponseKeys {
        
    }
    
    struct ResponseValues {
        
    }
    
}