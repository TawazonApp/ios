//
//  MainTabBarController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import SwiftMessages

class MainTabBarController: UITabBarController {
    
    @IBOutlet weak var mainTabBar: MainTabBarView!
    var playerBar: MainPlayerBarView?
    var swiftMessages: SwiftMessages?

    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    private lazy var viewModel = MainTabBarControllerVM(service: SessionServiceFactory.service())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.isHidden = true
        initializeTabBar()
        initializeNotification()
        mainTabBar.delegate = self
        mainTabBar.animateItems()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
           self.performNotificationActionIfNeeded()
        }
        playMainBackgroundAudio()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initializeTabBar() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(blurView)
        
        mainTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainTabBar)
        
        if #available(iOS 11.0, *) {
            mainTabBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            mainTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        }
        
        mainTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mainTabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        mainTabBar.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        blurView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        blurView.topAnchor.constraint(equalTo: mainTabBar.topAnchor, constant: -10).isActive = true
        blurView.alpha = 0.9
    }
    
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSessionPlayerBar(_:)), name: NSNotification.Name.showSessionPlayerBar
            , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideSessionPlayerBar(_:)), name: NSNotification.Name.hideSessionPlayerBar
            , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(performNotificationActionIfNeeded), name: NSNotification.Name.didReceiveRemoteNotification
            , object: nil)
    }
    
    private func playMainBackgroundAudio() {
        BackgroundAudioManager.shared.mainBackgroundAudio.play()
    }
    
  @objc private func performNotificationActionIfNeeded() {
    //TODO: hide all presented view controller
        guard let notificationData = appDelegate?.notificationData else {
            return
        }
    
        if notificationData.type == .playSession {
            if let sessionModel = notificationData.data as? SessionModel {
                //if !sessionModel.isLock {
                    if !AudioPlayerManager.shared.isPlaying() {
                        openSessionPlayerViewController(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel))
                    }
                   
               // }
            } else if let sessionId = notificationData.data as? String {
                handlePlaySessionFromLink(sessionId: sessionId)
            }
        } else if notificationData.type == .category {
            if let category = notificationData.data as? CategoryModel, let categoryId =  category.id {
                openCategory(categoryId: categoryId)
            }
        }
        appDelegate?.notificationData = nil
    }
    
    func openCategory(categoryId: String) {
        guard let id = MainTabBarView.tabBarItemsIds(rawValue: categoryId) else {
            return
        }
        mainTabBar.openTap(id: id)
    }
    
    @objc func showSessionPlayerBar(_ notification: Notification) {
        showSessionPlayerBar()
    }
    
    @objc func hideSessionPlayerBar(_ notification: Notification) {
        hideSessionPlayerBar()
        if let session = notification.object as? SessionVM {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
    
    func showSessionPlayerBar() {
        guard AudioPlayerManager.shared.isPlaying() else {
            return
        }
        addPlayerBarIfNeeded()
        playerBar?.playSession()
    }
    
    func hideSessionPlayerBar() {
        playerBar?.removeFromSuperview()
        playerBar = nil
    }
    
    private func addPlayerBarIfNeeded() {
        guard playerBar == nil else {
            return
        }
        playerBar = MainPlayerBarView.fromNib()
        playerBar?.delegate = self
        playerBar!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerBar!)
        
        playerBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        playerBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        playerBar!.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        playerBar!.bottomAnchor.constraint(equalTo: self.mainTabBar.topAnchor, constant: -12).isActive = true
        
    }
    
    private func handlePlaySessionFromLink(sessionId: String) {
        viewModel.fetchSessionInfo(sessionId: sessionId) { [weak self] (sessionModel, error) in
            if let error = error {
                self?.showErrorMessage(title: "cannotPlaySessionErrorTitle".localized, message: error.message ?? "")
                return
            }
            guard let sessionModel = sessionModel else {
                return
            }
            //if !sessionModel.isLock {
                if !AudioPlayerManager.shared.isPlaying() {
                    self?.openSessionPlayerViewController(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel))
                }
          //  }
    
        }
    }
    
    private func openSessionPlayerViewController(session: SessionVM) {
        let viewcontroller = SessionPlayerViewController.instantiate(session: session, delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    
    func showErrorMessage(title: String? = nil, message: String) {
        
        if swiftMessages != nil {
            swiftMessages?.hide()
            swiftMessages = nil
        }
        
        swiftMessages = SwiftMessages()
        
        guard let swiftMessages = swiftMessages else { return }
        
        let errorView = MessageView.viewFromNib(layout: .messageView)
        errorView.configureTheme(backgroundColor: UIColor.orangePink, foregroundColor: UIColor.white, buttonBackgroundColor: UIColor.white.withAlphaComponent(0.3), iconImage: nil, iconText: nil, titleFont: UIFont.kacstPen(ofSize: 18), bodyFont: UIFont.kacstPen(ofSize: 16), buttonFont: UIFont.kacstPen(ofSize: 16))
        
        errorView.button?.isHidden = false
        
        errorView.configureContent(title: title, body: message, iconImage: nil , iconText: nil, buttonImage: nil, buttonTitle: "dimissErrorMessage".localized) { (button) in
            swiftMessages.hide()
        }
        
        var config = swiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .view(self.view)
        config.duration = .seconds(seconds: 6)
        config.dimMode = .none
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
        
        swiftMessages.show(config: config, view: errorView)
    }
    
    private func openPremiumViewController() {
        guard self.presentedViewController == nil else {
            return
        }
        let viewcontroller = PremiumViewController.instantiate(nextView: .dimiss)
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
}


extension MainTabBarController: MainPlayerBarViewDelegate {
    
    func playerTapped() {
        guard let session = SessionPlayerMananger.shared.session else { return }
        openSessionPlayerViewController(session: session)
    }
    
    func openPremiumView(_ sender: MainPlayerBarView) {
        openPremiumViewController()
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        /*
        if fromVC is HomeViewController {
            return TabBarPresnetAnimatedTransitioning()
        }
        
        if toVC is HomeViewController {
            return TabBarDismissAnimatedTransitioning()
        }
*/
        return TabBarCrossDissolveAnimatedTransitioning()
    }
}

extension MainTabBarController: MainTabBarViewDelegate {
    
    func tabItemTapped(index: Int) {
        Rate.rateApp()
        selectedIndex = index
    }
}

extension MainTabBarController {
    
    class func instantiate() -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MainTabBarController.identifier) as! MainTabBarController
        return viewController
    }
    
}

extension MainTabBarController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}
