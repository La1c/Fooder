//
//  ExploreCollectionViewController.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MealCell"

class ExploreCollectionViewController: UICollectionViewController {
    @IBOutlet var searchBarButton: UIBarButtonItem!
    
    let searchBar = UISearchBar()
    var basicNavigationBar = UIView()

    var recipes = [Recipe]()
    var model: ExploreModel!
    
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ExploreModel.sharedInstance
        model.delegate = self
        model.getData()
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        cell.sizeThatFits(CGSize(width: view.frame.width, height: cell.frame.height))
        if let cell =  cell as? ExploreRecipeCell{
            cell.configureCell(for: recipes[indexPath.row])
        }
    
        return cell
    }
}

//MARK: -ExploreModelDelegate
extension ExploreCollectionViewController: ExploreModelDelegate{
    func modelDidLoadNewData() {
        recipes = model.recipes
        collectionView?.reloadData()
    }
}

//MARK: -prepareForSegue
extension ExploreCollectionViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails"{
            if let cell = sender as? ExploreRecipeCell{
                guard let row = collectionView?.indexPath(for: cell)?.row else{
                    return
                }
                
                let vc = segue.destination as! DetailsViewController
                vc.image = cell.imageView.image
                vc.recipe = recipes[row]
            }
        }
    }
}

//MARK: -Search
extension ExploreCollectionViewController{
    @IBAction func searchBarButtonPressed(_ sender: Any) {
    
        self.navigationItem.rightBarButtonItem = nil
        searching = true
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
}


extension ExploreCollectionViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Explore"
        //self.navigationItem.rightBarButtonItem = searchBarButton
        self.navigationController?.navigationItem.rightBarButtonItem = searchBarButton
        
    }
}

