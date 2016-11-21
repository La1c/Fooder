//
//  MealObject.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation


class Recipe{
    let id: Double
    let vegeterian: Bool
    let vegan: Bool
    let title: String
    let imageURL: String
    let ingridients: [Ingridient]
    let instructions: String
    let preparationMinutes: Double
    let cookingMinutes: Double
    
    init(id: Double, vegeterian: Bool, vegan: Bool, title: String, imageURL: String, ingridients: [Ingridient], instructions: String, preparationMinutes: Double, cookingMinutes: Double) {
        
        self.id = id
        self.vegeterian = vegeterian
        self.vegan = vegan
        self.title = title
        self.imageURL = imageURL
        self.ingridients = ingridients
        self.instructions = instructions
        self.preparationMinutes = preparationMinutes
        self.cookingMinutes = cookingMinutes
    }
    
}
