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

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topBannerBackground: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goalsTable: UITableView!
    @IBOutlet weak var continueButtonView: UIView!
    @IBOutlet      var continueButton: GradientButton!
    @IBOutlet      var skipButton: UIButton!
//    @IBOutlet      var goalsTableToViewConstraint: NSLayoutConstraint!
    @IBOutlet      var goalsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    let goals = GoalsVM(service: MembershipServiceFactory.service())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        fetchAndReload()
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        view.layoutIfNeeded()
//        view.subviews.forEach(){
//            subView in
//            subView.layoutIfNeeded()
//        }
//        scrollView.layoutIfNeeded()
//    }

    private func initialize(){
        self.view.backgroundColor = .midnightBlueTwo
        
        skipButton.layer.cornerRadius = skipButton.frame.height/2
        skipButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        skipButton.tintColor = UIColor.white
        skipButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        
        contentView.backgroundColor = .clear
        
        topBannerBackground.image = UIImage(named: "GoalsHeader")
        topBannerBackground.contentMode = .scaleAspectFill
        topBannerBackground.backgroundColor = .clear
        topBannerBackground.clipsToBounds = false
        
        subtitleLabel.text = "goalsViewSubTitle".localized
        subtitleLabel.font = .kacstPen(ofSize: 16)
        subtitleLabel.textColor = .white
        
        descriptionLabel.text = "goalsViewTitle".localized
        descriptionLabel.font = .lbc(ofSize: 24)
        descriptionLabel.textColor = .white
        
        goalsTable.backgroundColor = .clear
        goalsTable.separatorStyle = .none
        
        continueButtonView.backgroundColor = .paua
        continueButtonView.isHidden = true
        
        continueButton.layer.cornerRadius = 20
        continueButton.layer.masksToBounds = true
        continueButton.tintColor = UIColor.white
        continueButton.applyGradientColor(colors: [UIColor.gray.cgColor, UIColor.white.withAlphaComponent(0.5).cgColor], startPoint: .right, endPoint: .left)
        continueButton.setTitle("goalsContinueButtonTitle".localized, for: .normal)
        continueButton.titleLabel?.font = UIFont.munaBoldFont(ofSize: 22)
//        continueButton.isHidden = true
//        self.removeContinueButtonFromView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
        goalsTableHeightConstraint.constant = goalsTableHeightConstraint.constant < CGFloat(self.goals.goals.count * 68) ? CGFloat(self.goals.goals.count * 68) : goalsTableHeightConstraint.constant
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        submitSelectedGoals()
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        setUserSettings()
        submitSuccessed()
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
            continueButtonView.isHidden = false
            continueButton.applyGradientColor(colors: [UIColor.black.cgColor, UIColor.black.cgColor], startPoint: .right, endPoint: .left)
        }else{
            continueButtonView.isHidden = true
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
