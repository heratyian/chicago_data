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
        static let ID = "id"
        static let CaseNumber = "case_number"
        static let Date = "date"
        static let Block = "block"
        static let IUCR = "iucr"
        static let PrimaryType = "primary_type"
        static let Description = "description"
        static let LocationDescription = "location_description"
        static let Arrest = "arrest"
        static let Domestic = "domestic"
        static let Beat = "beat"
        static let District = "district"
        static let Ward = "ward"
        static let CommunityArea = "community_area"
        static let FBICode = "fbi_code"
        static let XCoordinate = "x_coordinate"
        static let YCoordinate = "y_coordinate"
        static let Year = "year"
        static let UpdatedOn = "updated_on"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Location = "location"
    }
    
    
}