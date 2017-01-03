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
    
    func searchRecipes(query: String = "", type: FoodType = .all, offset: Int = 0, more: Bool = false){
        
        let intolerancesList = realm.objects(Intolerance.self)
        var namesArray = [String]()
        for intolerance in intolerancesList{
            namesArray.append(intolerance.name)
        }
        
        
        
        FoodService.recipeSearch(intolerances: namesArray.joined(separator: ","), query: query, type: type, offset: offset, completion: {newData in
            if let data = newData{
                if more{
                    self.recipes += data
                }else{
                    self.recipes = data
                }
                
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
