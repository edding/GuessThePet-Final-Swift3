//
//  FlipDismissAnimationController.swift
//  GuessThePet
//
//  Created by Edward Ding on 9/19/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var destinationFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        let finalFrame = destinationFrame
        
        let snapshot = UIImageView(image: UIImage.renderImage(from: fromVC.view))
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        
        toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                    snapshot.frame = finalFrame
                })
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                })
            },
            completion:{ _ in
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
