//
//  fetchManager.swift
//  FoodTracker
//
//  Created by Raman Singh on 2018-05-21.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
protocol addMealsToArray {
    func updateMeals(meal:Meal)
}

class fetchManager: NSObject {
    
    var delegate:addMealsToArray? = nil
    
    
    func downloadAllMeals() {
        
        let urlString = "https://cloud-tracker.herokuapp.com/users/me/meals/"
        
        let url = NSURL(string: urlString)
        var urlRequest = URLRequest(url: url! as URL)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "token")
        
        
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
            
            if let userData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) as! [Dictionary<String, Any>]
            {
                print(userData)
                
                for index in 0..<userData.count {
                    let dict = userData[index]
                    var meal = Meal(name: dict["title"] as! String, photo: nil, rating: dict["rating"] as? Int, calories: "\(dict["calories"])", mealDescription: dict["description"] as! String, userID: "\(dict["id"])" as! String, mealID: "\(dict["id"])" as! String)
                    
                    
                    DispatchQueue.main.async {
                        self.delegate?.updateMeals(meal:meal!)
                    }
                    
                    
                }
            }
        })
        task.resume()
        
    }//downloadAllMeals
}
