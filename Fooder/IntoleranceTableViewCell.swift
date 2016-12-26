//
//  IntoleranceTableViewCell.swift
//  Fooder
//
//  Created by Vladimir on 26.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift

class IntoleranceTableViewCell: UITableViewCell {

    func configure(with label: String){
        self.textLabel?.text = label
        let name = label.lowercased()
        let predicate = NSPredicate(format: "name = %@", name)
        self.accessoryType = realm.objects(Intolerance.self).filter(predicate)[0].status ? .checkmark : .none
    }

}
