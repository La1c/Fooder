//
//  LoadingFooterCollectionReusableView.swift
//  Fooder
//
//  Created by Vladimir on 24.01.17.
//  Copyright © 2017 Vladimir Ageev. All rights reserved.
//

import UIKit

class LoadingFooterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var noMoreResultsView: UIView!
    @IBOutlet weak var centerDot: UIImageView!
    @IBOutlet weak var rightDot: UIImageView!
    @IBOutlet weak var leftDot: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    var currentView: UIView?
    func configurate(loading status: Bool){
        if status{
            startAnimation()
            currentView = loadingView
        }else{
            stopAnimation()
            currentView = noMoreResultsView
        }
    }
}

extension LoadingFooterCollectionReusableView{
    func startAnimation(){
        
        if let _ = currentView?.isEqual(noMoreResultsView){
            UIView.transition(from: noMoreResultsView,
                              to: loadingView,
                              duration: 0.0,
                              options: [.transitionCrossDissolve, .showHideTransitionViews],
                              completion: nil)
        }
       
        
        
        leftDot.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        centerDot.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        rightDot.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.leftDot.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.centerDot.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.rightDot.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
    
    func stopAnimation(){
        
        UIView.transition(from: loadingView,
                          to: noMoreResultsView,
                          duration: 0.2,
                          options: [.transitionCrossDissolve, .showHideTransitionViews],
                          completion: nil)
    }
}
