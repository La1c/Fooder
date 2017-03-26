//
//  IntolerancesTableViewController.swift
//  Fooder
//
//  Created by Vladimir on 25.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift

protocol IntolerancesTableViewControllerDelegate: class{
    func userFinishedChoosingIntolerances(chosen intolerances: Results<Intolerance>)
}

class IntolerancesTableViewController: UITableViewController {

    weak var delegate: IntolerancesTableViewControllerDelegate?
    
    let intolerancesNames = [
        "Dairy",
        "Egg",
        "Gluten",
        "Peanut",
        "Sesame",
        "Seafood",
        "Shellfish",
        "Soy",
        "Sulfite",
        "Tree nut",
        "Wheat"
    ]
    

    @IBAction func doneButtonPressed(_ sender: Any) {
        delegate?.userFinishedChoosingIntolerances(chosen: realm.objects(Intolerance.self).filter("status == true"))
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntoleranceCell", for: indexPath)

        if let cell = cell as? IntoleranceTableViewCell{
            cell.configure(with: intolerancesNames[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intolerancesNames.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        DispatchQueue.global(qos: .default).sync {
            let realmThread = try! Realm()
            try! realmThread.write {
                realm.create(Intolerance.self,
                             value: ["name":intolerancesNames[indexPath.row].lowercased(), "status": !(cell?.accessoryType == .checkmark)],
                             update: true)
            }
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }
    }
}
