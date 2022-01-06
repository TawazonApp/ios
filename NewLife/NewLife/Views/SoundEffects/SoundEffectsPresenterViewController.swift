//
//  SoundEffectsPresenterViewController.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class SoundEffectsPresenterViewController: HandleErrorViewController {
    
    @IBOutlet weak var soundsButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        if let soundsButton = soundsButton {
            soundsButton.tintColor = UIColor.white
            soundsButton.layer.cornerRadius = soundsButton.frame.height/2
            soundsButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            soundsButton.setImage(UIImage(named: "SoundEffects"), for: .normal)
        }
        
    }
    
    private func openSoundEffectsViewController() {
        SystemSoundID.play(sound: .Sound1)
        let viewController = SoundEffectsViewController.instantiate()
        viewController.delegate = self
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    private func updateTabBarAlpha(alpha: CGFloat) {
        (self.tabBarController as? MainTabBarController)?.mainTabBar.alpha = alpha
    }
    
    @IBAction func soundsButtonTapped(_ sender: SoundEffectsButton) {
        openSoundEffectsViewController()
    }
    
}

extension SoundEffectsPresenterViewController: SoundEffectsViewControllerDelegate {
    
    func beginLoadAnimation() {
        guard let soundsButton = soundsButton else { return }
        let duration = SoundEffectsViewController.duration * 3/4
        UIView.animate(WithDuration: duration, timing: .easeOutQuart, animations: {  [weak self] in
            self?.updateTabBarAlpha(alpha: 0.0)
            soundsButton.alpha = 0.0

            
        }) { (finish) in
            
        }
    }
    
    func beginDismissAnimation() {
        guard soundsButton != nil else { return }
        
        UIView.animate(WithDuration: SoundEffectsViewController.duration, timing: .easeOutQuart, animations: { [weak self] in
            self?.updateTabBarAlpha(alpha: 1.0)
            self?.soundsButton?.alpha = 1.0
        }) { [weak self]  (finish) in
            self?.updateTabBarAlpha(alpha: 1.0)
            self?.soundsButton?.alpha = 1.0
        }
    }
}
