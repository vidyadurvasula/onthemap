//
//  data.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/3/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import Foundation
class Student: NSObject {
    
    var studentLocations = [Studentlocation]()
    static let sharedInstance = Student()
    
    
}
