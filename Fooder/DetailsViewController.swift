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
    @IBOutlet var instructionsTableView: UITableView!
    
    @IBOutlet var instructionsTableViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet var ingridientsTableView: UITableView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyInLabel: UILabel!
    
    var recipe: Recipe!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingridientsTableView.delegate = self
        ingridientsTableView.dataSource = self
        
        instructionsTableView.delegate = self
        instructionsTableView.dataSource = self
        instructionsTableView.rowHeight = UITableViewAutomaticDimension
        instructionsTableView.estimatedRowHeight = 500
        instructionsTableView.tableFooterView = UIView(frame: CGRect.zero)
        instructionsTableView.setNeedsLayout()
        instructionsTableView.layoutIfNeeded()
        
        
        imgeView.image = image
        recipeNameLabel.text = recipe.title
        
        servingsLabel.text = servingsLabel.text! + " " + String(recipe.servings)
        readyInLabel.text = readyInLabel.text! + " " + String(recipe.readyInMinutes) + " min"
        
        
        if recipe.ingridients.count == 0{
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
        
        instructionsTableView.sizeToFit()
        instructionsTableViewHeightConstrain.constant = instructionsTableView.contentSize.height
        
       // instructionsTableView.layoutIfNeeded()
    }
}



//MARK: -add button pressed
extension DetailsViewController{
    @IBAction func AddToGroceryListButonTapped(_ sender: Any) {
        let ingridientsList = List<IngridientRealm>()
        try! realm.write {
        for item in recipe.ingridients{

            if let itemAlreadyInList = realm.object(ofType: IngridientRealm.self, forPrimaryKey: item.id) {
                     itemAlreadyInList.inGroceryList = true
                     itemAlreadyInList.amount += item.amount
                
                ingridientsList.append(itemAlreadyInList)
            }
            else{
                let newItem = IngridientRealm(data: item, isInList: true)
                realm.add(newItem)
                ingridientsList.append(newItem)
                }
            }
                let newRecipe = RecipeRealm()
                newRecipe.id = recipe.id
                newRecipe.imageURL = recipe.imageURL
                newRecipe.ingridients = ingridientsList
                newRecipe.instructions = recipe.instructions
                newRecipe.readyInMinutes = recipe.readyInMinutes
                newRecipe.servings = recipe.servings
                newRecipe.title = recipe.title
                newRecipe.vegan = recipe.vegan
                newRecipe.vegeterian = recipe.vegeterian
                realm.add(newRecipe, update: true)
        }
    }
}


//MARK: -Update UI
extension DetailsViewController{
    func updateUI(){
        recipeNameLabel.text = recipe.title
        servingsLabel.text = "Servings: " + String(recipe.servings)
        readyInLabel.text = "Ready in: " + String(recipe.readyInMinutes) + " min"
        ingridientsTableView.reloadData()
        instructionsTableView.reloadData()
        setGoodConstrains()
    }
}

//MARK: -Table View
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.restorationIdentifier! == "ingridientsTableView"{
            return recipe.ingridients.count
        }
        
        if tableView.restorationIdentifier! == "instructionsTableView"{
             return recipe.extendedInstructions.count
        }
        
        return 0
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.restorationIdentifier! == "ingridientsTableView"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell", for: indexPath)
            
            cell.textLabel?.text = recipe.ingridients[indexPath.row].name
            cell.detailTextLabel?.text = String(recipe.ingridients[indexPath.row].amount) + " " + String(recipe.ingridients[indexPath.row].unit)
            return cell

        }
        
        if tableView.restorationIdentifier! == "instructionsTableView"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
            cell.textLabel?.text = recipe.extendedInstructions[indexPath.row]
            cell.imageView?.image = UIImage(named: String(indexPath.row + 1))
            
            return cell
            
        }
        return UITableViewCell()
    }
}

