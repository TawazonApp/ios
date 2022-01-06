//
//  NavigationController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        isNavigationBarHidden = true
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1 ? true : false
    }
    /*
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if animated {
            let transition = CATransition()
            transition.duration = 1.25
            transition.timingFunction = CAMediaTimingFunction.easeOutQuart
            transition.type = .moveIn
            transition.subtype = CATransitionSubtype.fromLeft
            self.view.layer.add(transition, forKey: nil)
        }
        super.pushViewController(viewController, animated: false)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if animated {
            let transition = CATransition()
            transition.duration = 1.25
            transition.timingFunction = CAMediaTimingFunction.easeOutQuart
            transition.type = .push
            transition.subtype = CATransitionSubtype.fromRight
            self.view.layer.add(transition, forKey: nil)
        }
       return super.popToViewController(viewController, animated: false)
        
    }
    */
    
}

extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return PushAnimatedTransitioning()
        }
        
        if operation == .pop {
            return PopAnimatedTransitioning()
        }
        return nil
    }
}
