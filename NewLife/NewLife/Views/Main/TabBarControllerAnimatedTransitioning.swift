//
//  TabBarControllerAnimatedTransitioning.swift
//  NewLife
//
//  Created by Shadi on 26/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit

final class TabBarPresnetAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /*
     Tells your animator object to perform the transition animations.
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        destination.transform = .init(translationX: 0, y: destination.frame.height)
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(WithDuration:  transitionDuration(using: transitionContext), timing: .easeOutQuart, animations: {
            destination.transform = .identity
        }) { (finish) in
            transitionContext.completeTransition(finish)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
}

final class TabBarDismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /*
     Tells your animator object to perform the transition animations.
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        guard let source = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        
        transitionContext.containerView.insertSubview(destination, belowSubview: source)
        UIView.animate(WithDuration:  transitionDuration(using: transitionContext), timing: .easeInQuart, animations: {
            source.transform = .init(translationX: 0, y: source.frame.height)
        }) { (finish) in
            source.transform = .identity
            transitionContext.completeTransition(finish)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
}

final class TabBarCrossDissolveAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    /*
     Tells your animator object to perform the transition animations.
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        destination.alpha = 0.0
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(WithDuration:  transitionDuration(using: transitionContext), timing: .easeOutQuart, animations: {
            destination.alpha = 1.0
        }) { (finish) in
            transitionContext.completeTransition(finish)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
}

class PresentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        containerView.addSubview(toViewController.view)
        
        toViewController.view.transform = .init(translationX: 0, y: toViewController.view.frame.height)
        
        UIView.animate(WithDuration:  transitionDuration(using: transitionContext), timing: .easeOutQuart, animations: {
            toViewController.view.transform = .identity
        }) { (finish) in
            transitionContext.completeTransition(finish)
        }
        
    }
}


class DismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                return
        }
        
        UIView.animate(WithDuration:  transitionDuration(using: transitionContext), timing: .easeOutQuart, animations: {
            fromViewController.view.transform = .init(translationX: 0, y: fromViewController.view.frame.height)
        }) { (finish) in
            transitionContext.completeTransition(finish)
            fromViewController.view.removeFromSuperview()
            
        }
    }
    
}

class PushAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        containerView.addSubview(toViewController.view)
        let isRTL = UIApplication.isRTL()
        let toViewControllerTranslationX = isRTL ? -toViewController.view.frame.width : toViewController.view.frame.width
        
        let fromViewControllerTranslationX = isRTL ? toViewController.view.frame.width : -toViewController.view.frame.width
        
        toViewController.view.transform = .init(translationX: toViewControllerTranslationX, y: 0)
        UIView.animate(WithDuration:  transitionDuration(using: transitionContext), timing: .easeOutQuart, animations: {
            toViewController.view.transform = .identity
            fromViewController.view.transform = .init(translationX: fromViewControllerTranslationX, y: 0)
        }) { (finish) in
            transitionContext.completeTransition(finish)
            fromViewController.view.transform = .identity
        }
        
    }
}

class PopAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        let isRTL = UIApplication.isRTL()
        let toViewControllerTranslationX = isRTL ? toViewController.view.frame.width : -toViewController.view.frame.width
        
        let fromViewControllerTranslationX = isRTL ? -toViewController.view.frame.width : toViewController.view.frame.width
        
        toViewController.view.transform = .init(translationX: toViewControllerTranslationX, y: 0)
        
        UIView.animate(WithDuration:  transitionDuration(using: transitionContext), timing: .easeOutQuart, animations: {
            fromViewController.view.transform = .init(translationX: fromViewControllerTranslationX, y: 0)
            toViewController.view.transform = .identity
        }) { (finish) in
            transitionContext.completeTransition(finish)
            fromViewController.view.removeFromSuperview()
        }
    }
    
}
