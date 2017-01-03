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
    private static let APIkey = FooderKeys().foodAPIKey()!
    
    static func getRandomRecipes(number: Int, completion: @escaping ([Recipe]?) -> Void){
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
                    responseRecipes.append(Recipe(data: recipe))
                }
                completion(responseRecipes)
            })
    }
    
    static func recipeComplexSearch(cuisine: Cuisine? = nil, diet: Diet = .none, intolerances: [Intolerance]? = nil, query: String, type: FoodType = .mainCourse, completion: @escaping ([Recipe]?) -> Void){
        
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
                    responseRecipes.append(Recipe(data: recipe))
                }
            completion(responseRecipes)
            })
    }
    
    static func getRecipeByID(id: Int, completion: @escaping (Recipe?) -> Void){
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(id)/information",
                         // parameters: ["id": id],
                          headers: ["X-Mashape-Key" : APIkey,
                                    "Accept": "application/json"]
            ).responseJSON(completionHandler: { response in
                
                guard response.result.isSuccess else{
                    completion(nil)
                    return
                }
                
                let json = JSON(response.result.value!)
                completion(Recipe(data: json))
            })
    }
    
    static func recipeSearch(cuisine: Cuisine? = nil, diet: Diet = .none, intolerances: String = "", query: String = "", type: FoodType = .all, offset: Int = 0, completion: @escaping ([Recipe]?) -> Void){
        var responseRecipes = [Recipe]()
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search",
                          parameters: ["limitLicense": true,
                                       //   "cuisine": "", //enable later!
                            "diet": diet.rawValue,
                            "instructionsRequired": true,
                            "intolerances":  intolerances,
                            "query": query,
                            "type": type.rawValue,
                            "offset" : offset,
                            "number": 30],
                          headers: ["X-Mashape-Key" : APIkey,
                                    "Accept": "application/json"]
            ).responseJSON(completionHandler: { response in
                guard response.result.isSuccess else{
                    completion(nil)
                    return
                }
                
                let json = JSON(response.result.value!)["results"].arrayValue
                let baseURI = JSON(response.result.value!)["baseUri"].stringValue
                for var recipe in json{
                    //Due to api response JSON structure, I have to do this
                    recipe["image"] = JSON(baseURI + recipe["image"].stringValue)
                    responseRecipes.append(Recipe(data: recipe))
                }
                 completion(responseRecipes)
            })
    }
    
    static func convertAmount(ingridientName:String, sourceAmount: Double, sourceUnit:String, targetUnit: String, completion:  @escaping ((convertedAmount: Double, convertedUnit: String)?) -> Void){
        
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/convert",
             parameters: ["ingridientName": ingridientName,
                          "sourceAmount": sourceAmount,
                          "sourceUnit": sourceUnit,
                          "targetUnit": targetUnit],
            headers: ["X-Mashape-Key" : APIkey,
                      "Accept": "application/json"]
            ).responseJSON(completionHandler: { response in
                
                guard response.result.isSuccess else{
                    completion(nil)
                    return
                }
                
                let json = JSON(response.result.value!)
                completion((convertedAmount: json["targetAmount"].doubleValue, convertedUnit: json["targetUnit"].stringValue))
        })
    }
}
