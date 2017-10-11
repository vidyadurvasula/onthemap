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
    
   
    
    
    @IBOutlet weak var loginusername: UITextField!
    
    @IBOutlet weak var loginpassword: UITextField!
    
    
    @IBAction func loginsubmit(_ sender: Any) {
        
        
        guard let username = loginusername.text else {
            alertAction()
            return
        }
        guard let password = loginpassword.text else {
            alertAction()
            return
        }
        DispatchQueue.main.async {
            self.activityindicator.startAnimating()
        }

        
       Client.sharedInstance().login(username: username, password: password) {(success, result, error) in

                DispatchQueue.main.async {
                    if success {
                       self.completeLogin()
                    } else{
                        print("cannot login")
                    }
         self.activityindicator.stopAnimating()
            }
              }
            }
        


    private func completeLogin() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let mapview = storyboard.instantiateViewController(withIdentifier: "MoviesTabBarController")
    self.present(mapview, animated: true)
       }


    @IBOutlet weak var Submitbutton: UIButton!
    
    @IBAction func signup(_ sender: Any) {
        
        
        let app = UIApplication.shared
        app.open(URL(string:Client.urlUdacity.udacitySignupURL)!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var Facebookbutton: UIButton!
    
   
    func alertAction() {
        let alertController = UIAlertController(title: "Error", message: "Empy username or password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
        if (loginusername.isFirstResponder)||(loginpassword.isFirstResponder){
            
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (loginusername == textField) {
            loginusername.text = ""}
        if (loginpassword == textField) {
            loginpassword.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.frame.origin.y = 0
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func initialsetup(textfield:UITextField, delegate:UITextFieldDelegate){
        
        textfield.delegate = delegate
        textfield.text = ""
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
