//
//  userinfo.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/7/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import Foundation
import MapKit
class User : NSObject {
    
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    
    var mapString = ""
    var latitude = 0.0
    var longitude = 0.0
    
    var webAddress = "http://"
    var objectID = ""
    // Singleton pattern used so the User is available across the app
    class func sharedUser() -> User {
        
        struct Singleton {
            static var sharedUser = User()
        }
        
        return Singleton.sharedUser
    }
    
} // End User
