//
//  GoalsViewController.swift
//  NewLife
//
//  Created by Shadi on 09/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class GoalsViewController: HandleErrorViewController {
    
    enum SourceView {
        case welcome
        case membership
    }
    
    @IBOutlet weak var titleView: GoalsTitleView! {
        didSet {
            titleView.delegate = self
        }
    }
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var goalsView: GoalsSelectedView!
    
    let loadAnimationDuration: TimeInterval = 0.5
    var didAppeared = false
    let goals = GoalsVM(service: MembershipServiceFactory.service())
    var goalsAnimated: Bool = false
    
    var sourceView: SourceView = .welcome
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        fetchAndReload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if didAppeared == false {
            animateWhenDidLoad()
            goalsView.layoutView(containerHeight: containerView.frame.height)
        
            if goals.goals.count > 0 {
                goalsView.animateWhenLoad()
                goalsAnimated = true
            }
            didAppeared = true
        }
    }
    
    private func initialize() {
        
        view.backgroundColor = UIColor.clear
        
        continueButton.layer.cornerRadius = 18
        continueButton.layer.masksToBounds = true
        continueButton.tintColor = UIColor.white
        continueButton.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        continueButton.titleLabel?.font = UIFont.kacstPen(ofSize: 24)
        continueButton.setTitleWithoutAnimation(title: "goalsContinueButtonTitle".localized)
        
        blurView.effect = nil
        
        titleView.transform = .init(translationX: 0, y: 70)
        titleView.alpha = 0.0
    }
    
    private func fetchAndReload() {
        
        goals.fetchGoals { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                
            } else {
                self.reloadData()
                if self.didAppeared == true && self.goalsAnimated == false {
                    self.goalsView.animateWhenLoad()
                    self.goalsAnimated = true
                }
            }
        }
    }
    
    private func submitSelectedGoals() {
        LoadingHud.shared.show(animated: true)
        goals.sendSelectedGoalsFromService { [weak self] (error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else {
                self?.submitSuccessed()
            }
        }
    }
    
    private func reloadData() {
        goalsView.goals = goals.goals
    }
    
    private func submitSuccessed() {
        
        if UserDefaults.isAnonymousUser() {
            // Save Anonymous Token
            AnonymousUserVM().submit()
        }
        openMainViewController()
    }
    
    private func animateWhenDidLoad() {
        
        UIView.animate(withDuration: loadAnimationDuration) { [weak self] in
            self?.blurView.effect = UIBlurEffect(style: .dark)
        }
        
        UIView.animate(WithDuration: loadAnimationDuration, timing: .easeOutQuart, animations: { [weak self] in
            self?.titleView.transform = .identity
            self?.titleView.alpha = 1.0
            self?.continueButton.alpha = 1.0
            }, completion: nil)
    }
    
    private func openMainViewController() {
        SystemSoundID.play(sound: .LaunchToHome)
        (UIApplication.shared.delegate as? AppDelegate)?.pushWindowToRootViewController(viewController: MainTabBarController.instantiate(), animated: true)
    }
    
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        submitSelectedGoals()
    }
    
}

extension GoalsViewController: GoalsTitleViewDelegate {
    func selectAllTapped(_ sender: GoalsTitleView) {
        goals.updateSelectAll(selected: sender.isSelectedAll)
        reloadData()
    }
}


extension GoalsViewController {
    
    class func instantiate(sourceView: SourceView) -> GoalsViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: GoalsViewController.identifier) as! GoalsViewController
        viewController.sourceView = sourceView
        return viewController
    }
}

