//
//  TawazonTalkViewController.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TawazonTalkViewController: HandleErrorViewController {

    @IBOutlet weak var talkScrollView: UIScrollView!
    @IBOutlet weak var talkView: UIView!
    @IBOutlet weak var talkBackgroundImage: UIImageView!
    @IBOutlet weak var backButton: CircularButton!
    @IBOutlet weak var shareButton: CircularButton!
    
    @IBOutlet weak var backgroundColorView: GradientView!
    
    @IBOutlet weak var talkLogoImageView: UIImageView!
    @IBOutlet weak var mainTalkSessionView: TawazonTalkMainSessionView!
    @IBOutlet weak var talkItemsTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var talkItemsTable: UITableView!
    
    var tawazonTalkVM: TawazonTalkVM = TawazonTalkVM(service: TodayServiceCache.shared)
    var talkItem: ItemVM?{
        didSet{
            fetchData()
        }
    }
    
    var playerBar: MainPlayerBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        initializeNotification()
        if AudioPlayerManager.shared.isPlaying() {
            self.showSessionPlayerBar()
        }
        
    }

    private func initialize(){
        self.view.backgroundColor = .cyprus
        
        talkBackgroundImage.backgroundColor = .clear
        talkBackgroundImage.contentMode = .scaleAspectFill
        
        backButton.backgroundColor = .black.withAlphaComponent(0.31)
        let backImage =  #imageLiteral(resourceName: "BackArrow.pdf").flipIfNeeded
        backButton.setImage(backImage, for: .normal)
        backButton.roundCorners(corners: .allCorners, radius: 24)
        backButton.tintColor = .white
        
        shareButton.setImage(#imageLiteral(resourceName: "ShareSession.pdf"), for: .normal)
        
        backgroundColorView.applyGradientColor(colors: [UIColor.mariner.cgColor, UIColor.chambray.cgColor, UIColor.cyprus.cgColor], startPoint: .top, endPoint: .bottom)
        
        talkLogoImageView.contentMode = .center
        talkLogoImageView.clipsToBounds = false
        talkLogoImageView.backgroundColor = .clear
        talkLogoImageView.image = Language.language == .english ? UIImage(named: "TawazonTalkLogoEn") : UIImage(named: "TawazonTalkLogoAr")
        
        talkItemsTable.backgroundColor = .clear
        talkItemsTable.contentInset = UIEdgeInsets(top: mainTalkSessionView.frame.height / 2, left: 0, bottom: 0, right: 0)
        initializeValues()
    }
    private func initializeValues(){
        talkBackgroundImage.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        talkBackgroundImage.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: talkBackgroundImage.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: talkBackgroundImage.centerYAnchor).isActive = true
        loadingIndicator.center = talkBackgroundImage.center
        loadingIndicator.startAnimating()

        if let imageUrl = talkItem?.image?.url {
            talkBackgroundImage.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })

        }
        mainTalkSessionView.talkItem = talkItem
        mainTalkSessionView.delegate = self
        if let talkItem = talkItem{
            let values = ["talkTitle": talkItem.title ?? "", "talkId": talkItem.id] as [String : Any]
            TrackerManager.shared.sendEvent(name: GeneralCustomEvents.tawazonTalkOpened, payload: values)
        }
    }
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSessionPlayerBar(_:)), name: NSNotification.Name.showSessionPlayerBar
            , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideSessionPlayerBar(_:)), name: NSNotification.Name.hideSessionPlayerBar
            , object: nil)
    }
    
    private func fetchData(){
        if let talkId = talkItem?.id{
            tawazonTalkVM.getTawazonTalkDetails(Id: talkId){ error in
                if let error = error{
                    self.showErrorMessage(message: error.localizedDescription)
                    return
                }
                self.fillData()
            }
        }
    }
    
    private func fillData(){
//        talkBackgroundImage.image = nil
//        let loadingIndicator = UIActivityIndicatorView(style: .white)
//        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
//        talkBackgroundImage.addSubview(loadingIndicator)
//        loadingIndicator.centerXAnchor.constraint(equalTo: talkBackgroundImage.centerXAnchor).isActive = true
//        loadingIndicator.centerYAnchor.constraint(equalTo: talkBackgroundImage.centerYAnchor).isActive = true
//        loadingIndicator.center = talkBackgroundImage.center
//        loadingIndicator.startAnimating()
//
//        if let imageUrl = tawazonTalkVM.image?.url {
//            talkBackgroundImage.af.setImage(withURL: imageUrl, completion:  { (_) in
//                loadingIndicator.stopAnimating()
//                loadingIndicator.removeFromSuperview()
//            })
//
//        }
        mainTalkSessionView.tawazonTalkVM = tawazonTalkVM
        mainTalkSessionView.delegate = self

        talkItemsTable.layoutIfNeeded()
        talkView.layoutIfNeeded()
        talkScrollView.layoutIfNeeded()
        mainTalkSessionView.layoutIfNeeded()
        talkItemsTable.reloadData()
    }
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        showShareSessionView()
    }
    
    private func showShareSessionView() {
        guard let session = tawazonTalkVM.mainItem else {
            return
        }

        let tawazonTalkMainSessionVM = SessionVM(service: SessionServiceFactory.service(), session: session)

        let shareViewController = SessionShareViewController.instantiate(session: tawazonTalkMainSessionVM)
        shareViewController.modalPresentationStyle = .custom
        shareViewController.transitioningDelegate = self
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension TawazonTalkViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tawazonTalkVM.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TawazonTalkHorizontalListTableViewCell.identifier) as! TawazonTalkHorizontalListTableViewCell
        cell.data = tawazonTalkVM.sections?[indexPath.row]
        cell.delegate = self
        if indexPath.row == (tawazonTalkVM.sections?.count ?? 0) - 1{
            cell.deviderView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TawazonTalkViewController: TawazonTalkTableHorizontalSectionCellDelegate{
    func updateCollectionHieght() {
        talkItemsTable.beginUpdates()
        
        var totalSessions = 0
        tawazonTalkVM.sections?.forEach(){
            section in
            totalSessions += section.sessions.count
        }
        let newTableHeight = (320.0 * Double(totalSessions / 2).rounded(.up)) + (totalSessions % 2 == 0 ? 100 : 320)
        talkItemsTableHeightConstraint.constant = CGFloat(newTableHeight)
        talkScrollView.contentSize = CGSize(width: talkScrollView.contentSize.width, height: talkView.frame.height)
        
        talkItemsTable.endUpdates()
    }
    
    func playSession(_ sender: TawazonTalkHorizontalListTableViewCell, session: HomeSessionVM) {
        openSessionPlayerViewController(session: session)
    }
    
    func sectionTapped(_ sender: TawazonTalkHorizontalListTableViewCell, section: HomeSectionVM?) {
        
    }
    
    func openSeriesView(seriesId: String, session: SessionModel) {
        let viewController = SeriesViewController.instantiate(seriesId: seriesId, seriesSession: session)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    private func openSessionPlayerViewController(session: HomeSessionVM) {
        guard let sessionModel = session.session else { return }
        
        let values = ["sessionTitle": sessionModel.name, "sessionId": sessionModel.id] as [String : Any]
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.tawazonTalkPlaySession, payload: values)
        
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
}

extension TawazonTalkViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}

extension TawazonTalkViewController: MainSessionViewDelegate {
    func playSession(session: SessionModel) {
        let sessionVM = HomeSessionVM(session: session)
        openSessionPlayerViewController(session: sessionVM)
    }
}

extension TawazonTalkViewController {
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

extension TawazonTalkViewController:  MainPlayerBarViewDelegate {
    
    func playerTapped() {
        guard let sessionModel = SessionPlayerMananger.shared.session?.session else { return }
        let sessionVM = HomeSessionVM(session: sessionModel)
        openSessionPlayerViewController(session: sessionVM)
    }
    
    func openPremiumView(_ sender: MainPlayerBarView) {
        openPremiumViewController()
    }
    private func openPremiumViewController() {
        guard self.presentedViewController == nil else {
            return
        }
        let viewcontroller = GeneralPremiumViewController.instantiate(nextView: .dimiss, fromView: .section)
        
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        viewcontroller.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension TawazonTalkViewController {
    
    class func instantiate(talkItem: ItemVM) -> TawazonTalkViewController {
        let storyboard = UIStoryboard(name: "TodayActivity", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: TawazonTalkViewController.identifier) as! TawazonTalkViewController
        viewController.talkItem = talkItem
        return viewController
    }
}

