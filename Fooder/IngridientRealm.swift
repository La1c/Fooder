//
//  IngridientRealm.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class IngridientRealm:Object{
    dynamic var id: Int = 0
    dynamic var amount: Double = 0
    dynamic var unit: String = ""
    dynamic var unitShort: String = ""
    dynamic var name: String = ""
    dynamic var imageURL: String = ""
    dynamic var inGroceryList: Bool = false
    let fromRecipes = LinkingObjects(fromType: RecipeRealm.self, property: "ingridients")
    
    convenience init(data: Ingridient, isInList: Bool = false){
        self.init()
        self.id = data.id
        self.amount = data.amount
        self.unit = data.unit
        self.unitShort = data.unitShort
        self.name = data.name
        self.imageURL = data.imageURL
        self.inGroceryList = isInList
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
