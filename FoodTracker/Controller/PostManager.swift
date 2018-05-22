//
//  PostManager.swift
//  FoodTracker
//
//  Created by Raman Singh on 2018-05-21.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

protocol addRating {
    func updateMealRating()
}

class PostManager: NSObject, imageURLDelegate {
    
    var myImgManager = imgurManager()
    
    var mealID:Int?
    
    
    func postMeal(title:String, calories:String, ddescription:String, meal:Meal) {
        var caloriesInt = Int(calories)!
        let postData = ["title":title, "calories":caloriesInt, "description":ddescription] as [String : Any]
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("could not serialize json")
            return
        }
        
        let url = URL(string: "https://cloud-tracker.herokuapp.com/users/me/meals")!
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
                
                if let myMeal = userData!["meal"] as? Dictionary<String, Any> {
                    let id = myMeal["id"] as? Int
                    self.mealID = id
                    
                    
                    

                    
                    self.addRatingsToMeal(mealID: id!, meal: meal)
                    
                }
            }
        }
        task.resume()
    }//postMeal
    
    func updateImageURL(withURL: String) {
        self.myImgManager.updateImageURL(_with: self.mealID!, imageURL: withURL)
    }
    
    
    
    func addRatingsToMeal(mealID:Int, meal:Meal) {
        
        print("Adding ratings")
        
        print("meal details are: mealName:\(meal.name), mealRatings:\(meal.rating!)")
        
        let urlString = "https://cloud-tracker.herokuapp.com/users/me/meals/\(mealID)/rate?rating=\(meal.rating!)"
        
//        let urlString = "https://cloud-tracker.herokuapp.com/users/me/meals/\(mealID)/rate?rating=2"
        let url = NSURL(string: urlString)
        var urlRequest = URLRequest(url: url! as URL)
        urlRequest.httpMethod = "POST"
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
            
            if let userData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) as! Dictionary<String, Any>
            {
                print(userData)
                
            }
        })
        task.resume()
        
        
    }//addRatingsToMeal
    
}





