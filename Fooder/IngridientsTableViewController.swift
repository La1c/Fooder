//
//  IngridientsTableViewController.swift
//  Fooder
//
//  Created by Vladimir on 10.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit


protocol IngridientsTableViewDelegate: class {
    func didLayoutAllCells(sender: IngridientsTableViewController)
}

class IngridientsTableViewController: UITableViewController {
    
    
    var ingridients:[Ingridient]!
    weak var delegate:IngridientsTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView(frame: .zero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingridients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientCell", for: indexPath)

        cell.textLabel?.text = ingridients[indexPath.row].name
        cell.detailTextLabel?.text = String(ingridients[indexPath.row].amount)

        return cell
    }

    
    
    //FIX-ME: -figure out how to show full table view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.tableView.frame.size.height = self.tableView.contentSize.height
       // print("Table view did appear")
        //   delegate?.didLayoutAllCells(sender: self)
        //self.tableView.frame.size.height = self.tableView.contentSize.height
    }
    
    


}
