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
    @IBOutlet var searchCategoryView: UIView!
    
    let searchBar = UISearchBar()

    var recipes = [Recipe]()
    var model: ExploreModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ExploreModel.sharedInstance
        model.delegate = self
        model.getData()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let collectionView = collectionView as? CollectionViewWithHeader{
            collectionView.fixedHeaderView = searchCategoryView
        }
        
        let statusBarBlur = UIBlurEffect(style: .extraLight)
        let statusBarBlurView = UIVisualEffectView(effect: statusBarBlur)
        statusBarBlurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        view.addSubview(statusBarBlurView)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            if recipes[indexPath.row].ingridients?.count == 0{
//                FoodService.getRecipeByID(id: recipes[indexPath.row].id, completion: {data in
//                    if let newRecipe = data{
//                        self.recipes[indexPath.row] = newRecipe
//                        self.performSegue(withIdentifier: "ShowDetails", sender: collectionView.cellForItem(at: indexPath))
//                    }
//                })
//            }else{
//                performSegue(withIdentifier: "ShowDetails", sender: collectionView.cellForItem(at: indexPath))
//        }
        performSegue(withIdentifier: "ShowDetails", sender: collectionView.cellForItem(at: indexPath))
        }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.navigationItem.titleView?.addSubview(searchBar)
        
        if let collectionView = collectionView as? CollectionViewWithHeader{
            collectionView.searchIsActive = true
        }
        
        self.navigationItem.titleView = searchBar
         self.navigationItem.rightBarButtonItem = nil
          searchBar.becomeFirstResponder()
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



extension ExploreCollectionViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = searchBarButton
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!
        model.searchRecipes(query: query)
    }
}


