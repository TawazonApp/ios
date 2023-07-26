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
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
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
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.myAccountScreenLoad, payload: nil)
        sendOpenMoreEvent()
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
        viewTitleLabel.text = "moreTitleLabel".localized
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = true
        
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
        SystemSoundID.play(sound: .Sound2)
        self.dismiss(animated: true, completion: nil)
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
    
    private func openViewController(cellData: MoreCellVM) {
//        if cellData.type == MoreCellVM.MoreCellType.privacyPolicy {
//            openPrivacyViewController()
//            return
//        }
//
//        if cellData.type == MoreCellVM.MoreCellType.termsAndConditions {
//            openTermsAndConditionsViewController()
//            return
//        }
//
//        if cellData.type == MoreCellVM.MoreCellType.ourStory {
//            openOurStoryViewController()
//            return
//        }
//
//        if cellData.type == MoreCellVM.MoreCellType.downloadedLibrary {
//            UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() : openDownloadedLibraryViewController()
//            return
//        }
//        if cellData.type == MoreCellVM.MoreCellType.favorites {
//            UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() : openFavoritesViewController()
//            return
//        }
//
        if cellData.type == MoreCellVM.MoreCellType.userProfile {
            openProfileViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.moodStats {
            TrackerManager.shared.sendEvent(name: GeneralCustomEvents.myAccountScreenMoodTracker, payload: nil)
            openMoodStatsViewController()
            return
        }
        
//        if cellData.type == MoreCellVM.MoreCellType.lanaguge {
//            showLanguageAlert()
//            return
//        }
        
        if cellData.type == MoreCellVM.MoreCellType.login {
            openLoginViewController()
            return
        }
        
//        if cellData.type == MoreCellVM.MoreCellType.support {
//            openSupportMailController()
//            return
//        }
        
        if cellData.type == MoreCellVM.MoreCellType.premium {
            TrackerManager.shared.sendEvent(name: GeneralCustomEvents.myAccountScreenPremium, payload: nil)
            openPremiumViewController()
            return
        }
        
        if cellData.type == MoreCellVM.MoreCellType.settings {
            openSettingsViewController()
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
    
    private func openSettingsViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = SettingsViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openMoodStatsViewController()  {
        SystemSoundID.play(sound: .Sound1)
        let viewController = MoodTrackerViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openPremiumViewController() {
        SystemSoundID.play(sound: .Sound1)
        let viewcontroller = GeneralPremiumViewController.instantiate(nextView: .dimiss, fromView: .list)
        
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
    
    private func startGuidedTour(){
        TrackerManager.shared.sendGuidedTourRestarted()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.firstGuidedHome)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.firstGuidedSearch)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.firstGuidedSession)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.firstGuidedSessionDialectsButton)
        
        SystemSoundID.play(sound: .Sound2)
        self.dismiss(animated: true, completion: nil)
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
        
//        if let cellData = moreData.items[indexPath.row] as? MoreNotificationCellVM {
//            let switchCell = tableView.dequeueReusableCell(withIdentifier: MoreSwitchCell.identifier) as! MoreSwitchCell
//            switchCell.data = cellData
//            cell = switchCell
//        } else if moreData.items[indexPath.row].type == MoreCellVM.MoreCellType.appVersion  {
//            let appVersionCell = tableView.dequeueReusableCell(withIdentifier: MoreAppVersionCell.identifier) as! MoreAppVersionCell
//            appVersionCell.data = moreData.items[indexPath.row]
//            cell = appVersionCell
//        } else {
        
        if moreData.items[indexPath.row].type == MoreCellVM.MoreCellType.userProfile{
            let profileCell = tableView.dequeueReusableCell(withIdentifier: MoreProfileCell.identifier) as! MoreProfileCell
            profileCell.data = moreData.items[indexPath.row]
            cell = profileCell
        } else if moreData.items[indexPath.row].type == MoreCellVM.MoreCellType.moodStats{
            let statsCell = tableView.dequeueReusableCell(withIdentifier: MoreStatsCell.identifier) as! MoreStatsCell
            statsCell.data = moreData.items[indexPath.row]
            cell = statsCell
        } else if moreData.items[indexPath.row].type == MoreCellVM.MoreCellType.library{
            let libraryCell = tableView.dequeueReusableCell(withIdentifier: MoreLibraryCell.identifier) as! MoreLibraryCell
            libraryCell.delegate = self
            cell = libraryCell
        }else{
            let arrowCell = tableView.dequeueReusableCell(withIdentifier: MoreArrowCell.identifier) as! MoreArrowCell
            arrowCell.data = moreData.items[indexPath.row]
            cell = arrowCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension MoreViewController: LibraryCollectionCellDelegate{
    func openLibrary(type: MoreLibraryCellVM.MoreLibraryCellType) {
        switch type {
        case .downloads:
            UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() : openDownloadedLibraryViewController()
        case .favorite:
            UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() : openFavoritesViewController()
        }
    }
}
extension MoreViewController {
    
    class func instantiate() -> MoreViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MoreViewController.identifier) as! MoreViewController
        return viewController
    }
}
