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
    @IBOutlet var ingridientsTableView: UITableView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var instructionsHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyInLabel: UILabel!
    
    var recipe: Recipe!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingridientsTableView.delegate = self
        ingridientsTableView.dataSource = self
        imgeView.image = image
        instructionsTextField.text = recipe.instructions
        recipeNameLabel.text = recipe.title
        
        servingsLabel.text = servingsLabel.text! + " " + String(recipe.servings!)
        readyInLabel.text = readyInLabel.text! + " " + String(recipe.readyInMinutes!) + " min"
        
        
        if recipe.ingridients?.count == 0{
            FoodService.getRecipeByID(id: recipe.id, completion: {data in
                                if let newRecipe = data{
                                    self.recipe = newRecipe
                                    self.updateUI()
                                }})
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGoodConstrains()
        let statusBarBlur = UIBlurEffect(style: .extraLight)
        let statusBarBlurView = UIVisualEffectView(effect: statusBarBlur)
        statusBarBlurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        view.addSubview(statusBarBlurView)
    }
    
    
    func setGoodConstrains(){
        ingridientsTableView.sizeToFit()
        tableViewHeightConstraint.constant = ingridientsTableView.contentSize.height
        instructionsHeightConstrain.constant = instructionsTextField.intrinsicContentSize.height
    }
}



//MARK: -add button pressed
extension DetailsViewController{
    @IBAction func AddToGroceryListButonTapped(_ sender: Any) {
        let newFromRecipe = RecipeRealm()
        newFromRecipe.id = recipe.id
        newFromRecipe.title = recipe.title
        for item in recipe.ingridients!{
            
            let newItemInList = GroceryListItem()
            newItemInList.id = item.id
            newItemInList.unit = item.unitShort
            newItemInList.name = item.name
            newItemInList.imageURL = item.imageURL
            
            try! realm.write {
                let someItem = realm.create(GroceryListItem.self, value: newItemInList, update: true)
                //if !someItem.fromRecipes.contains(newFromRecipe){
                    someItem.fromRecipes.append(newFromRecipe)
                    
                //    if(someItem.unit == item.unit){
                        someItem.amount += item.amount
                  //  }else{
                 //       FoodService.convertAmount(ingridientName: item.name, sourceAmount: item.amount, sourceUnit: item.unit, targetUnit: someItem.unit, completion: { data in
                 //           if let converted = data{
                  //              try! realm.write {
                  //                  someItem.amount += converted.convertedAmount
                    //            }
                   //         }
                 //       })
                 //   }
                    
                //}
            }
        }
        
    }
}


//MARK: -Update UI
extension DetailsViewController{
    func updateUI(){
        instructionsTextField.text = recipe.instructions
        recipeNameLabel.text = recipe.title
        servingsLabel.text = "Servings: " + String(recipe.servings!)
        readyInLabel.text = "Ready in: " + String(recipe.readyInMinutes!) + " min"
        ingridientsTableView.reloadData()
        setGoodConstrains()
    }
}

//MARK: -Table View
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingridients!.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell", for: indexPath)
        
        cell.textLabel?.text = recipe.ingridients![indexPath.row].name
        cell.detailTextLabel?.text = String(recipe.ingridients![indexPath.row].amount) + " " + String(recipe.ingridients![indexPath.row].unit)
        return cell
    }
}

