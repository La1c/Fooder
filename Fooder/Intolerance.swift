//
//  Intolerance.swift
//  Fooder
//
//  Created by Vladimir on 19.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import RealmSwift
class Intolerance: Object {
    dynamic var name = ""
    dynamic var status = false
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
