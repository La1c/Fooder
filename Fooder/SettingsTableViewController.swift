//
//  SettingsTableViewController.swift
//  Fooder
//
//  Created by Vladimir on 25.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsTableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowIntolerances"{
            if let navigationVC = segue.destination as? UINavigationController,
               let destinationVC = navigationVC.viewControllers[0] as? IntolerancesTableViewController{
                    destinationVC.delegate = self
            }
        }
    }
    
    func configureSubtitleText(with: Results<Intolerance>){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        
        var subtitleText:String
        switch with.count {
        case 0:
            subtitleText = "No Intolerances"
        case 1:
            subtitleText = with[0].name
        case 2:
            subtitleText = with[0].name + ", " + with[1].name
        default:
            subtitleText = with[0].name + ", " + with[1].name + " and \(with.count - 2) more"
        }
        cell?.detailTextLabel?.text = subtitleText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSubtitleText(with: realm.objects(Intolerance.self).filter("status == true"))
    }
}

extension SettingsTableViewController: IntolerancesTableViewControllerDelegate{
    func userFinishedChoosingIntolerances(chosen: Results<Intolerance>) {
        configureSubtitleText(with: chosen)
        dismiss(animated: true, completion: nil)
    }
}
