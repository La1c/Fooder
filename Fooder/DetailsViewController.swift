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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var rightDotImageView: UIImageView!
    @IBOutlet weak var centerDotImageView: UIImageView!
    @IBOutlet weak var leftDotImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet var favoritesButton: UIButton!
    @IBOutlet weak var cookedButton: UIButton!
    @IBOutlet weak var instructionsTableViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var ingridientsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readyInLabel: UILabel!
    @IBOutlet weak var addToListButton: UIButton!
    var recipe: Recipe!
    var image: UIImage!
    
    var hideAddButton = false
    
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
        
        scrollView.delegate = self
        imageView.image = image
        recipeNameLabel.text = recipe.title
        
        startAnimation()
        
        addToListButton.isHidden = hideAddButton

        FoodService.getRecipeByID(id: recipe.id, completion: {data in
                                if let newRecipe = data{
                                    self.recipe = newRecipe
                                    self.updateUI()
                                    self.stopAnimation()
                                }})
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGoodConstrains()
        let statusBarBlur = UIBlurEffect(style: .extraLight)
        let statusBarBlurView = UIVisualEffectView(effect: statusBarBlur)
        statusBarBlurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        view.addSubview(statusBarBlurView)
        checkFavoritesAndCooked()
    }
    
    
    
    func checkFavoritesAndCooked(){
        //checking data in realm in background
        let backgroundQueue = DispatchQueue(label: "com.fooder.background", qos: .userInitiated, attributes: .concurrent)
        backgroundQueue.async {
            let realmThread = try! Realm()
            if let recipeInRealm = realmThread.object(ofType: RecipeRealm.self, forPrimaryKey: self.recipe.id){
                if recipeInRealm.isCooked{
                    DispatchQueue.main.async {
                       self.cookedButton.isSelected = true
                    }
                }
                
                if recipeInRealm.isFavorite{
                    DispatchQueue.main.async {
                       self.favoritesButton.isSelected = true
                    }
                }
            }
        }
    }
    
    func setGoodConstrains(){
        ingridientsTableView.sizeToFit()
        tableViewHeightConstraint.constant = ingridientsTableView.contentSize.height
        instructionsTableView.sizeToFit()
        instructionsTableViewHeightConstrain.constant = instructionsTableView.contentSize.height
        instructionsTableView.frame.size.height = instructionsTableView.contentSize.height
        instructionsTableView.layoutIfNeeded()
        
        if recipe.extendedInstructions.count > 0{
            let lastRowFrame = instructionsTableView.rectForRow(at: IndexPath(row: recipe.extendedInstructions.count - 1, section: 0))
            
            instructionsTableViewHeightConstrain.constant = (lastRowFrame.origin.y + lastRowFrame.height)
            instructionsTableView.frame.size.height = (lastRowFrame.origin.y + lastRowFrame.height)
        }
        
        instructionsTableView.updateConstraints()
    }
    @IBAction func cookedButtonPressed(_ sender: Any) {

        scale(button: self.cookedButton)
        self.cookedButton.isSelected = !self.cookedButton.isSelected
        
        let backgroundQueue = DispatchQueue(label: "com.fooder.background", qos: .userInitiated, attributes: .concurrent)
        backgroundQueue.async {
            let realmThread = try! Realm()
            try! realmThread.write {
                realmThread.create(RecipeRealm.self,
                             value: ["id": self.recipe.id,
                                     "imageURL": self.recipe.imageURL,
                                     "title": self.recipe.title,
                                     "isCooked": self.cookedButton.isSelected],
                             update: true)
            }
        }
    }
    
    @IBAction func favoritesButtonPressed(_ sender: Any) {
        
        scale(button: self.favoritesButton)
        self.favoritesButton.isSelected = !self.favoritesButton.isSelected
        
        let backgroundQueue = DispatchQueue(label: "com.fooder.background", qos: .userInitiated, attributes: .concurrent)
        backgroundQueue.async {
            let realmThread = try! Realm()
            try! realmThread.write {
                realmThread.create(RecipeRealm.self,
                             value: ["id": self.recipe.id,
                                     "imageURL": self.recipe.imageURL,
                                     "title": self.recipe.title,
                                     "isFavorite": self.favoritesButton.isSelected],
                             update: true)
            }
        }

    }
}


//MARK: -add button pressed
extension DetailsViewController{
    @IBAction func AddToGroceryListButonTapped(_ sender: Any) {
        
        
        //TO-DO: - get this to background thread
        scale(button: addToListButton)
        let realmThread = try! Realm()
        let ingridientsList = List<IngridientRealm>()
        try! realmThread.write {
        for item in self.recipe.ingridients{

            if let itemAlreadyInList = realmThread.object(ofType: IngridientRealm.self, forPrimaryKey: item.id) {
                     itemAlreadyInList.inGroceryList = true
                     let unitInList = itemAlreadyInList.unitLong
                     let unitOfItem = item.unitLong
                     let preffix = unitInList.commonPrefix(with: unitOfItem, options: .caseInsensitive)
                if preffix == unitOfItem || preffix == unitInList{
                     itemAlreadyInList.amount += item.amount
                }else{
                    
                   FoodService.convertAmount(ingridientName: item.name, sourceAmount: item.amount, sourceUnit: item.unitLong, targetUnit: unitInList,
                                              completion: { converted in
                                                if let converted = converted{
                                                    try! realmThread.write {
                                                        itemAlreadyInList.amount += converted.convertedAmount
                                                    }
                                                }
                   })
                }
                
                ingridientsList.append(itemAlreadyInList)
            }
            else{
                let newItem = IngridientRealm(data: item, isInList: true)
                realmThread.add(newItem)
                ingridientsList.append(newItem)
                }
            }
            
            realmThread.create(RecipeRealm.self,
                         value: ["id": self.recipe.id,
                                 "imageURL": self.recipe.imageURL,
                                 "title": self.recipe.title,
                                 "ingridients": ingridientsList,
                                 "instructions": self.recipe.instructions ?? "",
                                 "readyInMinutes": self.recipe.readyInMinutes,
                                 "servings": self.recipe.servings,
                                 "vegan": self.recipe.vegan,
                                 "vegeterian": self.recipe.vegeterian,
                                 "isInList": true],
                         update: true)
        }
    }
}


//MARK: -Update UI
extension DetailsViewController{
    func updateUI(){
        recipeNameLabel.text = recipe.title
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        
        servingsLabel.text = "Servings: " + formatter.string(from: recipe.servings as NSNumber)!
        readyInLabel.text = "Ready in: " + formatter.string(from: recipe.readyInMinutes as NSNumber)! + " min"
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
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            let amountString = formatter.string(from: recipe.ingridients[indexPath.row].amount as NSNumber)!
            
            cell.textLabel?.text = recipe.ingridients[indexPath.row].name
            cell.detailTextLabel?.text = amountString + " " + String(recipe.ingridients[indexPath.row].unit)
            return cell

        }
        
        if tableView.restorationIdentifier! == "instructionsTableView"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
            if let cell = cell as? InstructionTableViewCell{
                cell.configure(with: recipe.extendedInstructions[indexPath.row], at: indexPath.row)
            }
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - header animation
extension DetailsViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var imageTransform = CATransform3DIdentity
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        if (offset + navigationBarHeight) < 0 {
            let imageScaleFactor:CGFloat = -(offset + navigationBarHeight) / imageView.bounds.height
            let imageSizevariation = ((imageView.bounds.height * (1.0 + imageScaleFactor)) - imageView.bounds.height)/2.0
            imageTransform = CATransform3DTranslate(imageTransform, 0, imageSizevariation + offset + navigationBarHeight, 0)
            imageTransform = CATransform3DScale(imageTransform, 1.0 + imageScaleFactor, 1.0 + imageScaleFactor, 0)
            imageView.layer.transform = imageTransform
        } 
    }
}

//MARK: - loading animation
extension DetailsViewController{
    func startAnimation(){
        self.scrollView.isScrollEnabled = false
        leftDotImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        centerDotImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        rightDotImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.leftDotImageView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.centerDotImageView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.rightDotImageView.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    func stopAnimation(){
       
       UIView.transition(from: placeholderView,
                         to: contentView,
                         duration: 0.5,
                         options: .transitionCrossDissolve,
                         completion: nil)
       self.scrollView.isScrollEnabled = true
    }
    
}


extension DetailsViewController{
    func scale(button: UIButton){
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: [.curveLinear, .allowUserInteraction],
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        },completion: {finish in
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: [.curveLinear, .allowUserInteraction],
                           animations: {
                            button.transform = CGAffineTransform.identity
            },completion: nil)
        })
    }
}
