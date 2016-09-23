//
//  FlipPresentAnimationController.swift
//  GuessThePet
//
//  Created by Edward Ding on 9/17/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame = CGRect.zero
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        
        // let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)!
        // Ed: snapshot在iOS 10（swift3）下无法正常获取
        // 这里用渲染获得的图片代替快照
        let snapshot = UIImageView(image: UIImage.renderImage(from: toVC.view))
        snapshot.frame = initialFrame
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot.layer.transform = AnimationHelper.yRotation(0.0)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    snapshot.frame = finalFrame
                })
            },
            completion:  { _ in
                toVC.view.isHidden = false
                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
