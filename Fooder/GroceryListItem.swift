//
//  GroceryListItem.swift
//  Fooder
//
//  Created by Vladimir on 11.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation
import RealmSwift


class GroceryListItem: Object{
    dynamic var id = 0
    dynamic var amount: Double = 0
    dynamic var unit: String = ""
    dynamic var name: String = ""
    dynamic var imageURL: String = ""
    let fromRecipes = List<RecipeRealm>()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
