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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingridients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell", for: indexPath)

        cell.textLabel?.text = ingridients[indexPath.row].name
        cell.detailTextLabel?.text = String(ingridients[indexPath.row].amount) + " " + String(ingridients[indexPath.row].unit)
        return cell
    }
}
