//
//  SettingsViewController.swift
//  Tawazon
//
//  Created by mac on 18/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: BaseViewController {

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var settingsData: SettingsVM! {
        didSet {
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsData = SettingsVM()
        initialize()
//        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.myAccountScreenLoad, payload: nil)
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTableContentInset()
    }
    
    private func setupTableContentInset() {
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 80, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -44)
    }
    
    private func initialize() {
        backgroundImage.image = UIImage(named: "MoreBg")
        backgroundImage.contentMode = .scaleAspectFill
        
        viewTitleLabel.font = .lbc(ofSize: 24)
        viewTitleLabel.textColor = .white
        viewTitleLabel.text = "settingsTitleLabel".localized
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        let backImage = isModal() ?  #imageLiteral(resourceName: "Cancel.pdf") : #imageLiteral(resourceName: "BackArrow.pdf").flipIfNeeded
        cancelButton.setImage(backImage, for: .normal)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = .clear
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    private func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func showLanguageAlert() {
        
        let alert = UIAlertController(title: "", message: "changeLanguageAlertTitle".localized, preferredStyle: .actionSheet, blurStyle: .dark)
         
        let englishAction = UIAlertAction(title: "English".localized, style: .default) { [weak self]  (action) in
            self?.changeLanguage(language: .english)
        }
        if Language.language == .english {
            englishAction.setValue(true, forKey: "checked")
        }
        alert.addAction(englishAction)
        
        let arabicAction = UIAlertAction(title: "العربية".localized, style: .default) { [weak self]  (action) in
            self?.changeLanguage(language: .arabic)
        }
        if Language.language == .arabic {
            arabicAction.setValue(true, forKey: "checked")
        }
        alert.addAction(arabicAction)
        
        alert.addAction(title: "logoutConfirmAlertCancelButton".localized, style: .cancel) { (alert) in
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changeLanguage(language: Language) {
        guard language != Language.language else {
            return
        }
        Language.language = language
        fetchSessionInfo()
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        (UIApplication.shared.delegate as? AppDelegate)?.resetApp()
        self.perform(#selector(showSessionPlayerBar), with: nil, afterDelay: 4)
    }
    
    private func openReminder(){
        let viewController = LandingReminderViewController.instantiate(from: LandingReminderViewController.sourceView.settings)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    private func fetchSessionInfo(){
        guard AudioPlayerManager.shared.isPlaying() else {
            return
        }
        SessionPlayerMananger.shared.session?.service.fetchSessionInfo(sessionId: (SessionPlayerMananger.shared.session?.id)!){ (sessionModel, error) in
            if let sessionModel = sessionModel {
                SessionPlayerMananger.shared.session = SessionVM(service: SessionServiceFactory.service(), session: sessionModel)
            }
        }
    }
    
    @objc private func showSessionPlayerBar() {
        NotificationCenter.default.post(name: NSNotification.Name.showSessionPlayerBar, object: nil)
    }
    
    private func openViewController(cellData: SettingsCellVM) {
        if cellData.type == SettingsCellVM.SettingsCellType.privacyPolicy {
            openPrivacyViewController()
            return
        }

        if cellData.type == SettingsCellVM.SettingsCellType.termsAndConditions {
            openTermsAndConditionsViewController()
            return
        }

        if cellData.type == SettingsCellVM.SettingsCellType.ourStory {
            openOurStoryViewController()
            return
        }
        if cellData.type == SettingsCellVM.SettingsCellType.lanaguge {
            showLanguageAlert()
            return
        }
        if cellData.type == SettingsCellVM.SettingsCellType.reminder {
            openReminder()
            return
        }
        
        if cellData.type == SettingsCellVM.SettingsCellType.support {
            openSupportMailController()
            return
        }
        
    }
    
    
    private func openTermsAndConditionsViewController()  {
        let viewController = PrivacyViewController.instantiate(viewType: .termsAndConditions)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openPrivacyViewController()  {
        let viewController = PrivacyViewController.instantiate(viewType: .privacyPolicy)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openOurStoryViewController()  {
        let viewController = OurStoryViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if let cellData = settingsData.items[indexPath.row] as? NotificationCellVM {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.identifier) as! SettingsSwitchCell
            switchCell.data = cellData
            cell = switchCell
        } else if settingsData.items[indexPath.row].type == SettingsCellVM.SettingsCellType.appVersion  {
            let appVersionCell = tableView.dequeueReusableCell(withIdentifier: SettingsAppVersionCell.identifier) as! SettingsAppVersionCell
            appVersionCell.data = settingsData.items[indexPath.row]
            cell = appVersionCell
        }
        else{
            let arrowCell = tableView.dequeueReusableCell(withIdentifier: SettingsArrowCell.identifier) as! SettingsArrowCell
            arrowCell.data = settingsData.items[indexPath.row]
            cell = arrowCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellData = settingsData.items[indexPath.row]
        DispatchQueue.main.async { [weak self] in
            self?.openViewController(cellData: cellData)
        }
    }
    
    private func sendOpenMoreEvent() {
        TrackerManager.shared.sendOpenMoreEvent()
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    private func openSupportMailController() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([APPInfo.supportEmail])
            
            mail.setSubject("supportEmailSubject".localized)
            mail.setMessageBody(getSupportMessageBody(), isHTML: false)
            present(mail, animated: true)
        } else {
            showFailEmailAlert(message: "supportEmailNotSupportedAlertMessage".localized)
        }
        sendOpenSupportEvent()
    }
    
    private func getSupportMessageBody() -> String {
        let userId = UserInfoManager.shared.getUserInfo()?.id ?? "anonymous"
        return "\n\n\n\nUser ID: \(userId)\nTawazon \(UIApplication.appVersion)\n\(UIDevice.modelIdentifier) iOS \(UIDevice.iOSVersion)"
    }
    
    private func showThankYouAlert() {
        
        let alert = UIAlertController.init(title: "supportEmailSentAlertTitle".localized, message: "supportEmailSentAlertMessage".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "supportEmailSentAlertDone".localized, style: .default, handler: nil))
            
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showFailEmailAlert(message: String) {
        
        let alert = UIAlertController.init(title: "supportEmailFailedAlertTitle".localized, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "supportEmailSentAlertDone".localized, style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                self.showThankYouAlert()
            } else if result == .failed {
                self.showFailEmailAlert(message: "supportEmailFailedAlertMessage".localized)
            }
        }
    }
    
    private func sendOpenSupportEvent() {
        TrackerManager.shared.sendOpenSupportEvent()
    }
}
extension SettingsViewController {
    
    class func instantiate() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SettingsViewController.identifier) as! SettingsViewController
        return viewController
    }
}
