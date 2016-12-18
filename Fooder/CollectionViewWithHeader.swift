//
//  CollectionViewWithHeader.swift
//  Fooder
//
//  Created by Vladimir on 18.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class CollectionViewWithHeader: UICollectionView {

    var searchIsActive = false
    var fixedHeaderView = UIView()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if searchIsActive{
            let location = CGPoint(x: 0, y: contentOffset.y)
            let size = fixedHeaderView.frame.size
            
            fixedHeaderView.frame = CGRect(origin: location, size: size)
        }
    }

}
