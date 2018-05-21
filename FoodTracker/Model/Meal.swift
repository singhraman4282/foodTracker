//
//  Meal.swift
//  FoodTracker
//
//  Created by Raman Singh on 2018-05-21.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import Foundation
import UIKit
import os.log



class Meal: NSObject, NSCoding {
    
    
    
    //MARK: Properties
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let calories = "0"
        static let mealDescription = "mealDescription"
    }
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var calories: String
    var mealDescription: String
 
    init?(name: String, photo: UIImage?, rating: Int, calories:String, mealDescription:String) {
        self.name = name
        self.photo = photo
        self.rating = rating
        self.calories = calories
        self.mealDescription = mealDescription
        
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(calories, forKey: PropertyKey.calories)
        aCoder.encode(mealDescription, forKey: PropertyKey.mealDescription)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let mealDescription = aDecoder.decodeObject(forKey: PropertyKey.mealDescription) as? String else {
            os_log("Unable to decode the description for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let calories = aDecoder.decodeObject(forKey: PropertyKey.calories) as? String else {
            os_log("Unable to decode the description for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name: name, photo: photo, rating: rating,calories:calories, mealDescription:mealDescription)

    }
    
    
    
}
