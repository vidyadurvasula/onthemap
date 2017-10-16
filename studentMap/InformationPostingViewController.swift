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
        activityindicator.isHidden = true
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var map: MKMapView!
    @IBAction func submit(_ sender: Any) {
        DispatchQueue.main.async {
            self.activityindicator.startAnimating()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            Student.sharedInstance.studentLocations.removeAll()
            
            Client.sharedInstance().taskForuserdata(completionHandlerforuserdata: { error in
                
                guard (error == nil) else {
                    self.createAlertViewController(title: "submit", message: (error)!, buttonTitle: "Ok")
                    return
                }
                
                Client.sharedInstance().taskForPOSTStudent(completionHandler: { error in
                    
                    guard (error == nil) else {
                        self.createAlertViewController(title: "submit", message: (error)!, buttonTitle: "Ok")
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)})})
            
            self.activityindicator.stopAnimating()
        }
        
    } // End submitLocation
    
    
    @IBAction func findonmap(_ sender: Any) {
        
        if enterlocation.hasText && enterwebsite.hasText {
            if !(enterwebsite.text?.contains("https://"))! {
                DispatchQueue.main.async {
                    self.activityindicator.startAnimating()
                }
                let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter https:// before web address.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
                
                errorMessage.addAction(okAction)
                
                self.present(errorMessage, animated: true)
                activityindicator.stopAnimating()
            }
            
            let userWebAddress = enterwebsite.text! as String
            User.sharedUser().webAddress = userWebAddress
            
            let userLocation = CLGeocoder()
            
            userLocation.geocodeAddressString(enterlocation.text!, completionHandler: { placemark, error in
                DispatchQueue.main.async {
                    
                    self.activityindicator.startAnimating()
                }
                
                if (error != nil) {
                    
                    let errorMessage = UIAlertController.init(title: "Error", message: "Unable to find that location", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    errorMessage.addAction(okAction)
                    self.present(errorMessage, animated: true)
                    DispatchQueue.main.async {
                        self.activityindicator.stopAnimating()
                    }
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
                DispatchQueue.main.async {
                    
                    self.activityindicator.stopAnimating()
                }

            })
            
                    } else if !enterlocation.hasText {
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter a location.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
            self.activityindicator.stopAnimating()
            
        } else if !enterwebsite.hasText {
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter a URL.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
            self.activityindicator.stopAnimating()
        }
        DispatchQueue.main.async {

        self.activityindicator.stopAnimating()
        }
        
    }
    var coordinates:CLLocationCoordinate2D!
    
    
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
        textField.resignFirstResponder()
        view.frame.origin.y = 0
        return true
    }
    func hideKeyboardWhenTappedAround() {
        view.frame.origin.y = 0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InformationPostingViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.frame.origin.y = 0
        view.endEditing(true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitbutton.isHidden = true
        map.isHidden = true
        activityindicator.hidesWhenStopped = true
        activityindicator.isHidden = true
        
    } // End viewWillAppear
    
    
    
    override func viewDidLoad() {
        activityindicator.isHidden = true
        enterlocation.text = ""
        enterwebsite.text = ""
        enterlocation.delegate = self
        enterwebsite.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
}





