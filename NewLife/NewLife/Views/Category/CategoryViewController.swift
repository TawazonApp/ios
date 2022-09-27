//
//  CategoryViewController.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class CategoryViewController: SoundEffectsPresenterViewController {
    
    @IBOutlet weak var headerView: CategoryHeaderView!
    @IBOutlet weak var summaryView: CategorySummaryView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topOverlayView: GradientView!
    @IBOutlet weak var bottomOverlayView: GradientView!
    
    var fetching: Bool = false
    var category: CategoryVM? {
        didSet {
            if category != oldValue {
                fillData()
                fetchAndReload()
            }
        }
    }
    
    var selectedSubCategory: SubCategoryVM? {
        didSet {
            collectionReloadData()
            if selectedSubCategory != nil {
                sendTapSubCategoryEvent(subCategory: selectedSubCategory!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if category == nil || category?.subCategories.count == 0 {
            fetchAndReload()
        }
        sendTapCategoryEvent()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func initialize() {
        view.backgroundColor = UIColor.black
        view.layer.masksToBounds = true
        
        headerView.delegate = self
        
        bottomOverlayView.applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        
    }
    
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userPremiumStatusChanged(_:)), name: Notification.Name.userPremiumStatusChanged, object: nil)
    }
    
    @objc private func enterForegroundNotification(_ notification: Notification) {
        fetchAndReload()
    }
    
    @objc private func userPremiumStatusChanged(_ notification: Notification) {
        collectionReloadData()
    }
    
    func fillData()  {
        view.backgroundColor = category?.backgroundColor
        headerView.category = category
        summaryView.category = category
        updateTopOverlayStyle()
    }
    
    private func fetchAndReload() {
        guard fetching == false else { return }
        fetching = true
        category?.fetchCategory(completion: { [weak self] (error) in
            self?.fetching = false
            self?.selectedSubCategory = self?.category?.subCategories.first
            self?.fillData()
        })
    }
    
    private func collectionReloadData() {
        collectionView.reloadData()
    }
    
    private func updateTopOverlayStyle() {
        let colors = (category != nil) ? [category!.backgroundColor.cgColor, category!.backgroundColor.withAlphaComponent(0.0).cgColor] : [ UIColor.clear.cgColor , UIColor.clear.cgColor]
        topOverlayView.applyGradientColor(colors: colors, startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        
        updateTopOverlayViewAlphaValue()
    }
    
    
    private func getScrollOffsetRatio() -> CGFloat {
         var ratio = (summaryView.frame.height - collectionView.contentOffset.y) / summaryView.frame.height
        ratio = (ratio >= 1) ? 1 : ratio
        ratio = (ratio <= 0) ? 0 : ratio
        return ratio
    }
    
    private func updateSummaryAlphaValue() {
        let ratio = getScrollOffsetRatio()
        if summaryView.alpha != ratio {
            summaryView.alpha = ratio
        }
    }
    
    private func updateTopOverlayViewAlphaValue() {
        let ratio = 1 - getScrollOffsetRatio()
        if topOverlayView.alpha != ratio {
            topOverlayView.alpha = ratio
        }
    }
    
    private func updateHeaderLayout() {
        let ratio = getScrollOffsetRatio()
        headerView.sizeRatio = ratio
    }
    
    private func openSessionPlayerViewController(session: CategorySessionVM) {
        guard let session = session.session else { return }
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: session), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    private func sendTapCategoryEvent() {
        TrackerManager.shared.sendTapCategoryEvent(id: category?.id ?? "", name: category?.name ?? "")
    }
    
    private func sendTapSubCategoryEvent(subCategory: SubCategoryVM) {
        TrackerManager.shared.sendTapSubCategoryEvent(id: subCategory.id, name: subCategory.name)
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSubCategory?.sessions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySessionCollectionCell.identifier, for: indexPath) as! CategorySessionCollectionCell
        cell.session = selectedSubCategory?.sessions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (2*20), height: 164)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let session = selectedSubCategory?.sessions[indexPath.item] else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
//            if session.isLock {
//                self?.openPremiumViewController()
//            } else {
                self?.openSessionPlayerViewController(session: session)
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let selectedSubCategory = selectedSubCategory, indexPath.item >= (selectedSubCategory.sessions.count - 4) {
            
            selectedSubCategory.fetchMore { [weak self] (error) in
                if error == nil {
                    self?.collectionReloadData()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSummaryAlphaValue()
        updateTopOverlayViewAlphaValue()
        updateHeaderLayout()
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
}

extension CategoryViewController: CategoryHeaderViewDelegate {
    
    func subCategoryTapped(subCategory: SubCategoryVM) {
        if subCategory != selectedSubCategory {
            selectedSubCategory = subCategory
        }
    }
}


extension CategoryViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}
