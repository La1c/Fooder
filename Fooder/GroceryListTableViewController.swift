//
//  GroceryListTableViewController.swift
//  Fooder
//
//  Created by Vladimir on 11.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift

class GroceryListTableViewController: UITableViewController {
    
    var items: Results<GroceryListItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(GroceryListItem.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemToBuy", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        cell.detailTextLabel?.text = String(items[indexPath.row].amount) + " " + items[indexPath.row].unit
        cell.imageView?.imageFromUrl(urlString: items[indexPath.row].imageURL)
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
}
