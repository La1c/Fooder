//
//  GroceryListViewController.swift
//  Fooder
//
//  Created by Vladimir on 11.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift

class GroceryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var bagTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bagTableView: UITableView!
    @IBOutlet var bagLabel: UILabel!
    @IBOutlet var listTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var groceryListTableView: UITableView!
    var items: Results<IngridientRealm>? = nil
    var bag: Results<IngridientRealm>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        groceryListTableView.rowHeight = UITableViewAutomaticDimension
        groceryListTableView.estimatedRowHeight = 40
        groceryListTableView.delegate = self
        groceryListTableView.dataSource = self
        
        bagTableView.rowHeight = UITableViewAutomaticDimension
        bagTableView.estimatedRowHeight = 40
        bagTableView.delegate = self
        bagTableView.dataSource = self
        
        
    }
    
    func setGoodConstrains(){
        groceryListTableView.sizeToFit()
        listTableViewHeightConstraint.constant = groceryListTableView.contentSize.height
        
        bagTableView.sizeToFit()
        bagTableViewHeightConstraint.constant = bagTableView.contentSize.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        items = realm.objects(IngridientRealm.self).filter("inGroceryList == true AND inBag == false")
        bag = realm.objects(IngridientRealm.self).filter("inGroceryList == true AND inBag == true")
        
        bagLabel.isHidden = (bag?.count)! < 1
        bagTableView.isHidden = bagLabel.isHidden
        
        
        groceryListTableView.reloadData()
        bagTableView.reloadData()
        
        setGoodConstrains()
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
        
        return 0
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemToBuy", for: indexPath)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let checkAction = UITableViewRowAction(style: .default, title: "Got it!", handler: {
            self.checkItem(action: $0, from: $1)
        })
        
        checkAction.backgroundColor = view.tintColor
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler:{ self.deleteItem(action: $0, from: $1)})
        
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction,checkAction]
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
            bagLabel.isHidden = false
            bagTableView.isHidden = false
            bagTableView.reloadData()
            setGoodConstrains()
        }
    }
    
    func deleteItem(action:  UITableViewRowAction, from: IndexPath){
       // if action.title == "Delete"{
            if let items = items{
            let id = items[from.row].id
            let product = realm.objects(IngridientRealm.self).filter("id == %@", id)[0]
            try! realm.write{
                realm.delete(product)
            }
            
            let indexPaths = [from]
            
            groceryListTableView.deleteRows(at: indexPaths, with: .automatic)
            }
        //}
    }
}
