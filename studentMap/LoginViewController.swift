//
//  ViewController.swift
//  studentMap
//
//  Created by Vidya Durvasula on 9/29/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var udacityimage: UIImageView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var Submitbutton: UIButton!
    
    @IBOutlet weak var Facebookbutton: UIButton!
    
    @IBOutlet weak var loginusername: UITextField!
    
    @IBOutlet weak var loginpassword: UITextField!
    
    
    @IBAction func loginsubmit(_ sender: Any) {
        
        
        guard let username = loginusername.text else {
            createAlertViewController(title: "Invalidusername", message: "please enter the valid username", buttonTitle: "OK")
            return
        }
        guard let password = loginpassword.text else {
            createAlertViewController(title: "Invalidpassword", message: "please enter the valid password", buttonTitle: "OK")
            return
        }
        
        if (username == "")||(password == "") {
            self.createAlertViewController(title: "Username or password cant be empty", message: "please enter valid username or password", buttonTitle: "ok")
        }
        
        DispatchQueue.main.async {
            self.activityindicator.startAnimating()
        }
        
        
        
        Client.sharedInstance().login(username: username, password: password) {(success, result, error) in
            
            DispatchQueue.main.async {
                if success {
                    self.completeLogin()
                } else if (error != nil){
                    self.createAlertViewController(title: "On The Map", message: (error)!, buttonTitle: "Ok")
                }
                self.activityindicator.stopAnimating()
            }
        }
    }
    
    
    
    
    @IBAction func signup(_ sender: Any) {
        
        
        let app = UIApplication.shared
        app.open(URL(string:Client.urlUdacity.udacitySignupURL)!, options: [:], completionHandler: nil)
    }
    
    
    
    func createAlertViewController(title:String, message: String, buttonTitle:String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style:UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            view.frame.origin.y += getKeyboardHeight(notification as Notification)
            
        }
        
    }
    func subscribeToKeyboardNotifications() {
        
        //     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (loginusername == textField) {
            loginusername.text = ""}
        if (loginpassword == textField) {
            loginpassword.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y  = 0
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func initialsetup(textfield:UITextField, delegate:UITextFieldDelegate){
        textfield.keyboardType = UIKeyboardType.default
        textfield.delegate = delegate
        textfield.text = ""
    }
    
    private func completeLogin() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let mapview = storyboard.instantiateViewController(withIdentifier: "MoviesTabBarController")
        self.present(mapview, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialsetup(textfield: loginusername, delegate: self)
        initialsetup(textfield: loginpassword, delegate: self)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        activityindicator.color = UIColor.darkGray
        activityindicator.hidesWhenStopped = true
    }
}
