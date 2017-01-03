//
//  CookTableViewCell.swift
//  Fooder
//
//  Created by Vladimir on 04.01.17.
//  Copyright © 2017 Vladimir Ageev. All rights reserved.
//

import UIKit

class CookTableViewCell: UITableViewCell {

    @IBOutlet var mealNameLabel: UILabel!
    @IBOutlet var mealUIImageView: UIImageView!
    
    func configureCell(for recipe: RecipeRealm){
        mealUIImageView.imageFromUrl(urlString: recipe.imageURL)
        mealNameLabel.text = recipe.title
    }
}
