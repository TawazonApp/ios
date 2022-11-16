//
//  GoalsListViewController.swift
//  Tawazon
//
//  Created by mac on 17/10/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class GoalsListViewController: HandleErrorViewController {

    
    @IBOutlet weak var topBannerBackground: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goalsTable: UITableView!
    @IBOutlet weak var continueButton: GradientButton!
    
    let goals = GoalsVM(service: MembershipServiceFactory.service())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        fetchAndReload()
    }
    

    private func initialize(){
        self.view.backgroundColor = .darkBlueGreyThree
        
        topBannerBackground.image = UIImage(named: "OnboardingBackground")
        topBannerBackground.contentMode = .scaleAspectFill
        
        logoImageView.image = UIImage(named: "LogoWithName")
        
        sloganLabel.text = "launchSlogan".localized
        sloganLabel.font = .lbc(ofSize: 18)
        sloganLabel.textColor = .white
        
        descriptionLabel.text = "goalsViewTitle".localized
        descriptionLabel.font = .munaBoldFont(ofSize: 22)
        descriptionLabel.textColor = .white
        
        goalsTable.backgroundColor = .clear
        goalsTable.separatorStyle = .none
        
        continueButton.layer.cornerRadius = 18
        continueButton.layer.masksToBounds = true
        continueButton.tintColor = UIColor.white
        continueButton.applyGradientColor(colors: [UIColor.gray.cgColor, UIColor.white.withAlphaComponent(0.5).cgColor], startPoint: .right, endPoint: .left)
        continueButton.titleLabel?.font = UIFont.kacstPen(ofSize: 24)
        continueButton.setTitleWithoutAnimation(title: "goalsContinueButtonTitle".localized)
        continueButton.isEnabled = false
    }

    private func fetchAndReload() {
        
        goals.fetchGoals { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                
            } else {
                self.reloadData()
            }
        }
    }
    
    private func reloadData() {
        goalsTable.reloadData()
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        submitSelectedGoals()
    }
    
    private func submitSelectedGoals() {
        LoadingHud.shared.show(animated: true)
        goals.sendSelectedGoalsFromService { [weak self] (error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else {
                self?.setUserSettings()
                self?.submitSuccessed()
            }
        }
    }
    
    private func submitSuccessed() {
        if UserDefaults.isAnonymousUser() {
            // Save Anonymous Token
            AnonymousUserVM().submit()
        }
        openPreparationSessionViewController()
    }
    
    private func setUserSettings(){
        var settings = UserSettings(defaultAudioSource: "ar.ps", alarms: nil)
        if Language.language == .english{
            settings = UserSettings(defaultAudioSource: "en.us", alarms: nil)
        }
        UserInfoManager.shared.setUserSessionSettings(settings: settings, service: MembershipServiceFactory.service()){ (error) in
            if let error = error{
                self.showErrorMessage( message: error.localizedDescription )
            }
        }
    }
    
    private func openMainViewController() {
        SystemSoundID.play(sound: .LaunchToHome)
        (UIApplication.shared.delegate as? AppDelegate)?.pushWindowToRootViewController(viewController: MainTabBarController.instantiate(), animated: true)
    }
    
    private func openPreparationSessionViewController(){
        let viewController = PreparationSessionViewController.instantiate()
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
}
extension GoalsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.goals.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalTableViewCell.identifier) as! GoalTableViewCell
        cell.goal = goals.goals[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension GoalsListViewController: GoalTableViewCellDelegate{
    func selectGoal(goal: GoalVM) {
        let selectedGoals = goals.goals.filter({$0.isSelected}).map({ return $0.id }) as? [String]
        if (selectedGoals?.count ?? 0 > 0){
            continueButton.isEnabled = true
            continueButton.applyGradientColor(colors: [UIColor.black.cgColor, UIColor.black.cgColor], startPoint: .right, endPoint: .left)
        }else{
            continueButton.isEnabled = false
            continueButton.applyGradientColor(colors: [UIColor.gray.cgColor, UIColor.white.withAlphaComponent(0.5).cgColor], startPoint: .right, endPoint: .left)
        }
    }
}

extension GoalsListViewController{
    class func instantiate() -> GoalsListViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: GoalsListViewController.identifier) as! GoalsListViewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
