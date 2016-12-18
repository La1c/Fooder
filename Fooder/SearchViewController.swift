//
//  SearchViewController.swift
//  Fooder
//
//  Created by Vladimir on 18.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class{
    func userTappedCancel()
}

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var segmentControl: UISegmentedControl!
    weak var delegate:SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }

}

extension SearchViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.userTappedCancel()
    }
}


extension SearchViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
