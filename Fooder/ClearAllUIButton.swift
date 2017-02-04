//
//  ClearAllUIButton.swift
//  Fooder
//
//  Created by Vladimir on 03.02.17.
//  Copyright © 2017 Vladimir Ageev. All rights reserved.
//

import UIKit

@IBDesignable
class ClearAllUIButton: UIButton {
    

    enum States: Int{
        case initial
        case preparedForAction
    }
    
    var clearState = States.initial{
        didSet{
            setLable(for: clearState)
        }
    }

    func setLable(for state: States){
        switch state {
        case .initial:
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear, .allowAnimatedContent], animations: {
                self.backgroundColor = UIColor.white
                self.setTitle("" , for: .normal)
                self.setImage(UIImage(named: "Cancel"), for: .normal)
                self.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,0)
            }, completion: nil)
        case .preparedForAction:
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear, .allowAnimatedContent], animations: {
                self.setTitle("Clear", for: .normal)
                self.backgroundColor = self.tintColor
                self.setImage(nil, for: .normal)
                self.cornerRadius = self.frame.height / 2
                self.contentEdgeInsets = UIEdgeInsetsMake(5,8,5,8)
            }, completion: nil)
        }
    }
    
    func switchState(){
        switch clearState {
        case .initial:
            self.clearState = .preparedForAction
        case .preparedForAction:
            self.clearState = .initial
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

}
