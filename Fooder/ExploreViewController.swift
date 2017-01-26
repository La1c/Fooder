//
//  ExploreViewController.swift
//  Fooder
//
//  Created by Vladimir on 25.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class ExploreViewController: UIViewController {

    @IBOutlet var foodTypeSegmentControl: UISegmentedControl!
    @IBOutlet var foodTypeScrollView: UIScrollView!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    var lastOffset: CGFloat = 0
    var loadingMore = false
    var noMoreResults = false
    
    var recipes = [Recipe]()
    var model: ExploreModel!
    
    var prefetchedImagesForCells = [Int: UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        model = ExploreModel.sharedInstance
        model.delegate = self
        model.searchRecipes()
        loadingMore = true
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
    
    deinit {
        collectionView.emptyDataSetDelegate = nil
        collectionView.emptyDataSetSource = nil
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
        if !collectionView.visibleCells.isEmpty{
            collectionView.scrollToItem(at: IndexPath(row:0, section: 0), at: .top, animated: true)
        }
    }
    
    func search(offset: Int = 0, more: Bool = false){
        let foodType =   foodTypeSegmentControl.titleForSegment(at: foodTypeSegmentControl.selectedSegmentIndex)!.lowercased()
        let foodTypeEnum = FoodType(rawValue: foodType) ?? .all
        let query = searchBar.text ?? ""
        loadingMore = true
        model.searchRecipes(query: query, type: foodTypeEnum, offset:offset, more: more)
    }
}

//MARK: - Collection view delegare/data source
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
            var prefetched = false
            cell.imageView.image = nil
            if let prefetchedImage = prefetchedImagesForCells[indexPath.row]{
                cell.imageView.image = prefetchedImage
                prefetched = true
                prefetchedImagesForCells[indexPath.row] = nil
            }
            cell.configureCell(for: recipes[indexPath.row],prefetched: prefetched)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.foodTypeScrollView.isHidden = (self.navigationController?.navigationBar.isHidden)! ||  self.navigationItem.titleView != self.searchBar
        
        self.lastOffset = scrollView.contentOffset.y
        
        
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - self.lastOffset
        
        if deltaOffset <= 0 {
            if !loadingMore, !noMoreResults{
                search(offset: recipes.count, more: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "statusFooter", for: indexPath)
        if let footerView = footerView as? LoadingFooterCollectionReusableView{
            footerView.configurate(loading: !noMoreResults)
        }
        print(kind)
        print(indexPath)
        return footerView
    }
}

//MARK: -search bar
extension ExploreViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = searchButton
        foodTypeScrollView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       search()
        if !collectionView.visibleCells.isEmpty{
            collectionView.scrollToItem(at: IndexPath(row:0, section: 0), at: .top, animated: true)
        }
        searchBar.resignFirstResponder()
    }
}

//MARK: -ExploreModelDelegate
extension ExploreViewController: ExploreModelDelegate{
    func modelDidLoadNewData() {
        recipes = model.recipes
        loadingMore = false
        noMoreResults = false
       collectionView.reloadData()
    }
    
    func modelCantLoadMore(){
        loadingMore = false
        noMoreResults = true
        if let footer = self.collectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionFooter",
                                                              at: IndexPath(row: 0, section: 0)) as? LoadingFooterCollectionReusableView{
            footer.configurate(loading: !noMoreResults)
        }
        
        
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

//MARK: -prefetching images
extension ExploreViewController: UICollectionViewDataSourcePrefetching{
    @available(iOS 10.0, *)
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for index in indexPaths{
            Alamofire.request(recipes[index.row].imageURL, method: HTTPMethod.get).response(completionHandler: {response in
                self.prefetchedImagesForCells[index.row] = UIImage(data: response.data!, scale: 1)
            })
        }
    }
}


//MARK: -empty data set
extension ExploreViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSForegroundColorAttributeName: self.view.tintColor as Any]
        return NSAttributedString(string: "Nothing to Show", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSForegroundColorAttributeName: self.view.tintColor as Any]
        return NSAttributedString(string: "Try to look for something else or check your internet connection", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "food")
    }
}




