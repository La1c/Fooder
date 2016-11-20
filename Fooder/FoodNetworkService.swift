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
    
    func getRandomRecipes(completion: (() -> Void)?){
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/random",
                          parameters: ["limitLicense": true,
                                       "number": 1],
                          headers: ["X-Mashape-Key" : APIkey,
                                    "Accept": "application/json"]
            ).responseJSON(completionHandler: { response in
                
                guard response.result.isSuccess else{
                   // completion(nil)
                    return
                }
                
                let json = JSON(response.result.value!)
                print(json)
            })
    }
}
