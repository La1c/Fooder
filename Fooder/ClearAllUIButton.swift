//
//  ClearAllUIButton.swift
//  Fooder
//
//  Created by Vladimir on 03.02.17.
//  Copyright © 2017 Vladimir Ageev. All rights reserved.
//

import UIKit

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
            self.setTitle("Tap to Clear" , for: .normal)
        case .preparedForAction:
            self.setTitle("Clear All", for: .normal)
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

}
