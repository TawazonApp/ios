//
//  HomdViewController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftyStoreKit
import StoreKit
import Alamofire

class HomeViewController: SoundEffectsPresenterViewController {
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var videosContainer: HomeVideosContainerView!
    @IBOutlet weak var backgroundSoundButton: UIButton!
    @IBOutlet weak var backgroundView: HomeBackgroundView!
    @IBOutlet weak var sectionsTableView: HomeTableView!
    @IBOutlet weak var headerView: UIView!
    
    var videos: [HomeVideoCellVM] = [] {
        didSet {
            videosContainer.videos = videos
        }
    }
    lazy var home: HomeVM = HomeVM(service: HomeServiceCache.shared)
    var viewDidAppeared = false
    
    private var requestNotificationPermission = 0 {
        didSet {
            if requestNotificationPermission == 4 {
                (UIApplication.shared.delegate as? AppDelegate)?.registerRemoteNotifications()
            }
        }
    }
    private var statusBarHidden = false {
        didSet {
            if statusBarHidden != oldValue {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeNotification()
        home = HomeVM(service: HomeServiceCache.shared)
        buildVideosArray()
        fetchHomeSections()
        updateBackgroundSoundStyle()
        startHomeGuidedTour()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestNotificationPermission += 1
        let discountCampaign = UserInfoManager.shared.subscription?.types.items.first(where: { $0.discountCampaign != nil })
        if let discountCampaignId = discountCampaign?.discountCampaign?.id,
           UserDefaults.isFirstDiscountOffer(id: discountCampaignId) {
            showDiscountIfNeeded()
        } else {
            showOnboardingViewIfNeeded()
        }
    }
      
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        startHomeGuidedTour()
        return nil
    }
    
    func showOnboardingViewIfNeeded() {
        if UserDefaults.isFirstOpened() {
            showOnboardingViewController()
            UserDefaults.appOpened()
        }
    }
    
    private func startHomeGuidedTour(){
        let homeGuidedTourSteps = [
            StepInfo(view: moreButton!,position: moreButton.respectLanguageFrame(), textInfo: ("more_menu","helpTextMoreButton".localized), isBelow: true, isSameHierarchy: false),
            StepInfo(view: searchButton!,position: searchButton!.respectLanguageFrame(), textInfo: ("search","helpTextSearchButton".localized), isBelow: true, isSameHierarchy: false),
            StepInfo(view: backgroundSoundButton!, position: backgroundSoundButton.respectLanguageFrame(), textInfo: ("background_music","helpTextBackgroundSoundButton".localized), isBelow: true, isSameHierarchy: false),
            StepInfo(view: soundsButton!, position: soundsButton!.respectLanguageFrame(), textInfo: ("sound_effects","helpTextSoundsButton".localized), isBelow: true, isSameHierarchy: false),
            
        ]
        NotificationCenter.default.post(name: Notification.Name.homeGuidedTourSteps, object: homeGuidedTourSteps)
    }
    
    
    func showDiscountIfNeeded() {
        guard #available(iOS 11.2, *) else {
            showOnboardingViewIfNeeded()
            return
        }
        UserInfoManager.shared.fetchUserInfo(service: MembershipServiceFactory.service()) { [weak self] (error) in
            let userInfo = UserInfoManager.shared.getUserInfo()
            let subscriptionTypes = UserInfoManager.shared.subscription?.types
            
            
            guard userInfo?.isPremium() == false,
                  let discountOffer = subscriptionTypes?.items.first(where: { $0.discountCampaign != nil && $0.discount != nil }),
                  let discountOfferId = discountOffer.discountCampaign?.id  else {
                self?.showOnboardingViewIfNeeded()
                return
            }
            SwiftyStoreKit.retrieveProductsInfo([discountOffer.id]) { [weak self] (result) in
                
                if let product = result.retrievedProducts.map({$0}).first {
                    self?.showDiscountOffer(product: product, offerInfo: discountOffer)
                    UserDefaults.discountOfferOpened(id: discountOfferId)
                    UserDefaults.appOpened()
                }
            }
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !viewDidAppeared {
            backgroundView.topConstraint.isActive = false
            let topConstraint = backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: sectionsTableView.contentInset.top)
            topConstraint.isActive = true
            backgroundView.topConstraint = topConstraint
            viewDidAppeared = true
            sectionsTableView.videosContainer = videosContainer
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewDidAppeared {
            setupTableContentInset()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func initialize() {
        view.backgroundColor = UIColor.darkSeven
        
        moreButton.setImage(#imageLiteral(resourceName: "More.pdf"), for: .normal)
        moreButton.tintColor = UIColor.white
        moreButton.layer.cornerRadius = moreButton.frame.height/2
        moreButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        initializeBackgroundSoundButton()
        initializeTableView()
    }
    
    private func initializeBackgroundSoundButton() {
        backgroundSoundButton.tintColor = UIColor.white
        backgroundSoundButton.titleLabel?.font = UIFont.kacstPen(ofSize: 16)
        backgroundSoundButton.layer.cornerRadius = backgroundSoundButton.frame.height/2
        backgroundSoundButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
     private func initializeTableView() {
        sectionsTableView.rowHeight = UITableView.automaticDimension
        sectionsTableView.estimatedRowHeight = 100
    }
    
    private func setupTableContentInset() {
        let topInset = backgroundView.frame.origin.y
        sectionsTableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 120, right: 0)
        sectionsTableView.contentOffset = CGPoint(x: 0, y: -topInset)
    }
    
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userPremiumStatusChanged(_:)), name: Notification.Name.userPremiumStatusChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundSoundStatusChanged(_:)), name: Notification.Name.backgroundSoundStatusChanged, object: nil)
    }
    
    @objc private func enterForegroundNotification(_ notification: Notification) {
        updateUserInfo()
        fetchHomeSections()
    }
    
    @objc private func userPremiumStatusChanged(_ notification: Notification) {
        fetchHomeSections()
    }
    
    @objc private func backgroundSoundStatusChanged(_ notification: Notification) {
        updateBackgroundSoundStyle()
    }
    
    private func updateUserInfo() {
        UserInfoManager.shared.fetchUserInfo(service: MembershipServiceFactory.service()) {(error) in
        }
    }
    
    private func updateTabBarAlpha(alpha: CGFloat) {
        (self.tabBarController as? MainTabBarController)?.mainTabBar.alpha = alpha
    }
    
    private func buildVideosArray() {
        let video1 = HomeVideoCellVM(videoName: "HomeVideo3", videoType: "mp4")
        let video2 = HomeVideoCellVM(videoName: "NatureTrees", videoType: "mp4")
        var items = [video1, video2]
        if home.isRamadan {
            let ramadanVideo = HomeVideoCellVM(videoName: "RamadanVideo", videoType: "mp4")
            items.insert(ramadanVideo, at: 0)
        }
        videos = items
    }
    
    private func fetchHomeSections() {
        home.getHomeSections { [weak self] (error) in
            self?.reloadData()
            if let error = error {
                self?.showErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    private func reloadData() {
        sectionsTableView.reloadData()
    }
    
    
    private func updateBackgroundSoundStyle() {
        let image = (BackgroundAudioManager.shared.mainBackgroundAudio.playingStatus == .playing) ?  UIImage(named: "BackgroundMusicOn") :  UIImage(named: "BackgroundMusicOff")
        
        backgroundSoundButton.setImage(image, for: .normal)
    }
    
    @IBAction func backgroundSoundButtonTapped(_ sender: UIButton) {
        if BackgroundAudioManager.shared.mainBackgroundAudio.playingStatus == .playing {
            BackgroundAudioManager.shared.stopBackgroundSound()
            UserDefaults.saveUserAppBackgroundSound(status: false)
        } else {
            BackgroundAudioManager.shared.playBackgroundSound()
            UserDefaults.saveUserAppBackgroundSound(status: true)
        }
        updateBackgroundSoundStyle()
        requestNotificationPermission += 1
    }

    private func openMoreViewController() {
        SystemSoundID.play(sound: .Sound2)
        let viewcontroller = MoreViewController.instantiate()
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func openSessionPlayerViewController(session: HomeSessionVM) {
        guard let sessionModel = session.session else { return }
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        openMoreViewController()
        requestNotificationPermission += 1
    }
    
    private func showOnboardingViewController() {
        let viewController = OnboardingViewController.instantiate()
        navigationController?.present(viewController, animated: true, completion: {
            
        })
    }
    
    private func showDiscountOffer(product: SKProduct, offerInfo: SubscriptionTypeItem) {
        let viewController = PremiumDiscountViewController.instantiate(product: product, offerInfo: offerInfo)
        navigationController?.present(viewController, animated: true, completion: {
            
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (home.sections?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        if indexPath.row == 0 {
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomeTableFeelingCell.identifier) as! HomeTableFeelingCell
            sectionCell.tableView = tableView
            sectionCell.delegate = self
            sectionCell.fetchAndReloadData()
            cell = sectionCell
            
        } else if let section = home.sections?[indexPath.row - 1] {
            if section.style == .card {
                let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomeTableCardSectionCell.identifier) as! HomeTableCardSectionCell
                sectionCell.delegate = self
                sectionCell.data = section
                cell = sectionCell
            }
            else if section.style == .banner{
                if section.bannerType == .banner1{
                    let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomePremiumBannerTableViewCell.identifier) as! HomePremiumBannerTableViewCell
                    sectionCell.bannerContainerView.viewDelegate = self
                    sectionCell.data = section
                    cell = sectionCell
                }
                else if section.bannerType ==  .banner2{
                    let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomePremiumGradientBannerTableViewCell.identifier) as! HomePremiumGradientBannerTableViewCell
                    sectionCell.bannerContainerView.viewDelegate = self
                    sectionCell.data = section
                    cell = sectionCell
                }
                else if section.bannerType ==  .banner3{
                    let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomePremiumCenteredSpecialBannerTableViewCell.identifier) as! HomePremiumCenteredSpecialBannerTableViewCell
                    sectionCell.bannerContainerView.viewDelegate = self
                    sectionCell.data = section
                    cell = sectionCell
                }
                else if section.bannerType ==  .banner4{
                    let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomePremiumBannerWithHeaderLogoTableViewCell.identifier) as! HomePremiumBannerWithHeaderLogoTableViewCell
                    sectionCell.bannerContainerView.viewDelegate = self
                    sectionCell.data = section
                    cell = sectionCell
                }
                else if section.bannerType ==  .banner5{
                    let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomePremiumFullWidthBannerTableViewCell.identifier) as! HomePremiumFullWidthBannerTableViewCell
                    sectionCell.bannerContainerView.viewDelegate = self
                    sectionCell.data = section
                    cell = sectionCell
                }
            }
            else {
                let sectionCell = tableView.dequeueReusableCell(withIdentifier: HomeTableHorizontalSectionCell.identifier) as! HomeTableHorizontalSectionCell
                sectionCell.delegate = self
                           sectionCell.data = section
                           cell = sectionCell
            }
           
        }
        cell.layer.masksToBounds = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if let section = home.sections?[indexPath.row - 1] {
                if section.clickable == true {
                    openPremiumPage(fromBanner: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == sectionsTableView, viewDidAppeared {
            backgroundView.topConstraint.constant = min(-scrollView.contentOffset.y, sectionsTableView.contentInset.top)
            let intersectionHeight = Float(headerView.frame.intersection(backgroundView.frame).height)
            if intersectionHeight <= 10.0 {
                headerView.alpha = CGFloat(1.0 - (intersectionHeight / 10.0))
                headerView.isHidden = false
            } else {
                headerView.isHidden = true
            }
            statusBarHidden = headerView.isHidden
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
}

extension HomeViewController:  HomeTableFeelingCellDelegate, HomeTableHorizontalSectionCellDelegate, HomeTableCardSectionCellDelegate {
   
    func openSeriesView(seriesId: String, session: SessionModel) {
        let viewController = SeriesViewController.instantiate(seriesId: seriesId, seriesSession: session)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func playSession(_ sender: HomeTableFeelingCell, session: HomeSessionVM) {
        playSession(session)
    }
    
    func playSession(_ sender: HomeTableHorizontalSectionCell, session: HomeSessionVM) {
        playSession(session)
    }
    
    func sectionTapped(_ sender: HomeTableCardSectionCell, section: HomeSectionVM?) {
        guard let section = section else {
            return
        }
        openSectionView(section)
    }
    
    func sectionTapped(_ sender: HomeTableHorizontalSectionCell, section: HomeSectionVM?) {
        guard let section = section else {
            return
        }
        openSectionView(section)
    }
    
    private func playSession(_ session: HomeSessionVM) {
        if (session.isLock) {
            self.openPremiumViewController()
        } else {
            openSessionPlayerViewController(session: session)
        }
        requestNotificationPermission += 1
    }
    
    private func openPremiumViewController() {
        guard self.presentedViewController == nil else {
            return
        }
        let viewcontroller = GeneralPremiumViewController.instantiate(nextView: .dimiss, fromView: .session)
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func openSectionView(_ section: HomeSectionVM) {
        if let categoryId = section.categoryId,
           let tabBarId = MainTabBarView.tabBarItemsIds.getItemId(forCategory: categoryId) {
            (tabBarController as? MainTabBarController)?.openCategory(categoryId: tabBarId.rawValue)
            return
        } else {
            let sectionViewController =  SectionSessionListViewController.instantiate(id: section.id, name: section.title, type: .homeSection)
            self.navigationController?.pushViewController(sectionViewController, animated: true)
            
        }
    }
    
    func showErrorMessage(_ sender: HomeTableFeelingCell, message: String) {
        showErrorMessage(message: message)
    }
    
}

extension HomeViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}

extension HomeViewController: HomeTableBannerCellDelegate{
    func purchaseTapped() {
        openPremiumPage(fromBanner: true)
    }
    
    func moreTapped() {
        openPremiumPage(fromBanner: false)
    }
    private func openPremiumPage(fromBanner: Bool){
        var viewcontroller = GeneralPremiumViewController.instantiate(nextView: .dimiss, fromView: .banner)
        if !fromBanner {
            viewcontroller = GeneralPremiumViewController.instantiate(nextView: .dimiss, fromView: .session)
        }
        
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
}
