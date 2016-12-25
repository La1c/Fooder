//
//  SettingsTableViewController.swift
//  Fooder
//
//  Created by Vladimir on 25.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowIntolerances"{
            if let navigationVC = segue.destination as? UINavigationController,
               let destinationVC = navigationVC.viewControllers[0] as? IntolerancesTableViewController{
                    destinationVC.delegate = self
            }
        }
        
    }
    
}

extension SettingsTableViewController: IntolerancesTableViewControllerDelegate{
    func userFinishedChoosingIntolerances() {
        dismiss(animated: true, completion: nil)
    }
}
