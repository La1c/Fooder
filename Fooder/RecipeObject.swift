//
//  MealObject.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Recipe: Object{
   dynamic var id: Int = 0
   dynamic var vegeterian: Bool = false
   dynamic var  vegan: Bool = false
   dynamic var title: String = " "
   dynamic var imageURL: String = " "
   var ingridients = List<Ingridient>()
   dynamic var instructions: String?
   dynamic var readyInMinutes: Double = 0
   dynamic var servings: Int = 0
    
    convenience init(data: JSON){
        self.init()
        let gotIngridients = List<Ingridient>()
        
        for ingridient in data["extendedIngredients"].arrayValue{
            gotIngridients.append(Ingridient(data: ingridient))
        }
        
        self.id = data["id"].intValue
        self.vegeterian = data["vegeterian"].boolValue
        self.vegan = data["vegan"].boolValue
        self.title = data["title"].stringValue
        self.imageURL = data["image"].stringValue
        self.ingridients = gotIngridients
        self.instructions = data["instructions"].stringValue
        self.readyInMinutes = data["readyInMinutes"].doubleValue
        self.servings = data["servings"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
