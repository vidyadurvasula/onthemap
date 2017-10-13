//
//  MapvViewController.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/1/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//
import MapKit
import CoreLocation
import UIKit

class MapvViewController: UIViewController, MKMapViewDelegate {
    
    @IBAction func refreshbutton(_ sender: Any) {
        
        self.map.removeAnnotations(map.annotations)
        Client.sharedInstance().taskForGETMethod( {(results,error) -> Void in
            
            guard(error == nil) else {
                let errorMessage = UIAlertController.init(title: "Network Error", message: "Please check network connection and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                return
            }
            DispatchQueue.main.async
                {
                    var studentLocations = [studentlocation]()
                    if let studentResults = results
                    {
                        studentLocations = studentResults as! [studentlocation]
                    }
                    var annotations = [MKPointAnnotation]()
                    
                    for eachStudent in studentLocations
                    {
                        let lat = CLLocationDegrees(eachStudent.latitude!)
                        let long = CLLocationDegrees(eachStudent.longitude!)
                        let studentCoordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = studentCoordinate
                        annotation.title = "\(eachStudent.firstName) \(eachStudent.lastName)"
                        annotation.subtitle = eachStudent.mediaURL
                        
                        annotations.append(annotation)
                    }
                    self.map.addAnnotations(annotations)
                    
                    
            }
            
        })
        
        
    }
    @IBAction func updatelocation(_ sender: Any) {
        performSegue(withIdentifier: "addstudentlocation", sender: self)
    }
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    
    
    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBAction func logoutbutton(_ sender: Any) {
        
        
        Client.sharedInstance().taskForPOSTDeleteSession(completionHandler: {(result,error) in
            
            
        })
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        Client.sharedInstance().taskForGETMethod( {(results,error) -> Void in
            
            guard(error == nil) else {
                let errorMessage = UIAlertController.init(title: "Network Error", message: "Download failed Please check network connection and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                return
            }
            DispatchQueue.main.async
                {
                    var studentLocations = [studentlocation]()
                    if let studentResults = results
                    {
                        studentLocations = studentResults as! [studentlocation]
                    }
                    var annotations = [MKPointAnnotation]()
                    
                    for eachStudent in studentLocations
                    {
                        let lat = CLLocationDegrees(eachStudent.latitude!)
                        let long = CLLocationDegrees(eachStudent.longitude!)
                        let studentCoordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = studentCoordinate
                        annotation.title = "\(eachStudent.firstName) \(eachStudent.lastName)"
                        annotation.subtitle = eachStudent.mediaURL
                        
                        annotations.append(annotation)
                    }
                    self.map.addAnnotations(annotations)
                    
                    
            }
        })    }
    
    override func viewDidLoad() {
        map.delegate = self
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func alertAction() {
        let alertController = UIAlertController(title: "Error", message: "error occured", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true)
        
    }
    
    
}
