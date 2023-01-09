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
    @IBOutlet weak var searchButton: UIButton?
    
    let searchController = UISearchController()
    
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
        
        if let searchButton = searchButton {
            searchButton.tintColor = UIColor.white
            searchButton.layer.cornerRadius = searchButton.frame.height/2
            searchButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            searchButton.setImage(UIImage(named: "Cancel"), for: .normal)
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
    
    @IBAction func searchButtonTapped(_ sender: SoundEffectsButton) {
//        openSearchViewController()
        print("BACK")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func openSearchViewController(){
        let searchViewController = SearchViewController.instantiate()
        searchViewController.modalPresentationStyle = .custom
        self.present(searchViewController, animated: true, completion: nil)
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
