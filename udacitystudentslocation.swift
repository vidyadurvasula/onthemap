//
//  udacitystudentslocation.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/3/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import Foundation

struct studentlocation {
    
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectID : String?
    var uniqueKey : String?
    var updatedAt : String?
    
    
    init?(dictionary: [String : AnyObject]) {
        
        // ensure there are corresponding values to each key
        createdAt = dictionary[Client.ResponseKeys.createdAt] != nil ? dictionary[Client.ResponseKeys.createdAt] as? String:""
        firstName = dictionary[Client.ResponseKeys.firstName] != nil ? dictionary[Client.ResponseKeys.firstName] as? String:""
        lastName = dictionary[Client.ResponseKeys.lastName] != nil ? dictionary[Client.ResponseKeys.lastName] as? String:""
        latitude = dictionary[Client.ResponseKeys.latitude] != nil ? dictionary[Client.ResponseKeys.latitude] as? Double:0
        longitude = dictionary[Client.ResponseKeys.longitude] != nil ? dictionary[Client.ResponseKeys.longitude] as? Double:0
        mapString = dictionary[Client.ResponseKeys.mapString] != nil ? dictionary[Client.ResponseKeys.mapString] as? String:""
        mediaURL = dictionary[Client.ResponseKeys.mediaURL] != nil ? dictionary[Client.ResponseKeys.mediaURL] as? String:""
        objectID = dictionary[Client.ResponseKeys.objectId] != nil ? dictionary[Client.ResponseKeys.objectId] as? String:""
        uniqueKey = dictionary[Client.ResponseKeys.uniqueKey] != nil ? dictionary[Client.ResponseKeys.uniqueKey] as? String:""
        updatedAt = dictionary[Client.ResponseKeys.updatedAt] != nil ? dictionary[Client.ResponseKeys.updatedAt] as? String:""
        
    }
    
    
    
    
    
    
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [studentlocation]
    {
        var studentLocations = Student.sharedInstance.studentLocations
        
        for eachLocation in results
        {
            studentLocations.append(studentlocation(dictionary: eachLocation)!)
        }
        return studentLocations
    }
}





