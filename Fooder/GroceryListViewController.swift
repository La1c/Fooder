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
    
    @IBOutlet var contentView: UIView!
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
        groceryListTableView.tableFooterView = UIView(frame: CGRect.zero)
        groceryListTableView.estimatedRowHeight = 100
        groceryListTableView.delegate = self
        groceryListTableView.dataSource = self
        
        bagTableView.rowHeight = UITableViewAutomaticDimension
        bagTableView.tableFooterView = UIView(frame: CGRect.zero)
        bagTableView.estimatedRowHeight = 100
        bagTableView.delegate = self
        bagTableView.dataSource = self
    }
    
    func setGoodConstrains(for tableView: UITableView, withContstraint: NSLayoutConstraint){
        tableView.sizeToFit()
        let contentSize = tableView.visibleCells.reduce(Double(0), { result, cell in
            result + Double(cell.frame.height)
        })
        withContstraint.constant = CGFloat(contentSize)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        items = realm.objects(IngridientRealm.self).filter("inGroceryList == true AND inBag == false")
        bag = realm.objects(IngridientRealm.self).filter("inGroceryList == true AND inBag == true")
        
        bagLabel.isHidden = (bag?.count)! == 0
        bagTableView.isHidden = bagLabel.isHidden
        
        
        groceryListTableView.reloadData()
        bagTableView.reloadData()
        
        setGoodConstrains(for: groceryListTableView, withContstraint: listTableViewHeightConstraint)
        setGoodConstrains(for: bagTableView, withContstraint: bagTableViewHeightConstraint)
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
            bagLabel.isHidden = false
            bagTableView.isHidden = false
            bagTableView.reloadData()
            setGoodConstrains(for: bagTableView, withContstraint: bagTableViewHeightConstraint)
            setGoodConstrains(for: groceryListTableView, withContstraint: listTableViewHeightConstraint)
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
        
        if let list = list{
            let id = list[from.row].id
            let product = realm.objects(IngridientRealm.self).filter("id == %@", id)[0]
            try! realm.write{
                realm.delete(product)
            }
            
            let indexPaths = [from]
            
            tableView.deleteRows(at: indexPaths, with: .automatic)
            
            setGoodConstrains(for: bagTableView, withContstraint: bagTableViewHeightConstraint)
            setGoodConstrains(for: groceryListTableView, withContstraint: listTableViewHeightConstraint)
        }
    }
}
