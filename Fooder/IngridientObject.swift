//
//  IngridientObject.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Ingridient:Object{
    dynamic var id: Int = 0
    dynamic var amount: Double = 0
    dynamic var unit: String = ""
    dynamic var unitShort: String = ""
    dynamic var name: String = ""
    dynamic var imageURL: String = ""
    dynamic var inGroceryList: Bool = false
    let fromRecipes = LinkingObjects(fromType: Recipe.self, property: "ingridients")
    
    convenience init(data: JSON){
        self.init()
        self.id = data["id"].intValue
        self.amount = data["amount"].doubleValue
        self.unit = data["unit"].stringValue
        self.unitShort = data["unitShort"].stringValue
        self.name = data["name"].stringValue
        self.imageURL = data["image"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
