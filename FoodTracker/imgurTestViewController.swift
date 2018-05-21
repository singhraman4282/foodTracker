//
//  imgurTestViewController.swift
//  FoodTracker
//
//  Created by Raman Singh on 2018-05-21.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

class imgurTestViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "apple_web")
        
        uploadImage()
        
        
    }
    
    func uploadImage() {
        
        let image = UIImage(named: "apple_web")
        
        let uploadData = UIImagePNGRepresentation(image!)

        
        let urlString = "https://api.imgur.com/3/image"
        let url = NSURL(string: urlString)
        var urlRequest = URLRequest(url: url! as URL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Client-ID 887c27b7d390539", forHTTPHeaderField: "Authorization")
        
        
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
                
            }
            
            if let userData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) as! Dictionary<String, Any>
            {
                print(userData)
                
            }
            
            
            
            
            
            
            
            
           
        })
        task.resume()
        
        
        
        
        
        
        
        
        
    }//uploadImage
    
    
}
