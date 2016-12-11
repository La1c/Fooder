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

    var recipes = [Recipe]()
    var model: ExploreModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ExploreModel.sharedInstance
        model.delegate = self
        model.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        if let cell =  cell as? ExploreRecipeCell{
            cell.configureCell(for: recipes[indexPath.row])
        }
        
        // Configure the cell
    
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
