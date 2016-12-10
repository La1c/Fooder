//
//  DetailsViewController.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imgeView: UIImageView!
    
    @IBOutlet weak var instructionsTextField: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var instructionsHeightConstrain: NSLayoutConstraint!
    
    var recipe: Recipe!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgeView.image = image
        instructionsTextField.text = recipe.instructions
        // Do any additional setup after loading the view.
        print(recipe.instructions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        instructionsHeightConstrain.constant = instructionsTextField.intrinsicContentSize.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EbededTableViewSegue"{
            if let tableVC = segue.destination as? IngridientsTableViewController{
                tableVC.ingridients = recipe.ingridients
            }
        }
        
    }
    
    
    
    
}
