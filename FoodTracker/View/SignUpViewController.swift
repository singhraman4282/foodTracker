//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Raman Singh on 2018-05-21.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, alertProtocol {
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var signOutlet: UIButton!
    
    @IBOutlet var segmentControllerOutlet: UISegmentedControl!
    @IBOutlet var password: UITextField!
    var credsAreCorrect:Bool = false
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAvailableCreds()
//        print(UserDefaults.standard.value(forKey: "token"))
        
    }//load
    
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        
        switch segmentControllerOutlet.selectedSegmentIndex {
        case 0:
            if (bothTextFieldsHaveText()) {
                networkManager.signOrLogUserIn(userName: "\(userName.text!)", password: "\(password.text!)", mode: "signup")
                self.performSegue(withIdentifier: "toMeals", sender: self)
            }
        case 1:
            
            if (bothTextFieldsHaveText()) {
                networkManager.delegate = self
                networkManager.signOrLogUserIn(userName: "\(userName.text!)", password: "\(password.text!)", mode: "login")
            }
        default:
            print("whaaaa")
        }
        
    }//signUpAction
    
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        switch segmentControllerOutlet.selectedSegmentIndex {
        case 0:
            signOutlet.setTitle("Sign Up", for: .normal)
        case 1:
            signOutlet.setTitle("Sign In", for: .normal)
        default:
            signOutlet.setTitle("Sign Up", for: .normal)
        }
    }
    
    func bothTextFieldsHaveText()->Bool {
        return userName.text != "" && password.text != ""
    }
    
    func invalidCredentials() {
        let alert = UIAlertController(title: "ERRRRRRRROOOORR!", message: "Check username and password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK 😢", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        credsAreCorrect = false
    }
    
    func checkAvailableCreds() {
        if UserDefaults.standard.string(forKey: "token") != "" {
            userName.text = UserDefaults.standard.string(forKey: "userName")
            password.text = UserDefaults.standard.string(forKey: "password")
            signOutlet.setTitle("Sign In", for: .normal)
            segmentControllerOutlet.selectedSegmentIndex = 1
            print(UserDefaults.standard.string(forKey: "token"))
        }
    }
    
    func validCredentials() {
        self.performSegue(withIdentifier: "toMeals", sender: self)
    }
    
}//end

