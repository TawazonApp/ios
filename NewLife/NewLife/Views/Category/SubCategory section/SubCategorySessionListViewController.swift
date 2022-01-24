//
//  SubCategorySessionListViewController.swift
//  Tawazon
//
//  Created by mac on 23/01/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SubCategorySessionListViewController: HandleErrorViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundView: HomeBackgroundView!

    var subCategoryId:String!
    var subCategoryVM: SubCategorySectionVM!
    
    private var viewDidAppeared = false
    private var statusBarHidden = false {
        didSet {
            if statusBarHidden != oldValue {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    var playerBar: MainPlayerBarView?

    override func viewDidLoad() {
        super.viewDidLoad()
        subCategoryVM = SubCategorySectionVM(service: SessionServiceOffline(service: SessionServiceFactory.service()), subCategoryId: subCategoryId, subCategoryName: "")
        initialize()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !viewDidAppeared {
            backgroundView.topConstraint.isActive = false
            let topConstraint = backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: collectionView.contentInset.top)
            topConstraint.isActive = true
            backgroundView.topConstraint = topConstraint
            viewDidAppeared = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initialize() {
        self.view.layer.masksToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        
        
        backButton.layer.cornerRadius = backButton.frame.height/2
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.tintColor = UIColor.white
        let backImage = isModal() ?  #imageLiteral(resourceName: "Cancel.pdf") : #imageLiteral(resourceName: "BackArrow.pdf").flipIfNeeded
        backButton.setImage(backImage, for: .normal)
        
        titleLabel.font = UIFont.kacstPen(ofSize: 24)
        titleLabel.textColor = UIColor.white
        
        backgroundImageView.image = UIImage(named: "SessionListHeader")
        titleLabel.text = subCategoryVM.name
        setupCollectionContentInset()
        initializeNotification()
    }
    
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSessionPlayerBar(_:)), name: NSNotification.Name.showSessionPlayerBar
            , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideSessionPlayerBar(_:)), name: NSNotification.Name.hideSessionPlayerBar
            , object: nil)
    }
    
    private func setupCollectionContentInset() {
        let topInset = backgroundView.frame.origin.y
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 64, right: 0)
        collectionView.contentOffset = CGPoint(x: 0, y: -topInset)
    }
    
    private func fetchData() {
        subCategoryVM.getSessions(completion: { [weak self] (error) in
            if let error = error {
                self?.showErrorMessage( message: error.message ?? "generalErrorMessage".localized)
            }
            self?.initialize()
            self?.reloadCollectionData()
        })
    }
    
    private func reloadCollectionData() {
        collectionView.reloadData()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if isModal() {
            self.dismiss(animated: true, completion: nil)
        } else {
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func openSessionPlayerViewController(session: SessionModel) {
        let viewcontroller = SessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: session), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
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
    
    private func playSession(session: SessionModel) {
        openSessionPlayerViewController(session: session)
    }
}


extension SubCategorySessionListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategoryVM.sessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySessionCollectionCell.identifier, for: indexPath) as! CategorySessionCollectionCell
        cell.session = subCategoryVM?.sessions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 40
        return CGSize(width: width, height: width * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView, viewDidAppeared {
            backgroundView.topConstraint.constant = min(-scrollView.contentOffset.y, collectionView.contentInset.top)
            var headerFrame = headerView.frame
            headerFrame.size.height += 10
            let intersectionHeight = Float(headerFrame.intersection(backgroundView.frame).height)
            if intersectionHeight <= 10 {
                headerView.alpha = CGFloat(1.0 - (intersectionHeight / 10.0))
                headerView.isHidden = false
            } else {
                headerView.isHidden = true
            }
            statusBarHidden = headerView.isHidden
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let session = subCategoryVM.sessions[safe: indexPath.item] else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        cell?.pulsate()
        if let sessionModel = session.session {
            playSession(session: sessionModel)
        }
    }
}


extension SubCategorySessionListViewController {
    class func instantiate(id: String) -> SubCategorySessionListViewController {
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SubCategorySessionListViewController.identifier) as! SubCategorySessionListViewController
        viewController.subCategoryId = id
        return viewController
    }
}

extension SubCategorySessionListViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}


extension SubCategorySessionListViewController {
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
        var safeBottomAnchor: NSLayoutYAxisAnchor  = view.bottomAnchor
        if #available(iOS 11.0, *) {
            safeBottomAnchor = self.view.safeAreaLayoutGuide.bottomAnchor
        }
        playerBar!.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -16).isActive = true
        
    }
}

extension SubCategorySessionListViewController: MainPlayerBarViewDelegate {
    
    func playerTapped() {
        guard let session = SessionPlayerMananger.shared.session?.session else { return }
        openSessionPlayerViewController(session: session)
    }
    
    func openPremiumView(_ sender: MainPlayerBarView) {
        openPremiumViewController()
    }
}
