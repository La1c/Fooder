//
//  DetailsViewController.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsViewController: UIViewController {

    @IBOutlet weak var imgeView: UIImageView!
    
    @IBOutlet weak var instructionsTextField: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var instructionsHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var ingridientsTableViewContainer: UIView!
    @IBOutlet weak var containerViewHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyInLabel: UILabel!
    var recipe: Recipe!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgeView.image = image
        instructionsTextField.text = recipe.instructions
        recipeNameLabel.text = recipe.title
        
        servingsLabel.text = servingsLabel.text! + " " + String(recipe.servings)
        readyInLabel.text = readyInLabel.text! + " " + String(recipe.readyInMinutes) + " min"
    }
    
    @IBAction func AddToGroceryListButonTapped(_ sender: Any) {
        let newFromRecipe = RecipeRealm()
        newFromRecipe.id = recipe.id
        newFromRecipe.title = recipe.title
        for item in recipe.ingridients{
            
            let newItemInList = GroceryListItem()
            newItemInList.id = item.id
            newItemInList.unit = item.unitShort
            newItemInList.name = item.name
            newItemInList.imageURL = item.imageURL
            
            try! realm.write {
               let someItem = realm.create(GroceryListItem.self, value: newItemInList, update: true)
                someItem.fromRecipes.append(newFromRecipe)
                someItem.amount += item.amount
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        instructionsHeightConstrain.constant = instructionsTextField.intrinsicContentSize.height
      //  print("Big view did appear!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EbededTableViewSegue"{
            if let tableVC = segue.destination as? IngridientsTableViewController{
                tableVC.ingridients = recipe.ingridients
                tableVC.delegate = self
            }
        }
        
    }
}


//MARK: -figure out how to show full table view
extension DetailsViewController: IngridientsTableViewDelegate{
    func didLayoutAllCells(sender: IngridientsTableViewController) {
        containerViewHeightConstrain.constant = sender.tableView.intrinsicContentSize.height
        ingridientsTableViewContainer.sizeToFit()
        //contentView.updateConstraintsIfNeeded()
    }
    
}
