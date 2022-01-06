//
//  ProfileViewController.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ProfileViewController: MoreDetailsViewController {
    
    @IBOutlet weak var imageView: UploadImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: PaddingLabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let profile: ProfileVM = ProfileVM(service: MembershipServiceFactory.service())
    var tableItems: [ProfileCellVM] = []
    var imagePicker: UIImagePickerController?
    let defaultProfilePicture = "DefaultProfilePicture"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeNotification()
        fetchAndReload()
        fillData()
        sendOpenUserProfileEvent()
    }
    
    private func initialize() {
        backgroundImageName = "ProfileBackground"
        title = "profileViewTitle".localized
        
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        userNameLabel.font = UIFont.kacstPen(ofSize: 20)
        userNameLabel.textColor = UIColor.white
        
        userEmailLabel.font = UIFont.kacstPen(ofSize: 13)
        userEmailLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        accountTypeLabel.leftInset = 8
        accountTypeLabel.rightInset = 8
        accountTypeLabel.textColor = UIColor.black
        accountTypeLabel.font = UIFont.kacstPen(ofSize: 13)
        accountTypeLabel.layer.cornerRadius = 10
        accountTypeLabel.layer.masksToBounds = true
        
        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.10)
    }
    
    private func initializeNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(userPremiumStatusChanged(_:)), name: Notification.Name.userPremiumStatusChanged, object: nil)
    }
    
    @objc private func userPremiumStatusChanged(_ notification: Notification) {
        fetchAndReload()
    }
    
    private func fetchAndReload() {
        profile.userInfo { [weak self] (error) in
            self?.fillData()
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            }
        }
    }
    
    private func fillData() {
        userNameLabel.text = profile.name
        userEmailLabel.text = profile.email
        
        setProfileImage(image: profile.profileImageUploading)
        fillAccountTypeLabel()
        
        tableItems = profile.tableItems
        tableReloadData()
    }
    
    private func setProfileImage(image: UIImage?) {
        
        if let image = image {
            imageView.image = image
            return
        }
        
        if let imageUrl = profile.imageUrl?.url {
            imageView.af.setImage(withURL: imageUrl, placeholderImage: UIImage(named: defaultProfilePicture))
        } else {
            imageView.image = UIImage(named: defaultProfilePicture)
        }
    }
    
    private func addNewProfileImage(image: UIImage) {
        setProfileImage(image: image)
        imageView.loading = true
        profile.uploadProfileImage(image: image) { [weak self] (error) in
            self?.imageView.loading = false
            self?.setProfileImage(image: nil)
            
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            }
        }
    }
    
    private func removeProfileImage() {
        imageView.image = UIImage(named: defaultProfilePicture)
        profile.removeProfileImage { [weak self] (error) in
            self?.setProfileImage(image: nil)
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            }
        }
    }
    
    private func fillAccountTypeLabel() {
        accountTypeLabel.text = profile.premiumString
        accountTypeLabel.applyGradientColor(colors: profile.premiumGradiantColors.map({ return $0.cgColor}), startPoint: .left, endPoint: .right)
    }
    
    private func tableReloadData() {
        tableView.reloadData()
    }
    
    private func cellTapped(type: ProfileCellVM.Types) {
        switch type {
        case .changeUserName:
            openChangeUserNameViewController()
            break
        case .changeProfilePicture:
            if profile.profileImageUploading == nil {
                showEditProfilePictureOptions()
            } else {
                showErrorMessage(message: "profileImageStillUploadingErrorMessage".localized)
            }
            break
        case .changePassword:
            openChangePasswordViewController()
            break
        case .changeToPremium:
            openPremiumViewController()
            break
        case .logout:
            showLogoutConfirmationAlert()
            break
            
        }
    }
    
    private func openChangePasswordViewController() {
        let formData = ProfileChangePasswordFormVM(service: MembershipServiceFactory.service())
        let viewController = ProfileEditFieldViewController.instantiate(formData: formData)
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
        sendUserChangePasswordEvent()
    }
    
    private func openChangeUserNameViewController() {
        let formData = ProfileEditUserNameFormVM(service: MembershipServiceFactory.service(), name: profile.name)
        
        let viewController = ProfileEditFieldViewController.instantiate(formData: formData)
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
        sendUserChangeNameEvent()
    }
    
    private func openPremiumViewController() {
        let viewcontroller = PremiumViewController.instantiate(nextView: .dimiss)
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func showLogoutConfirmationAlert() {
        
        let alert = UIAlertController(title: nil, message: "logoutConfirmAlertMessage".localized, preferredStyle: .actionSheet, blurStyle: .dark)
        
        alert.addAction(title: "logoutConfirmAlertLogoutButton".localized, style: .destructive) { [weak self] (alert) in
            self?.logout()
            self?.sendSuccesslogoutEvent()
        }
        
        alert.addAction(title: "logoutConfirmAlertCancelButton".localized, style: .cancel) { [weak self] (alert) in
            self?.sendCancelLogoutEvent()
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showEditProfilePictureOptions() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet, blurStyle: .dark)
        
        alert.addAction(title: "profilePictureFromPhotoGallary".localized, style: .default) { [weak self] (alert) in
            self?.selectImageFrom(.photoLibrary)
            self?.sendUserChangePhotoEvent()
        }
        
        alert.addAction(title: "profilePictureFromCamera".localized, style: .default) { [weak self] (alert) in
            self?.selectImageFrom(.camera)
            self?.sendUserChangePhotoEvent()
        }
        
        if profile.imageUrl != nil {
            alert.addAction(title: "profilePictureRemovePicture".localized, style: .destructive) { [weak self] (alert) in
                self?.removeProfileImage()
                self?.sendUserChangePhotoEvent()
            }
        }
        
        
        alert.addAction(title: "logoutConfirmAlertCancelButton".localized, style: .cancel, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logout() {
        let logout = LogoutVM(service: MembershipServiceFactory.service())
        LoadingHud.shared.show(animated: true)
        logout.logout { [weak self] (error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else {
                self?.performLogout()
            }
        }
    }
    
    private func performLogout() {
        UserDefaults.resetUserToken()
        UserDefaults.resetUser()
        UserInfoManager.shared.reset()
        LocalSessionsManager.shared.deleteAllLocalUserSessions()
        // stop user sounds
        SessionPlayerMananger.shared.session = nil
        AudioPlayerManager.shared.stop(clearQueue: true)
        BackgroundAudioManager.shared.stopSoundEffectsSounds()
        
        (UIApplication.shared.delegate as? AppDelegate)?.switchRootViewController(viewController: WelecomeViewController.instantiate(), animated: true, completion: nil)
    }
    
    private func sendOpenUserProfileEvent() {
        TrackerManager.shared.sendOpenUserProfileEvent()
    }
    
    private func sendUserChangeNameEvent() {
        TrackerManager.shared.sendUserChangeNameEvent()
    }
    
    private func sendUserChangePasswordEvent() {
        TrackerManager.shared.sendUserChangePasswordEvent()
    }
    
    private func sendUserChangePhotoEvent() {
        TrackerManager.shared.sendUserChangePhotoEvent()
    }
    
    private func sendSuccesslogoutEvent() {
         TrackerManager.shared.sendSuccesslogoutEvent()
    }
    
    private func sendCancelLogoutEvent() {
         TrackerManager.shared.sendCancelLogoutEvent()
    }
}

extension ProfileViewController: ProfileEditFieldViewControllerDelegate {
    
    func userInfoChanged() {
        profile.userInfo { [weak self] (error) in
            self?.fillData()
        }
    }
}

extension ProfileViewController: UITableViewDelegate,  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as! ProfileCell
        cell.cellData = tableItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = tableItems[indexPath.row].type
        DispatchQueue.main.async { [weak self] in
            self?.cellTapped(type: type!)
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    //MARK: - Take image
    @IBAction func takePhoto(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker!.delegate = self
        switch source {
        case .camera:
            imagePicker!.sourceType = .camera
        case .photoLibrary:
            imagePicker!.sourceType = .photoLibrary
        }
        present(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        addNewProfileImage(image: selectedImage)
    }
}

extension ProfileViewController {
    
    class func instantiate() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: ProfileViewController.identifier) as! ProfileViewController
        return viewController
    }
}
