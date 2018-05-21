//
//  NetworkManager.swift
//  FoodTracker
//
//  Created by Raman Singh on 2018-05-21.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

protocol alertProtocol {
    func invalidCredentials()
}

class NetworkManager: NSObject {
    
    var delegate:alertProtocol? = nil
    
    func signOrLogUserIn(userName:String, password:String, mode:String) {
        
        let urlString = "https://cloud-tracker.herokuapp.com/\(mode)?username=\(userName)&password=\(password)"
        
        let url = NSURL(string: urlString)
        var urlRequest = URLRequest(url: url! as URL)
        urlRequest.httpMethod = "POST"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: urlRequest, completionHandler:
        { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                
                DispatchQueue.main.async {
                    self.delegate?.invalidCredentials()
                }
                
            }
            
            if let userData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) as! Dictionary<String, Any>
            {
                print(userData)
                
                if let token = userData["token"] {
                    UserDefaults.standard.set(token, forKey: "token")
                }
            }
        })
        task.resume()
    }//signOrLogUserIn
    
    
}
