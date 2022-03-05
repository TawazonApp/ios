//
//  MoreViewController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import MessageUI
import AudioToolbox

class MoreViewController: BaseViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var moreData: MoreVM! {
        didSet {
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreData = MoreVM()
        initialize()
        sendOpenMoreEvent()
    }
    
    private func initialize() {
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        SystemSoundID.play(sound: .Sound2)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showLanguageAlert() {
        
        let alert = UIAlertController(title: "", message: "changeLanguageAlertTitle".localized, preferredStyle: .actionSheet, blurStyle: .dark)
         
        let englishAction = UIAlertAction(title: "English", style: .default) { [weak self]  (action) in
            self?.changeLanguage(language: .english)
        }
        if Language.language == .english {
            englishAction.setValue(true, forKey: "checked")
        }
        alert.addAction(englishAction)
        
        let arabicAction = UIAlertAction(title: "العربية", style: .default) { [weak self]  (action) in
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
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        (UIApplication.shared.delegate as? AppDelegate)?.resetApp()
    }
    
    private func openViewController(cellData: MoreCellVM) {
        if cellData.type == MoreCellVM.MoreCellType.privacyPolicy {
            openPrivacyViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.termsAndConditions {
            openTermsAndConditionsViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.ourStory {
            openOurStoryViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.downloadedLibrary {
            UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() : openDownloadedLibraryViewController()
            return
        }
        if cellData.type == MoreCellVM.MoreCellType.favorites {
            UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() : openFavoritesViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.userProfile {
            openProfileViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.lanaguge {
            showLanguageAlert()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.login {
            openLoginViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.support {
            openSupportMailController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.premium {
            openPremiumViewController()
            return
        }
    }
    
    
    private func openTermsAndConditionsViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = PrivacyViewController.instantiate(viewType: .termsAndConditions)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openPrivacyViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = PrivacyViewController.instantiate(viewType: .privacyPolicy)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openOurStoryViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = OurStoryViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openDownloadedLibraryViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = DownloadedLibraryViewController.instantiate(type: .downloads)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openFavoritesViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = DownloadedLibraryViewController.instantiate(type: .favorite)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openProfileViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = ProfileViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openPremiumViewController() {
        SystemSoundID.play(sound: .Sound1)
        let viewcontroller = PremiumViewController.instantiate(nextView: .dimiss)
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    private func openLoginViewController() {
        SystemSoundID.play(sound: .Sound1)
        
        let viewController = MembershipViewController.instantiate(viewType: .login)
        
        let navigationController = NavigationController.init(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
    private func showLoginPermissionAlert() {
        PermissionAlert.shared.show(type: PermissionAlertView.AlertType.login, animated: true, actionHandler: {
            PermissionAlert.shared.hide(animated: true, completion: { [weak self] in
                self?.openLoginViewController()
            })
        }, cancelHandler: {
            PermissionAlert.shared.hide(animated: true)
        })
    }
    
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreData.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if let cellData = moreData.items[indexPath.row] as? MoreNotificationCellVM {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: MoreSwitchCell.identifier) as! MoreSwitchCell
            switchCell.data = cellData
            cell = switchCell
        } else if moreData.items[indexPath.row].type == MoreCellVM.MoreCellType.appVersion  {
            let appVersionCell = tableView.dequeueReusableCell(withIdentifier: MoreAppVersionCell.identifier) as! MoreAppVersionCell
            appVersionCell.data = moreData.items[indexPath.row]
            cell = appVersionCell
        } else {
            let arrowCell = tableView.dequeueReusableCell(withIdentifier: MoreArrowCell.identifier) as! MoreArrowCell
            arrowCell.data = moreData.items[indexPath.row]
            cell = arrowCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 80
        if moreData.items[indexPath.row].type == MoreCellVM.MoreCellType.appVersion {
            let contentHeight = CGFloat(moreData.items.count) * height
            let extraSpace = tableView.frame.height - contentHeight - 30
            if extraSpace > 0 {
                height += extraSpace
            }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellData = moreData.items[indexPath.row]
        DispatchQueue.main.async { [weak self] in
            self?.openViewController(cellData: cellData)
        }
    }
    
    private func sendOpenMoreEvent() {
        TrackerManager.shared.sendOpenMoreEvent()
    }
}

extension MoreViewController: MFMailComposeViewControllerDelegate {
    
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

extension MoreViewController {
    
    class func instantiate() -> MoreViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MoreViewController.identifier) as! MoreViewController
        return viewController
    }
}
