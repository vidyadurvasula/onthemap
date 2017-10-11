//
//  Convinence.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/1/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import Foundation
extension Client {
    func login(username: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: Client.urlUdacity.sessionURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                print("Something went wrong with your POST request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your status code does not conform to 2xx.")
                return
            }
            
            guard let data = data else {
                print("The request returned no data.")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult : AnyObject!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                    
                    
                }
                
                catch {
                    print("Error with the JSON data")
                }

                    guard let account = parsedResult?["account"] as? [String: AnyObject] else {
                        print("There is an problem with your account information.")
                        return
                    }
                    
                    //check user id
                    guard let userid = account["key"] as? String else {
                        print("There is a problem with your user ID.")
                        return
                    }
                    //check session dictionary
                    guard let sessionDictionary = parsedResult?["session"] as? [String: AnyObject] else {
                        print("There is a problem with your session dictionary.")
                        return
                    }
                    //check session
                    guard let sessions = sessionDictionary["id"] as? String else {
                        print("There is a problem with your session ID.")
                        return
                    }
                    
                    
                    print(userid)
                    print(sessions)
                    
                   User.sharedUser().uniqueKey = userid
                    self.appdelegate?.session = sessions
                    
                    
                
            }

            
        DispatchQueue.main.async {
        completionHandlerForLogin(true,parsedResult,nil)
           }
    
    
    }
    
    task.resume()
    }
    
    
    
}
