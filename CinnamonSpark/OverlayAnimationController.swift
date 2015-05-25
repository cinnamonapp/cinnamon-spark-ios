//
//  OverlayAnimationController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 22/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit


class OverlayTransitionManager : NSObject, UIViewControllerTransitioningDelegate{
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimationController(presenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimationController(presenting: false)
    }
}

class OverlayAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    var presenting : Bool = false
    
    convenience init(presenting: Bool!){
        self.init()
        self.presenting = presenting
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Grab the from and to view controllers from the context
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        if (self.presenting) {
            
            toViewController?.view.frame.origin.y = UIScreen.mainScreen().bounds.height
            
            transitionContext.containerView().addSubview(toViewController!.view)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                fromViewController?.view.tintAdjustmentMode = UIViewTintAdjustmentMode.Dimmed
                toViewController?.view.frame.origin.y = 30
                
                }, completion: {(finished: Bool) -> Void in
                    transitionContext.completeTransition(finished)
            })
            
        }
        else {
            
            toViewController!.view.userInteractionEnabled = true
            
            transitionContext.containerView().addSubview(fromViewController!.view)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                toViewController?.view.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
                
                fromViewController?.view.frame.origin.y = UIScreen.mainScreen().bounds.height
                
                }, completion: {(finished: Bool) -> Void in
                    transitionContext.completeTransition(finished)
            })
        }
    }
}
