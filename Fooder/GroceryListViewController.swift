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
    
    @IBOutlet var groceryListTableView: UITableView!
    var items: Results<IngridientRealm>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        groceryListTableView.rowHeight = UITableViewAutomaticDimension
        groceryListTableView.estimatedRowHeight = 40
        groceryListTableView.delegate = self
        groceryListTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        items = realm.objects(IngridientRealm.self).filter("inGroceryList == true")
        groceryListTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemToBuy", for: indexPath)
        if let cell = cell as? GroceryListTableViewCell,
            let items = items{
            cell.configureCell(for: items[indexPath.row])
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let items = items{
            let id = items[indexPath.row].id
            let product = realm.objects(IngridientRealm.self).filter("id == %@", id)[0]
            try! realm.write{
                realm.delete(product)
            }
        
            let indexPaths = [indexPath]
        
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
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
       // }
        }
    }
}
