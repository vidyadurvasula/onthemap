//
//  client.swift
//  studentMap
//
//  Created by Vidya Durvasula on 9/29/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import Foundation
import UIKit
class Client : NSObject {
    
    var session = URLSession.shared
    
    // configuration object
    
    // authentication statevar requestToken: String? = nil
    var sessionID : String? = nil
    var appdelegate : AppDelegate!
    var accountvalue : String? = nil
    var userID: String? = nil
    var sharedSession = URLSession.shared
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    func taskForGETMethod(_  completionHandlerForGET: @escaping ( _ result:AnyObject?,_ error: NSError?) -> Void)  {
        
        
        let request = NSMutableURLRequest(url: URL(string: "\(Client.urlUdacity.studentlocationURL)?limit=100&order=-updatedAt")!)
        
        request.httpMethod = "GET"
        request.addValue(Client.Constants.parseApplicationID, forHTTPHeaderField:Client.HttpFields.parseAppIDKey)
        request.addValue(Client.Constants.parseAPIKey, forHTTPHeaderField:Client.HttpFields.parseRestAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil{
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil,NSError(domain:"taskToGetSession", code: 1, userInfo:userInfo ))
            }
            
            guard let data = data else {
                print("Could not find the data")
                return
            }
            //let range = Range(uncheckedBounds: (5, data.count))
            // let scrubbedData = data.subdata(in: range)
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    
                    
                    let Result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                    
                    if let actualresults = Result["results"] as? [[String:AnyObject]]
                    {
                        
                        let studentLocations = studentlocation.studentLocationsFromResults( actualresults )
                        
                        
                        completionHandlerForGET(studentLocations as AnyObject?,nil)
                    }
                    else {
                        completionHandlerForGET(nil,NSError(domain: "postStudentLocation parsing", code: 1,userInfo:[NSLocalizedDescriptionKey: "Could not parse the data"]))
                        
                    }
                }
                    
                    
                catch {
                    let userInfo = [NSLocalizedDescriptionKey: "Cannot parse the \(data) into json Format"]
                    completionHandlerForGET(nil,NSError(domain:"convertDataWithCompletionHandler", code:1,userInfo: userInfo))
                    
                }
                
            }
        }
        
        task.resume()
    }
    
    
    func taskForPOSTStudent(completionHandler: @escaping (_ error: String?) -> Void) {
        
        print("Starting taskForPOSTStudent")
        print("Key: " + User.sharedUser().uniqueKey)
        print("First name: " + User.sharedUser().firstName)
        print("Last name: " + User.sharedUser().lastName)
        print("URL: " + User.sharedUser().webAddress)
        
        let request = NSMutableURLRequest(url: URL(string: (Client.urlUdacity.studentlocationURL))!)
        
        request.httpMethod = "POST"
        request.addValue(Client.Constants.parseApplicationID, forHTTPHeaderField:Client.HttpFields.parseAppIDKey)
        request.addValue(Client.Constants.parseAPIKey, forHTTPHeaderField:Client.HttpFields.parseRestAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(User.sharedUser().uniqueKey)\", \"firstName\": \"\(User.sharedUser().firstName)\", \"lastName\": \"\(User.sharedUser().lastName)\",\"mapString\": \"\(User.sharedUser().mapString)\", \"mediaURL\": \"\(User.sharedUser().webAddress)\",\"latitude\": \(User.sharedUser().latitude), \"longitude\": \(User.sharedUser().longitude)}".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        
        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            guard (error == nil) else {
                
                completionHandler(error?.localizedDescription)
                
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let errorString = (response as? HTTPURLResponse)?.statusCode.description
                print(errorString!)
                completionHandler(error?.localizedDescription)
                return
            }
            
            var parsedResult : [String:AnyObject]!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    
                    
                    
                    let objectid  = parsedResult["objectId"] as! String
                    User.sharedUser().objectID = objectid
                    
                    
                } catch {
                    completionHandler(error as? String)
                }
                completionHandler(nil)
            }
        }
        
        task.resume()
        
    } // End taskForPOSTStudent
    
    
    func taskForuserdata(completionHandlerforuserdata: @escaping ( _ error: String?) -> Void) {
        print("Starting taskForGETSession")
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(User.sharedUser().uniqueKey)")!)
        let session = URLSession.shared
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandlerforuserdata((error?.localizedDescription)!)
                
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerforuserdata((error?.localizedDescription)!)
                
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerforuserdata((error?.localizedDescription)!)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            var parsedResult:[String:AnyObject]! = nil
            DispatchQueue.main.async {
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                    if let resultsinfo = parsedResult {
                        
                        let user = resultsinfo["user"] as! [String:AnyObject]
                        print (user)
                        guard  let lastname = user["last_name"] as? String else {
                            print("no lastname")
                            return
                        }
                        let firstname = user["first_name"] as? String
                        
                        User.sharedUser().lastName = lastname
                        User.sharedUser().firstName = firstname!
                        print(User.sharedUser().firstName)
                        print(User.sharedUser().lastName)
                    } else {
                        print("no user found")
                        
                    }
                    
                    
                    
                } catch {
                    print("Error with the JSON data")
                }
                completionHandlerforuserdata(nil)
                
            }
        }
        
        task.resume()
        
        
    }
    func taskForPOSTDeleteSession(completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var xsrfCookie: HTTPCookie? = nil
        
        let request = NSMutableURLRequest(url: URL(string: Client.urlUdacity.sessionURL)!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // remove any cookies associated with Udacity API granted session
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("There was an error logging out.")
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let scrubbedData = data?.subdata(in: range)
            
            print(NSString(data: scrubbedData!, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult:[String:AnyObject]! = nil
            DispatchQueue.main.async {
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: scrubbedData!, options: .allowFragments) as! [String:AnyObject]
                    let sessionDictionary = parsedResult["session"]
                    self.sessionID = sessionDictionary?["id"] as? String
                    
                    print("Logged out.")
                    
                } catch {
                    print("Error with the JSON data")
                }
            }
            
            
        }
        
        task.resume()
        
    }
    
    
    func taskForGETSession(completionHandler: @escaping () -> Void) {
        
        print("Starting taskForGETSession")
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "parse.udacity.com"
        urlComponents.path = "/parse/classes/StudentLocation"
        urlComponents.queryItems = [URLQueryItem]()
        
        
        let queryItemOne = URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(User.sharedUser().uniqueKey)\"}")
        
        
        urlComponents.queryItems?.append(queryItemOne)
        
        let request = NSMutableURLRequest(url: urlComponents.url!)
        
        
        request.httpMethod = "GET"
        request.addValue(Client.Constants.parseApplicationID, forHTTPHeaderField:Client.HttpFields.parseAppIDKey)
        request.addValue(Client.Constants.parseAPIKey, forHTTPHeaderField:Client.HttpFields.parseRestAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            func errorHandler(_ error: String) {
                print("there was an error: " + error)
            }
            
            guard (error == nil) else {
                errorHandler(error.debugDescription)
                return
            }
            
            /* GUARD: Ensure a successful 2XX response was received */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorHandler("Bad response from the server.")
                return
            }
            guard (data == data) else {
                errorHandler(error.debugDescription)
                return
                
                
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let scrubbedData = data?.subdata(in: range)
            
            print(NSString(data: scrubbedData!, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult :[String:AnyObject]!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: scrubbedData!, options: .allowFragments) as! [String:AnyObject]
                    
                    /* JSON data comes back as an array; getting the array first and then pulling the dictionary to get
                     the user data */
                    print (parsedResult)
                    let userArray = parsedResult["results"] as! [AnyObject]
                    let userdictionary = userArray[0]
                    
                    
                    User.sharedUser().firstName = userdictionary["firstName"] as! String
                    User.sharedUser().lastName = userdictionary["lastName"] as! String
                    print( User.sharedUser().firstName)
                    print(User.sharedUser().lastName)
                    
                    
                } catch {
                    print("Error with the JSON data")
                }
                completionHandler()
            }
        }
        task.resume()
        
    }
    
    
    
    
    class  func sharedInstance() -> Client {
        struct Singleton {
            static let sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
    
}
