//
//  FoodTypeSegmentedControl.swift
//  Fooder
//
//  Created by Vladimir on 26.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

@IBDesignable
class FoodTypeSegmentedControl: UISegmentedControl {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

}
