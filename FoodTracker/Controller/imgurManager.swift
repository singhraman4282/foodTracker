//
//  imgurManager.swift
//  FoodTracker
//
//  Created by Raman Singh on 2018-05-21.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

protocol imageURLDelegate {
    func updateImageURL(withURL: String)
}

class imgurManager: NSObject {
    
    var delegate:imageURLDelegate?;
    
    var imageURL:String?
    var mealIDnumber:Int?
    
    func uploadImage(image:UIImage) {
        
        print("uploading image")
        let uploadData = UIImageJPEGRepresentation(image, 0.2)
        let urlString = "https://api.imgur.com/3/image"
        let url = NSURL(string: urlString)
        var urlRequest = URLRequest(url: url! as URL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Client-ID 887c27b7d390539", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = uploadData
        
        
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
                if let dict = userData["data"] as? Dictionary<String, Any>{
                    if let imgurl = dict["link"] as? String {
                        print(imgurl)
                        self.imageURL = imgurl
                        
                        self.delegate?.updateImageURL(withURL: imgurl)
                    }
                }
            }
            
            
        })
        task.resume()
        
    }//uploadImage
    
    func updateImageURL(_with mealID:Int, imageURL:String) {
        
        guard imageURL != nil else {
            print("photo url is nil")
            return
        }
        
        let postData = ["photo":self.imageURL] as [String : Any]
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("could not serialize json")
            return
        }
        
        let url = URL(string: "https://cloud-tracker.herokuapp.com/users/me/meals/\(mealID)/photo")!
        let request = NSMutableURLRequest(url: url)
        request.httpBody = postJSON
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "token")
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                
            }
            
            if let userData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) as? Dictionary<String, Any>
            {
                print(userData)
            }
        }
        task.resume()
        
    }//updateImageURL
}
