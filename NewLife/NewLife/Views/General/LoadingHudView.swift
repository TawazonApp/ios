//
//  LoadingHudView.swift
//  NewLife
//
//  Created by Shadi on 25/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import Lottie

class LoadingHud: NSObject {

    static let shared = LoadingHud()
    
    private var loadingView: LoadingHudView?
    private override init() {}
    
    func show(animated: Bool) {
        if loadingView == nil {
            loadingView = LoadingHudView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            loadingView!.show(animated: animated)
        }
    }
    
    func hide(animated: Bool,  completion: (() -> Void)? = nil) {
        
        if loadingView == nil {
            completion?()
            return
        }
        
        loadingView?.hide(animated: animated, completion: { [weak self] in
            self?.loadingView = nil
            completion?()
        })
    }
    
}

class LoadingHudView: UIView {
    
    let animationDuration: TimeInterval = 0.25
    
    var lottieView: AnimationView?
    var containerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clear
        addContainerView()
    }
    
    private func addContainerView() {
        containerView = UIView()
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        containerView?.layer.applySketchShadow(color: UIColor.white, alpha: 0.4, x: 0, y: 0, blur: 24, spread: 0)

        containerView?.layer.cornerRadius = 16
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView!)
        
        containerView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
        containerView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        containerView?.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        containerView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    private func addLottieView() {
        
        if lottieView == nil {
            lottieView = AnimationView(name: "LoadingIndicator")
            lottieView?.translatesAutoresizingMaskIntoConstraints = false
            
            lottieView?.loopMode = .loop
            self.addSubview(lottieView!)
            
            lottieView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
            lottieView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            lottieView?.centerXAnchor.constraint(equalTo: containerView!.centerXAnchor, constant: 0).isActive = true
            lottieView?.centerYAnchor.constraint(equalTo: containerView!.centerYAnchor, constant: 0).isActive = true
        }
        
    }
    
    private func removeLottieView() {
        lottieView?.stop()
        lottieView?.removeFromSuperview()
        lottieView = nil
    }
    func show(animated: Bool) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        addLottieView()
        lottieView?.play()
        self.restorationIdentifier = restorationIdentifier
        
        keyWindow.addSubview(self)
        
        // Add constraints for `containerView`.
        ({
            let leadingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: keyWindow, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: keyWindow, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            
            keyWindow.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
            }())
        
        if animated {
            fadeInAnimation { (finish) in
                
            }
        }
    }
    
    func hide(animated: Bool, completion: @escaping (() -> Void)) {
        if animated {
            fadeOutAnimation { [weak self] (finish) in
                self?.removeFromSuperview()
                completion()
            }
        } else {
            removeFromSuperview()
            completion()
        }
    }
    
   private func fadeInAnimation(completion: @escaping ((Bool) -> Void)) {
        self.alpha = 0.0
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            self?.alpha = 1.0
        }) { (finish) in
            completion(true)
        }
    }
    
    private func fadeOutAnimation(completion: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: animationDuration, animations: {  [weak self] in
            self?.alpha = 0.0
        }) { (finish) in
            completion(true)
        }
    }
    

}
