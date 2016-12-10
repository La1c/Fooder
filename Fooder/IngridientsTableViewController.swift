//
//  IngridientsTableViewController.swift
//  Fooder
//
//  Created by Vladimir on 10.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class IngridientsTableViewController: UITableViewController {
    
    
    var ingridients:[Ingridient]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingridients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell", for: indexPath)

        cell.textLabel?.text = ingridients[indexPath.row].name
        cell.detailTextLabel?.text = String(ingridients[indexPath.row].amount)

        return cell
    }


}
