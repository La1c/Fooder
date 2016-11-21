//
//  ExploreRecipeCell.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class ExploreRecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    
    
    func configureCell(for recipe: Recipe){
        imageView.imageFromUrl(urlString: recipe.imageURL)
        mealNameLabel.text = recipe.title
    }
}
