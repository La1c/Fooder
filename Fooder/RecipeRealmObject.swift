//
//  RecipeRealmObject.swift
//  Fooder
//
//  Created by Vladimir on 11.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation
import RealmSwift

class RecipeRealm: Object{
    dynamic var id = 0
    dynamic var title = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
