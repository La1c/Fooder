//
//  MealObject.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import SwiftyJSON

class Recipe{
    let id: Int
    let vegeterian: Bool?
    let vegan: Bool?
    let title: String
    let imageURL: String
    let ingridients: [Ingridient]?
    let instructions: String?
    let readyInMinutes: Double?
    let servings: Int?
    
    
    init(id: Int, vegeterian: Bool? = nil, vegan: Bool? = nil, title: String, imageURL: String, ingridients: [Ingridient]? = nil, instructions: String? = nil, readyInMinutes: Double? = nil, servings: Int? = nil) {
        
        self.id = id
        self.vegeterian = vegeterian
        self.vegan = vegan
        self.title = title
        self.imageURL = imageURL
        self.ingridients = ingridients
        self.instructions = instructions
        self.readyInMinutes = readyInMinutes
        self.servings = servings
    }
    
    init(data: JSON){
        var ingridients = [Ingridient]()
        
        for ingridient in data["extendedIngredients"].arrayValue{
            ingridients.append(Ingridient(data: ingridient))
        }
        
        self.id = data["id"].intValue
        self.vegeterian = data["vegeterian"].boolValue
        self.vegan = data["vegan"].boolValue
        self.title = data["title"].stringValue
        self.imageURL = data["image"].stringValue
        self.ingridients = ingridients
        self.instructions = data["instructions"].stringValue
        self.readyInMinutes = data["readyInMinutes"].doubleValue
        self.servings = data["servings"].intValue
    }
}
