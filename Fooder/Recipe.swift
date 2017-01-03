//
//  Recipe.swift
//  Fooder
//
//  Created by Vladimir on 28.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import SwiftyJSON

class Recipe{
    let id: Int
    let vegeterian: Bool
    let vegan: Bool
    let title: String
    let imageURL: String
    var ingridients :[Ingridient]
    let instructions: String?
    let readyInMinutes: Double
    let servings: Int
    var extendedInstructions = [String]()
    
    init(data: JSON){
        var gotIngridients = [Ingridient]()
        
        for ingridient in data["extendedIngredients"].arrayValue{
            gotIngridients.append(Ingridient(data: ingridient))
        }
        
        if  let goodInstructions = data["analyzedInstructions"].array{
            if goodInstructions.count > 0{
                for step in goodInstructions[0]["steps"].arrayValue{
                    let stepDescription = step["step"].stringValue as NSString
                    if stepDescription.length > 1{
                        self.extendedInstructions.append(step["step"].stringValue)
                    }
                }
            }
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
    
    init(id: Int, title: String, imageURL: String){
        self.id = id
        self.vegeterian = false
        self.vegan = false
        self.title = title
        self.imageURL = imageURL
        self.ingridients = [Ingridient]()
        self.instructions = ""
        self.readyInMinutes = 0
        self.servings = 0
    }
}
