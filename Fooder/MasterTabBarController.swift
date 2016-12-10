//
//  MasterTabBarController.swift
//  Fooder
//
//  Created by Vladimir on 10.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class MasterTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1  //Explore tab initially selected
    }
}
