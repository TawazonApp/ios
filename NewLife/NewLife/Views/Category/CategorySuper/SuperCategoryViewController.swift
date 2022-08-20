//
//  SuperCategoryViewController.swift
//  Tawazon
//
//  Created by mac on 21/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SuperCategoryViewController: SoundEffectsPresenterViewController {
    
    
    
    @IBOutlet weak var headerView: SuperCategoryHeaderView!
    @IBOutlet weak var summaryView: CategorySummaryView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var sectionsView : CategorySectionsView!
    @IBOutlet weak var sessionsView : CategorySessionsView!
    @IBOutlet weak var topOverlayView: GradientView!
    @IBOutlet weak var bottomOverlayView: GradientView!

    var category: SuperCategoryVM? {
        didSet {
            if category != oldValue {
                fillData()
                fetchData()
            }
        }
    }
    var selectedSubCategory: SubCategoryVM? {
        didSet {
            if selectedSubCategory?.isHome ?? false {
                sectionsView.sections = self.category?.sections
            }else{
                sessionsView.sessions = selectedSubCategory?.sessions
                sessionsView.selectedSubCategory = selectedSubCategory
            }
            updateContentView(isHome: selectedSubCategory?.isHome ?? false)
            if selectedSubCategory != nil {
                //TODO: sendTapSubCategoryEvent
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupTableContentInset()
    }
    
    private func setupTableContentInset() {
        sectionsView.sectionsTableView.contentInset.bottom = 120
    }
    private func updateContentView(isHome: Bool){

        sectionsView.isHidden = !isHome
        sessionsView.isHidden = isHome
    }
    private func initialize() {
        view.backgroundColor = category?.backgroundColor
        view.layer.masksToBounds = true
        
        headerView.delegate = self
        headerView.topBarDelegate = self
        sectionsView.delegate = self
        sessionsView.delegate = self
        bottomOverlayView.applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        
    }
    private func fetchData() {
        category?.fetchCategory { [weak self] (error) in
            if let error = error {
                self?.showErrorMessage(message: error.localizedDescription)
            }
            self?.selectedSubCategory = self?.category?.subCategories.first
            self?.fillData()
            
        }
    }
    
    private func fillData(){
        
        view.backgroundColor = category?.backgroundColor
        headerView.category = category
        summaryView.category = category
        updateTopOverlayStyle()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func updateTopOverlayStyle() {
        let colors = (category != nil) ? [category!.backgroundColor.cgColor, category!.backgroundColor.withAlphaComponent(0.0).cgColor] : [ UIColor.clear.cgColor , UIColor.clear.cgColor]
        topOverlayView.applyGradientColor(colors: colors, startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        
        updateTopOverlayViewAlphaValue()
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
    private func getScrollOffsetRatio() -> CGFloat {
        var ratio = 0.0
        if selectedSubCategory?.isHome ?? false{
            ratio = (summaryView.frame.height - sectionsView.sectionsTableView.contentOffset.y) / summaryView.frame.height
        }else{
            ratio = ((summaryView.frame.height + 0) - sessionsView.collectionView.contentOffset.y) / (summaryView.frame.height + 0)
        }
        
        ratio = (ratio >= 1) ? 1 : ratio
        ratio = (ratio <= 0) ? 0 : ratio
        return ratio
    }
    
}

extension SuperCategoryViewController: CategoryHeaderViewDelegate {
    
    func subCategoryTapped(subCategory: SubCategoryVM) {
        if subCategory != selectedSubCategory {
            selectedSubCategory = subCategory
        }
    }
}
extension SuperCategoryViewController: CategorySectionsViewDelegate{
    func openSectionView(_ section: HomeSectionVM) {
        let sectionViewController =  SectionSessionListViewController.instantiate(id: section.id, name: section.title, type: .homeSection)
        self.navigationController?.pushViewController(sectionViewController, animated: true)
    }
    
    func playSession(_ session: HomeSessionVM) {
        guard let sessionModel = session.session else { return }
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    func updateHeader(offset: CGPoint) {
        updateSummaryAlphaValue()
        updateTopOverlayViewAlphaValue()
        updateHeaderLayout()
    }
    
}
extension SuperCategoryViewController: CategorySessionsViewDelegate{
    
    func openSeriesView(seriesId: String, session: SessionModel) {
        let viewController = SeriesViewController.instantiate(seriesId: seriesId, seriesSession: session)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func playSession(_ session: CategorySessionVM) {
        guard let session = session.session else { return }
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: session), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    
    
}
extension SuperCategoryViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}
extension SuperCategoryViewController: TopTabBarHeaderViewDelegate{
    private func resetSessions(){
        sessionsView.sessions = []
    }
    func categoryTapped(index: Int) {
        resetSessions()
        let categoryTab = topTabBarItemsIds(rawValue: "\(index)")
        var categoryId: CategoryIds = .meditations
        
        switch categoryTab {
        case .meditations:
            categoryId = .meditations
            break
        case .myBody:
            categoryId = .myBody
            break
        case .mySoul:
            categoryId = .mySoul
            break
        default:
            break
        }
        self.category = SuperCategoryVM(id: categoryId, service: SessionServiceOffline(service: SessionServiceFactory.service()))
    }    
}
