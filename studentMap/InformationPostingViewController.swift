//
//  InformationPostingViewController.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/7/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var submitbutton: UIButton!
    
    @IBOutlet weak var enterlocation: UITextField!
    
    @IBOutlet weak var enterwebsite: UITextField!
    
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var findonmap: UIButton!
    
    
    @IBAction func cancel(_ sender: Any) {
        enterwebsite.isHidden = false
        enterlocation.isHidden = false
        enterwebsite.text = ""
        enterlocation.text = ""
        submitbutton.isHidden = true
        findonmap.isHidden = false
        map.isHidden = true
    }
    
    @IBAction func submit(_ sender: Any) {
        DispatchQueue.main.async {
            self.activityindicator.startAnimating()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            Student.sharedInstance.studentLocations.removeAll()
            
            Client.sharedInstance().taskForuserdata(completionHandlerforuserdata: {
                Client.sharedInstance().taskForPOSTStudent(completionHandler: { error in
                    
                    guard (error == nil) else {
                        let errorMessage = UIAlertController.init(title: "Uhoh!", message: "Please check your network connection and try again.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        errorMessage.addAction(okAction)
                        self.present(errorMessage, animated: true)
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)})})
            
            self.activityindicator.stopAnimating()
        }
        
    } // End submitLocatio
    
    
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func findonmap(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.activityindicator.startAnimating()
        }
        
        if enterlocation.hasText && enterwebsite.hasText {
            if !(enterwebsite.text?.contains("https://"))! {
                let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter https:// before web address.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
                
                errorMessage.addAction(okAction)
                
                self.present(errorMessage, animated: true)
            }
            
            let userWebAddress = enterwebsite.text! as String
            User.sharedUser().webAddress = userWebAddress
            
            let userLocation = CLGeocoder()
            
            userLocation.geocodeAddressString(enterlocation.text!, completionHandler: { placemark, error in
                
                if (error != nil) {
                    let errorMessage = UIAlertController.init(title: "Error", message: "Unable to find that location", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    errorMessage.addAction(okAction)
                    self.present(errorMessage, animated: true)
                } else {
                    
                    self.map.isHidden = false
                    self.submitbutton.isHidden = false
                    self.findonmap.isHidden = true
                    self.enterlocation.isHidden = true
                    self.enterwebsite.isHidden = true
                    
                    let locationData = placemark?[0].location
                    User.sharedUser().latitude = (locationData?.coordinate.latitude)! as Double
                    User.sharedUser().longitude = (locationData?.coordinate.longitude)! as Double
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = (locationData?.coordinate)!
                    
                    self.map.addAnnotation(annotation)
                    self.map.camera.centerCoordinate = (locationData?.coordinate)!
                    self.map.camera.altitude = self.map.camera.altitude * 0.2
                }
                
            })
            
            DispatchQueue.main.async {
                self.activityindicator.stopAnimating()
            }
            
        } else if !enterlocation.hasText {
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter a location.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
            
        } else if !enterwebsite.hasText {
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter a URL.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
        }
        
        self.activityindicator.stopAnimating()
        
    }
    var coordinates:CLLocationCoordinate2D!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enterlocation.delegate = self
        enterwebsite.delegate = self
        submitbutton.isHidden = true
        map.isHidden = true
        
        map.delegate = self
        
        activityindicator.isHidden = true
        
    } // End viewWillAppear
    
    
    
    
    func createAlertViewController(title:String, message: String, buttonTitle:String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style:UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        enterlocation.placeholder = ""
        enterwebsite.placeholder = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterwebsite.resignFirstResponder()
        enterlocation.resignFirstResponder()
        
        view.frame.origin.y = 0
        return true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        //  let userInfo = notification.userInfo
        let keyboardBeginFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let screenHeight = UIScreen.main.bounds.height
        let isBeginOrEnd = keyboardBeginFrame.origin.y == screenHeight || keyboardEndFrame.origin.y == screenHeight
        let heightOffset = keyboardBeginFrame.origin.y - keyboardEndFrame.origin.y - (isBeginOrEnd ? bottomLayoutGuide.length : 0)
        return heightOffset
    }
    
    
    func keyboardWillShow( notification: NSNotification) {
        if (enterwebsite.isFirstResponder){
            
            view.frame.origin.y -= getKeyboardHeight(notification as Notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            view.frame.origin.y += getKeyboardHeight(notification as Notification)
            
        }
        
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        
        
        
    }
    override func viewDidLoad() {
        activityindicator.isHidden = true
        enterlocation.text = ""
        enterwebsite.text = ""
        enterlocation.delegate = self
        enterwebsite.delegate = self
        
    }
    
}





