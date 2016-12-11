//
//  IngridientObject.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation

class Ingridient{
    let id: Int
    let amount: Double
    let unit: String
    let unitShort: String
    let name: String
    
    init(id: Int, amount: Double, unit: String, unitShort: String, name: String) {
        self.id = id
        self.amount = amount
        self.unit = unit
        self.unitShort = unitShort
        self.name = name
    }
}
