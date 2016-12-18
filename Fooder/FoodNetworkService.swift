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
                        let newIngridient = Ingridient(id: ingridient["id"].intValue,
                                                       amount: ingridient["amount"].doubleValue,
                                                       unit: ingridient["unit"].stringValue,
                                                       unitShort: ingridient["unitShort"].stringValue,
                                                       name: ingridient["name"].stringValue,
                                                       imageURL: ingridient["image"].stringValue)
                        ingridients.append(newIngridient)
                    }
                    
                    let newRecipe = Recipe(id: recipe["id"].intValue,
                                           vegeterian: recipe["vegeterian"].boolValue,
                                           vegan: recipe["vegan"].boolValue,
                                           title: recipe["title"].stringValue,
                                           imageURL: recipe["image"].stringValue,
                                           ingridients: ingridients,
                                           instructions: recipe["instructions"].stringValue,
                                           readyInMinutes: recipe["readyInMinutes"].doubleValue,
                                           servings: recipe["servings"].intValue)
                    responseRecipes.append(newRecipe)
                }
                
                completion(responseRecipes)
               
            })
    }
    
    func recipeSearch(cuisine: Cuisine? = nil, diet: Diet = .none, intolerances: [Intolerance]? = nil, query: String, type: FoodType = .mainCourse, completion: @escaping ([Recipe]?) -> Void){
        
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/searchComplex",
                          parameters: ["limitLicense": true,
                                       "addRecipeInformation" : true,
                                    //   "cuisine": "", //enable later!
                                       "diet": diet.rawValue,
                                       "instructionsRequired": true,
                                    //   "intolerances":  "", //enable later!
                                       "query": query,
                                       "type": type.rawValue,
                                       "ranking": 1,
                                       "offset" : 0,
                                       "number": 30],
                          headers: ["X-Mashape-Key" : APIkey,
                                    "Accept": "application/json"]
            ).responseJSON(completionHandler: { response in
                guard response.result.isSuccess else{
                    completion(nil)
                    return
                }
                
                 let json = JSON(response.result.value!)["results"].arrayValue
                var responseRecipes = [Recipe]()
                
                for recipe in json{
                    var ingridients = [Ingridient]()
                    
                    for ingridient in recipe["extendedIngredients"].arrayValue{
                        let newIngridient = Ingridient(id: ingridient["id"].intValue,
                                                       amount: ingridient["amount"].doubleValue,
                                                       unit: ingridient["unit"].stringValue,
                                                       unitShort: ingridient["unitShort"].stringValue,
                                                       name: ingridient["name"].stringValue,
                                                       imageURL: ingridient["image"].stringValue)
                        ingridients.append(newIngridient)
                    }
                    
                    let newRecipe = Recipe(id: recipe["id"].intValue,
                                           vegeterian: recipe["vegeterian"].boolValue,
                                           vegan: recipe["vegan"].boolValue,
                                           title: recipe["title"].stringValue,
                                           imageURL: recipe["image"].stringValue,
                                           ingridients: ingridients,
                                           instructions: recipe["instructions"].stringValue,
                                           readyInMinutes: recipe["readyInMinutes"].doubleValue,
                                           servings: recipe["servings"].intValue)
                    responseRecipes.append(newRecipe)
                }
            print(responseRecipes)
            completion(responseRecipes)
            })
    }
    
    func getRecipeByID(id: Int, completion: @escaping ([Recipe]?) -> Void){
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/random",
                          parameters: ["id": id],
                          headers: ["X-Mashape-Key" : APIkey,
                                    "Accept": "application/json"]
            ).responseJSON(completionHandler: { response in
                
                guard response.result.isSuccess else{
                    completion(nil)
                    return
                }
                
                let json = JSON(response.result.value!)
                
                var responseRecipes = [Recipe]()
                var ingridients = [Ingridient]()
                    
                    for ingridient in json["extendedIngredients"].arrayValue{
                        let newIngridient = Ingridient(id: ingridient["id"].intValue,
                                                       amount: ingridient["amount"].doubleValue,
                                                       unit: ingridient["unit"].stringValue,
                                                       unitShort: ingridient["unitShort"].stringValue,
                                                       name: ingridient["name"].stringValue,
                                                       imageURL: ingridient["image"].stringValue)
                        ingridients.append(newIngridient)
                    }
                    
                    let newRecipe = Recipe(id: json["id"].intValue,
                                           vegeterian: json["vegeterian"].boolValue,
                                           vegan: json["vegan"].boolValue,
                                           title: json["title"].stringValue,
                                           imageURL: json["image"].stringValue,
                                           ingridients: ingridients,
                                           instructions: json["instructions"].stringValue,
                                           readyInMinutes: json["readyInMinutes"].doubleValue,
                                           servings: json["servings"].intValue)
                    responseRecipes.append(newRecipe)
                completion(responseRecipes)
                
            })

    }
}
