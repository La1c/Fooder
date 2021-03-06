//
//  GroceryListViewController.swift
//  Fooder
//
//  Created by Vladimir on 11.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet


class GroceryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var cookTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cookTableView: UITableView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var bagTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bagTableView: UITableView!
    @IBOutlet var listTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var groceryListTableView: UITableView!
    var items: Results<IngridientRealm>?
    var bag: Results<IngridientRealm>?
    var cook: Results<RecipeRealm>?
    
    @IBOutlet var clearButtons: [ClearAllUIButton]!

    @IBOutlet weak var emptyStateSubLabel: UILabel!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var bagImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView(tableView: groceryListTableView)
        configureTableView(tableView: bagTableView)
        
        cookTableView.delegate = self
        cookTableView.dataSource = self
        cookTableView.tableFooterView = UIView(frame: CGRect.zero)
        cookTableView.rowHeight = 80
    }
    
    func configureTableView(tableView: UITableView){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setGoodConstrains<T: Object>(for tableView: UITableView,
                           withContstraint: NSLayoutConstraint,
                           list: Results<T>){
        
        tableView.sizeToFit()
        withContstraint.constant = tableView.contentSize.height
        if  list.count > 0{
            tableView.frame.size.height = tableView.contentSize.height
            tableView.layoutIfNeeded()
            let lastRowFrame = tableView.rectForRow(at: IndexPath(row: list.count - 1, section: 0))
            
            withContstraint.constant = (lastRowFrame.origin.y + lastRowFrame.height)
            tableView.frame.size.height = (lastRowFrame.origin.y + lastRowFrame.height)
        }
        tableView.updateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        items = realm.objects(IngridientRealm.self).filter("inGroceryList == true AND inBag == false")
        bag = realm.objects(IngridientRealm.self).filter("inGroceryList == true AND inBag == true")
        cook = realm.objects(RecipeRealm.self).filter("isInList == true")
        groceryListTableView.reloadData()
        bagTableView.reloadData()
        cookTableView.reloadData()
        
        checkEmptyStates()
        
        setGoodConstrains(for: groceryListTableView, withContstraint: listTableViewHeightConstraint, list: items!)
        setGoodConstrains(for: bagTableView, withContstraint: bagTableViewHeightConstraint,list: bag!)
        setGoodConstrains(for: cookTableView, withContstraint: cookTableViewHeightConstraint, list: cook!)
        let statusBarBlur = UIBlurEffect(style: .extraLight)
        let statusBarBlurView = UIVisualEffectView(effect: statusBarBlur)
        statusBarBlurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        view.addSubview(statusBarBlurView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.restorationIdentifier == "listTableView"{
            return items?.count ?? 0
        }
        
        if tableView.restorationIdentifier == "bagTableView"{
            return bag?.count ?? 0
        }
        
        if tableView.restorationIdentifier == "cookTableView"{
            return cook?.count ?? 0
        }
        
        return 0
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if tableView.restorationIdentifier == "cookTableView"{
            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeToCook", for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "ItemToBuy", for: indexPath)
        }
        
        if tableView.restorationIdentifier == "listTableView"{
            if let cell = cell as? GroceryListTableViewCell,
                let items = items{
                cell.configureCell(for: items[indexPath.row])
            }
        }
        
        if tableView.restorationIdentifier == "bagTableView"{
            if let cell = cell as? GroceryListTableViewCell,
                let bag = bag{
                cell.configureCell(for: bag[indexPath.row])
            }
        }
        
        if tableView.restorationIdentifier == "cookTableView"{
            if let cell = cell as? CookTableViewCell,
                let cook = cook{
                cell.configureCell(for: cook[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let checkAction = UITableViewRowAction(style: .default, title: "Got it!", handler: {
            self.checkItem(action: $0, from: $1)
        })
        
        checkAction.backgroundColor = view.tintColor
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler:{ self.deleteItem(action: $0, from: $1, tableView: tableView)})
        
        deleteAction.backgroundColor = UIColor.red
        
        if tableView.restorationIdentifier == "listTableView"{
           return [deleteAction, checkAction]
        }
        
        return [deleteAction]
        
    }
    
    func checkItem(action: UITableViewRowAction, from: IndexPath){
        if let items = items{
            let id = items[from.row].id
            let product = realm.objects(IngridientRealm.self).filter("id == %@", id)[0]
            try! realm.write{
                product.inBag = true
            }
            
            let indexPaths = [from]
            
            groceryListTableView.deleteRows(at: indexPaths, with: .automatic)
            bag = realm.objects(IngridientRealm.self).filter("inGroceryList == true AND inBag == true")
            checkEmptyStates()
            bagTableView.reloadData()
            setGoodConstrains(for: groceryListTableView, withContstraint: listTableViewHeightConstraint, list: items)
            setGoodConstrains(for: bagTableView, withContstraint: bagTableViewHeightConstraint,list: bag!)
        }
    }
    
    func deleteItem(action:  UITableViewRowAction, from: IndexPath, tableView: UITableView){
    
        let list:Results<IngridientRealm>?
        if tableView.restorationIdentifier == "listTableView"{
            list = items
        } else if tableView.restorationIdentifier == "bagTableView"{
            list = bag
        }else{
            list = nil
        }
        
        if tableView.restorationIdentifier == "cookTableView"{
            if let cook = cook{
                try! realm.write {
                    if cook[from.row].isCooked || cook[from.row].isFavorite{
                        cook[from.row].isInList = false
                    }else{
                        realm.delete(cook[from.row])
                    }
                }
            }
        }else{
            if let list = list{
                let id = list[from.row].id
                let product = realm.objects(IngridientRealm.self).filter("id == %@", id)[0]
                try! realm.write{
                    realm.delete(product)
                }
            }
        }
        let indexPaths = [from]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        checkEmptyStates()
        setGoodConstrains(for: groceryListTableView, withContstraint: listTableViewHeightConstraint, list: items!)
        setGoodConstrains(for: bagTableView, withContstraint: bagTableViewHeightConstraint,list: bag!)
        setGoodConstrains(for: cookTableView, withContstraint: cookTableViewHeightConstraint, list: cook!)
    }
}


//MARK: -prepareForSegue
extension GroceryListViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails"{
            if let cell = sender as? CookTableViewCell{
                guard let row = cookTableView?.indexPath(for: cell)?.row,
                let recipe = cook?[row] else{
                    return
                }
                
                let vc = segue.destination as! DetailsViewController
                vc.image = cell.mealUIImageView.image
                vc.recipe = Recipe(id: recipe.id, title: recipe.title, imageURL: recipe.imageURL)
                vc.hideAddButton = true
            }
        }
    }
}


//MARK: -handling empty state
extension GroceryListViewController{
    func checkEmptyStates(){
        let cookIsEmpty = cook?.count == 0
        let ingridientsIsEmpty = items?.count == 0
        let bagIsEmpty = bag?.count == 0
        let everythignIsEmpty = cookIsEmpty && ingridientsIsEmpty && bagIsEmpty
        
        bagTableView.isHidden = bagIsEmpty
        groceryListTableView.isHidden = ingridientsIsEmpty
        cookTableView.isHidden = cookIsEmpty
        
        
        bagImageView.isHidden = !everythignIsEmpty
        emptyStateLabel.isHidden = !everythignIsEmpty
        emptyStateSubLabel.isHidden = emptyStateLabel.isHidden
    }
}

//MARK: - clear all buttons
extension GroceryListViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let button = clearButtons.first(where: {$0.clearState == .preparedForAction}),
                let touch = touches.first{
                
                if button.frame.contains(touch.location(in: button.superview)){
                    if let tableview = button.superview?.superview as? UITableView{
                        clearAll(from: tableview.restorationIdentifier ?? "")
                        tableview.reloadData()
                    }
                    checkEmptyStates()
                   setGoodConstrains(for: cookTableView, withContstraint: cookTableViewHeightConstraint, list: cook!)
                    setGoodConstrains(for: bagTableView, withContstraint: bagTableViewHeightConstraint,list: bag!)
                    setGoodConstrains(for: groceryListTableView, withContstraint: listTableViewHeightConstraint, list: items!)
                }
                button.switchState()
        }
        self.scrollView.isUserInteractionEnabled = true
    }
    
    @IBAction func clearAllButtonPressed(_ sender: Any){
        if let button = sender as? ClearAllUIButton{
            button.switchState()
            
            if button.clearState == .preparedForAction{
                scrollView.isUserInteractionEnabled = false
            }
        }
    }
    
    
    func clearAll(from tableView: String){
        switch tableView {
        case "listTableView":
            try! realm.write {
                realm.delete(items!)
            }
        case "bagTableView":
            try! realm.write {
                realm.delete(bag!)
            }
        case "cookTableView":
            try! realm.write {
                realm.delete(cook!)
            }

        default:
            return
        }
        
    }
}






