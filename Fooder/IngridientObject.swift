//
//  IngridientObject.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import SwiftyJSON

class Ingridient{
    let id: Int
    let amount: Double
    let unit: String
    let unitShort: String
    let name: String
    let imageURL: String
    
    init(id: Int, amount: Double, unit: String, unitShort: String, name: String, imageURL:String) {
        self.id = id
        self.amount = amount
        self.unit = unit
        self.unitShort = unitShort
        self.name = name
        self.imageURL = imageURL
    }
    
    init(data: JSON){
        self.id = data["id"].intValue
        self.amount = data["amount"].doubleValue
        self.unit = data["unit"].stringValue
        self.unitShort = data["unitShort"].stringValue
        self.name = data["name"].stringValue
        self.imageURL = data["image"].stringValue
    }
}
