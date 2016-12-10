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
    @IBOutlet weak var ingridientsTextField: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var instructionsHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var ingridientsHeightConstrain: NSLayoutConstraint!
    
    var recipe: Recipe!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgeView.image = image
        instructionsTextField.text = recipe.instructions
        // Do any additional setup after loading the view.
        print(recipe.instructions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("Set constraints")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Did layout subviews!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ingridientsHeightConstrain.constant = ingridientsTextField.intrinsicContentSize.height
        instructionsHeightConstrain.constant = instructionsTextField.intrinsicContentSize.height
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
