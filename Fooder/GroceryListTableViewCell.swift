//
//  GroceryListTableViewCell.swift
//  Fooder
//
//  Created by Vladimir on 17.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class GroceryListTableViewCell: UITableViewCell {

    @IBOutlet weak var ingridientImageView: UIImageView!
    @IBOutlet weak var igridientNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    func configureCell(for item: IngridientRealm){
        igridientNameLabel.text = item.name
        amountLabel.text = String(item.amount) + " " + item.unit
        ingridientImageView.imageFromUrl(urlString: item.imageURL)
    }

}
