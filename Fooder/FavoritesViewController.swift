//
//  FavoritesViewController.swift
//  Fooder
//
//  Created by Vladimir on 05.01.17.
//  Copyright © 2017 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class FavoritesViewController: UIViewController {


    var recipes: Results<RecipeRealm>?
    
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        recipesTableView.emptyDataSetSource = self
        recipesTableView.emptyDataSetDelegate = self
        recipes = realm.objects(RecipeRealm.self).filter("isFavorite == true")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recipesTableView.reloadData()
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            recipes = realm.objects(RecipeRealm.self).filter("isFavorite == true")
        }else{
            recipes = realm.objects(RecipeRealm.self).filter("isCooked == true")
        }
        
        recipesTableView.reloadData()
    }
}

//MARK: -table views
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeToCook", for: indexPath)
        
        if let cell = cell as? CookTableViewCell, let recipes = recipes{
            cell.configureCell(for: recipes[indexPath.row])
        }
        
        return cell
    }
}


//MARK: -prepareForSegue
extension FavoritesViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails"{
            if let cell = sender as? CookTableViewCell{
                guard let row = recipesTableView?.indexPath(for: cell)?.row,
                    let recipe = recipes?[row] else{
                        return
                }
                
                let vc = segue.destination as! DetailsViewController
                vc.image = cell.mealUIImageView.image
                vc.recipe = Recipe(id: recipe.id, title: recipe.title, imageURL: recipe.imageURL)
            }
        }
    }
}

//MARK: -empty data set
extension FavoritesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSForegroundColorAttributeName: self.view.tintColor as Any]
        return NSAttributedString(string: "Nothing here yet", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSForegroundColorAttributeName: self.view.tintColor as Any]
        
        if segmentedControl.selectedSegmentIndex == 0{
            return NSAttributedString(string: "Try to find something you like at the Explore tab!", attributes: attributes)
        }else{
            return NSAttributedString(string: "You can add recipe to this list from a recipe card", attributes: attributes)
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if segmentedControl.selectedSegmentIndex == 0{
            return UIImage(named: "star")
        }else{
            return UIImage(named: "accept")
        }
    }
}
