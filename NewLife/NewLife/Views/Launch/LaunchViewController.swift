//
//  LaunchViewController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class LaunchViewController: BaseViewController {
    
    @IBOutlet weak var launchView: LaunchView!
    @IBOutlet weak var logoImageView: LaunchLogoImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        preFetchCachingData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
            
            if UserDefaults.userToken() != nil {
                self?.openMainViewController()
            } else {
                self?.openWelcomeViewController()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLaunchView()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func initialize() {
        
    }
    
    private func animateLaunchView() {
        logoImageView.animate()
        launchView.animate()
    }
    
    private func openMainViewController() {
        SystemSoundID.play(sound: .LaunchToHome)
        navigationController?.setViewControllers([MainTabBarController.instantiate()], animated: true)
    }
    
    private func openWelcomeViewController() {
        SystemSoundID.play(sound: .Sound3)
        navigationController?.setViewControllers([WelecomeViewController.instantiate()], animated: true)
    }
    
    private func preFetchCachingData() {
        ProfileVM(service: MembershipServiceFactory.service()).userInfo { (error) in }
    }
}

extension LaunchViewController {
    
    class func instantiate() -> LaunchViewController {
        let storyboard = UIStoryboard(name: "Launch", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: LaunchViewController.identifier) as! LaunchViewController
        return viewController
    }
    
}
