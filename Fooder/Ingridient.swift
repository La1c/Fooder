//
//  Ingridient.swift
//  Fooder
//
//  Created by Vladimir on 28.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import SwiftyJSON

class Ingridient{
    let id: Int
    let amount: Double
    let unit: String
    let unitShort: String
    let unitLong: String
    let name: String
    let imageURL: String

    
    init(data: JSON){
        self.id = data["id"].intValue
        self.amount = data["amount"].doubleValue
        self.unit = data["unit"].stringValue
        self.unitShort = data["unitShort"].stringValue
        self.unitLong = data["unitLong"].stringValue
        self.name = data["name"].stringValue
        self.imageURL = data["image"].stringValue
    }
}
