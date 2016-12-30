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

    // MARK: - Table view data source

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
}
