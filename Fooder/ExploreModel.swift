//
//  ExploreModel.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation


protocol ExploreModelDelegate: class{
    func modelDidLoadNewData()
}

class ExploreModel{
    
    var recipes = [Recipe]()
    let foodService = FoodService()
    let numberOfRecipesToGetEveryTime: Int
    weak var delegate: ExploreModelDelegate?

    init(numberOfRecipes: Int = 10) {
        self.numberOfRecipesToGetEveryTime = numberOfRecipes
    }
    
    static let sharedInstance: ExploreModel = {
        let instance = ExploreModel()
        return instance
    }()
    
    func getData(){
        foodService.getRandomRecipes(number: numberOfRecipesToGetEveryTime,
                                     completion:{newData in
                                        if let data = newData{
                                            self.recipes = self.recipes + data
                                            self.delegate?.modelDidLoadNewData()
                                        }})
    }
}
