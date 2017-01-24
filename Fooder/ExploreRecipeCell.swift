//
//  ExploreRecipeCell.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import CoreGraphics

class ExploreRecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealNameView: UIView!
    
    func configureCell(for recipe: Recipe, prefetched: Bool = false){
        if !prefetched{
            imageView.imageFromUrl(urlString: recipe.imageURL)
        }
        mealNameLabel.text = recipe.title
    }
}
