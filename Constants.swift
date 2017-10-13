//
//  Constants.swift
//  studentMap
//
//  Created by Vidya Durvasula on 9/29/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import Foundation
extension Client {
    
    // MARK: Constants
    struct Constants {
        static let parseApplicationID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseAPIKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct urlUdacity {
        static let baseURL = "https://www.udacity.com/api"
        static let sessionURL = "https://www.udacity.com/api/session"
        static let userURL = "https://www.udacity.com/api/users"
        static let udacitySignupURL = "https://www.udacity.com/account/auth#!/signup"
        
        static let studentlocationURL : String = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
    
    struct ParameterKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        static let sessionID = "session"
        static let limitKey = "limit"
        static let skipKey = "skip"
        static let orderKey = "order"
    }
    
    struct HttpFields
    {
        static let acceptField = "Accept"
        static let contentTypeField = "Content-Type"
        
        static let parseAppIDKey = "X-Parse-Application-Id"
        static let parseRestAPIKey = "X-Parse-REST-API-Key"
    }
    
    
    
    
    struct ResponseKeys
    {
        static let results = "results"
        
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
        
        
    }
    
    
}
