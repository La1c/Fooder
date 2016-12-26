//
//  ExploreModel.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import RealmSwift


protocol ExploreModelDelegate: class{
    func modelDidLoadNewData()
}

class ExploreModel{
    
    var recipes = [Recipe]()
    var intolerances:Results<Intolerance>!
    let foodService = FoodService()
    let numberOfRecipesToGetEveryTime: Int
    weak var delegate: ExploreModelDelegate?

    init(numberOfRecipes: Int = 30) {
        self.numberOfRecipesToGetEveryTime = numberOfRecipes
        intolerances = realm.objects(Intolerance.self)
        
        if intolerances.count == 0{
            createDefaults()
            intolerances = realm.objects(Intolerance.self)
        }
    }
    
    static let sharedInstance: ExploreModel = {
        let instance = ExploreModel()
        return instance
    }()
    
    func getData(){
        FoodService.getRandomRecipes(number: numberOfRecipesToGetEveryTime,
                                     completion:{newData in
                                        if let data = newData{
                                            self.recipes = self.recipes + data
                                            self.delegate?.modelDidLoadNewData()
                                        }})
    }
    
    func searchRecipes(query: String, type: FoodType = .all){
        
        let intolerancesList = realm.objects(Intolerance.self)
        var namesArray = [String]()
        for intolerance in intolerancesList{
            namesArray.append(intolerance.name)
        }
        
        
        
        FoodService.recipeSearch(intolerances: namesArray.joined(separator: ","), query: query, type: type, completion: {newData in
            if let data = newData{
                self.recipes = data
                self.delegate?.modelDidLoadNewData()
            }})
    }
    
    func createDefaults(){
        try! realm.write {
            let defaultIntolerancesList = [
                Intolerance(value:["dairy", false]),
                Intolerance(value:["egg", false]),
                Intolerance(value:["gluten", false]),
                Intolerance(value:["peanut", false]),
                Intolerance(value:["sesame", false]),
                Intolerance(value:["seafood", false]),
                Intolerance(value:["shellfish", false]),
                Intolerance(value:["soy", false]),
                Intolerance(value:["sulfite", false]),
                Intolerance(value:["wheat", false]),
                Intolerance(value:["tree nut", false])
            ]
            realm.add(defaultIntolerancesList)
        }
    }
}
