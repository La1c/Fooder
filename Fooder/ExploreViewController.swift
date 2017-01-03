//
//  ExploreViewController.swift
//  Fooder
//
//  Created by Vladimir on 25.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet var foodTypeSegmentControl: UISegmentedControl!
    @IBOutlet var foodTypeScrollView: UIScrollView!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    var lastOffset: CGFloat = 0
    var loadingMore = false
    
    var recipes = [Recipe]()
    var model: ExploreModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        model = ExploreModel.sharedInstance
        model.delegate = self
        model.searchRecipes()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let statusBarBlur = UIBlurEffect(style: .extraLight)
        let statusBarBlurView = UIVisualEffectView(effect: statusBarBlur)
        statusBarBlurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        view.addSubview(statusBarBlurView)
        lastOffset = self.collectionView.contentOffset.y
        foodTypeScrollView.isHidden = self.navigationItem.titleView != searchBar
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.navigationItem.titleView?.addSubview(searchBar)
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = nil
        foodTypeScrollView.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        search()
        collectionView.scrollToItem(at: IndexPath(row:0, section: 0), at: .top, animated: true)
    }
    
    func search(offset: Int = 0, more: Bool = false){
        let foodType =   foodTypeSegmentControl.titleForSegment(at: foodTypeSegmentControl.selectedSegmentIndex)!.lowercased()
        let foodTypeEnum = FoodType(rawValue: foodType) ?? .all
        let query = searchBar.text!
        loadingMore = true
        model.searchRecipes(query: query, type: foodTypeEnum, offset:offset, more: more)
    }
}


extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell",
                                                      for: indexPath)
        cell.sizeThatFits(CGSize(width: view.frame.width, height: cell.frame.height))
        if let cell =  cell as? ExploreRecipeCell{
            cell.configureCell(for: recipes[indexPath.row])
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= self.lastOffset || self.navigationItem.titleView != self.searchBar{
            self.foodTypeScrollView.isHidden = true
        }
        else{
            self.foodTypeScrollView.isHidden = false
        }
        self.lastOffset = scrollView.contentOffset.y
        
        
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - self.lastOffset
        
        if deltaOffset <= 0 {
            if(!loadingMore){
                search(offset: recipes.count, more: true)
            }
        }
        
    }
}


extension ExploreViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = searchButton
        foodTypeScrollView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       search()
       collectionView.scrollToItem(at: IndexPath(row:0, section: 0), at: .top, animated: true)
    }
}

//MARK: -ExploreModelDelegate
extension ExploreViewController: ExploreModelDelegate{
    func modelDidLoadNewData() {
        recipes = model.recipes
        loadingMore = false
        collectionView.reloadData()
    }
}

//MARK: -prepareForSegue
extension ExploreViewController{
    
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




