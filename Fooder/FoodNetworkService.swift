//
//  FoodNetworkService.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Keys
import Alamofire
import SwiftyJSON



struct FoodService {
    let APIkey = FooderKeys().foodAPIKey()!
    
    func getRandomRecipes(number: Int, completion: @escaping ([Recipe]?) -> Void){
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/random",
                          parameters: ["limitLicense": true,
                                       "number": number],
                          headers: ["X-Mashape-Key" : APIkey,
                                    "Accept": "application/json"]
            ).responseJSON(completionHandler: { response in
                
                guard response.result.isSuccess else{
                    completion(nil)
                    return
                }
                
                let json = JSON(response.result.value!)["recipes"].arrayValue
                
                var responseRecipes = [Recipe]()
                for recipe in json{
                    var ingridients = [Ingridient]()
                    
                    for ingridient in recipe["extendedIngredients"].arrayValue{
                        let newIngridient = Ingridient(id: ingridient["id"].doubleValue,
                                                       amount: ingridient["amount"].doubleValue,
                                                       unit: ingridient["unit"].stringValue,
                                                       unitShort: ingridient["unitShort"].stringValue,
                                                       name: ingridient["name"].stringValue)
                        ingridients.append(newIngridient)
                    }
                    
                    let newRecipe = Recipe(id: recipe["id"].doubleValue,
                                           vegeterian: recipe["vegeterian"].boolValue,
                                           vegan: recipe["vegan"].boolValue,
                                           title: recipe["title"].stringValue,
                                           imageURL: recipe["image"].stringValue,
                                           ingridients: ingridients,
                                           instructions: recipe["instructions"].stringValue,
                                           preparationMinutes: recipe["preparationMinutes"].doubleValue,
                                           cookingMinutes: recipe["cookingMinutes"].doubleValue)
                    responseRecipes.append(newRecipe)
                }
                
                print(json)
                completion(responseRecipes)
               
            })
    }
}
