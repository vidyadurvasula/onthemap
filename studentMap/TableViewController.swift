//
//  TableViewController.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/8/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    
    var studentLocations = Student.sharedInstance.studentLocations
    
    @IBOutlet weak var acticityindicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBAction func addlocation(_ sender: Any) {
        
        let InfoVc = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationPostingViewController
        self.present(InfoVc,animated: true,completion: nil)
        
        
    }
    
    @IBAction func logout(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.acticityindicator.startAnimating()
        }
        
        Client.sharedInstance().taskForPOSTDeleteSession(completionHandler: { (results,error) in
        })
        self.dismiss(animated: true, completion: nil)
        self.acticityindicator.stopAnimating()
        
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        Client.sharedInstance().taskForGETMethod({ (results,error) -> Void in
            
            guard(error == nil) else {
                let errorMessage = UIAlertController.init(title: "Network Error", message: "Please check network connection and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                self.acticityindicator.stopAnimating()
                return
            }
        })
        
        self.tableview.reloadData()
        
        
    } // End logoutBut
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let student = studentLocations[indexPath.row]
        
        cell?.textLabel?.text = student.firstName! + " " + student.lastName!
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = studentLocations[indexPath.row] as studentlocation
        let studentURL = student.mediaURL
        
        let app = UIApplication.shared
        app.open(URL(string: studentURL!)!, options: [:], completionHandler: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        acticityindicator.color = UIColor.darkGray
        acticityindicator.hidesWhenStopped = true
        Client.sharedInstance().taskForGETMethod({ (results,error) -> Void in
            
            guard(error == nil) else {
                let errorMessage = UIAlertController.init(title: "Network Error", message: "Please check network connection and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                self.acticityindicator.stopAnimating()
                return
            }
            
            if let studentResults = results
            {
                DispatchQueue.main.async
                    {
                        self.studentLocations = studentResults as! [studentlocation]
                        self.tableview.reloadData()
                }
            }
                
            else
            {
                print(error!)
            }
            
        })
       
        self.tableview.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
}
