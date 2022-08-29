//
//  SeriesViewController.swift
//  Tawazon
//
//  Created by mac on 25/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: ParallaxImageView!
    @IBOutlet weak var shareButton: CircularButton!
    @IBOutlet weak var favoriteButton: SessionFavoriteButton!
    @IBOutlet weak var backButton: CircularButton!
    @IBOutlet weak var seriesDetailsView: UIView!
    @IBOutlet weak var seriesProgressDetailsView: UIView!
    @IBOutlet weak var separatorView: GradientView!
    @IBOutlet weak var seriesTitleLabel: UILabel!
    @IBOutlet weak var seriesSubtitleLabel: UILabel!
    @IBOutlet weak var seriesProgressView: PlayerProgressView!
    @IBOutlet weak var seriesProgressLabel: UILabel!
    @IBOutlet weak var seriesSessionsTabel: UITableView!
    @IBOutlet weak var separatorDetailsView: GradientView!
    
    var isPlaying: Bool = AudioPlayerManager.shared.isPlaying()
    
    var previousCellCompletedSession: Bool = false
    var seriesId: String = ""
    var seriesVM: SeriesVM!
    
    
    var seriesSessionModel: SessionModel?
    
    var playerBar: MainPlayerBarView?
    
    var footerTitleString: String! = "seriesFooterTitle".localized
    var footerSubtitleString: String! = "seriesFooterSubtitle".localized
    
    var isPresented: Bool {
        if let nvc = navigationController {
            return nvc.viewControllers.firstIndex(of: self) == 0
        } else {
            return presentingViewController != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        initializeNotification()
        
        seriesVM = SeriesVM(service: SessionServiceFactory.service())
        fetchSeriesDetails()
        if AudioPlayerManager.shared.isPlaying() {
            self.showSessionPlayerBar()
        }
        TrackerManager.shared.sendOpenSeries(id: seriesId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundImageView.animate()
    }

    private func initialize(){
        view.backgroundColor = .tolopea
        
        backgroundImageView.backgroundColor = .tolopea
        backgroundImageView.contentMode = .scaleToFill
        
        separatorView.applyGradientColor(colors: [UIColor.tolopea.withAlphaComponent(0.0).cgColor, UIColor.tolopea.cgColor], startPoint: .top, endPoint: .bottom)
        separatorDetailsView.backgroundColor = .clear
        separatorDetailsView.applyGradientColor(colors: [UIColor.tolopea.cgColor, UIColor.tolopea.withAlphaComponent(0.0).cgColor], startPoint: .top, endPoint: .bottom)
        
        seriesDetailsView.backgroundColor = .tolopea
        
        shareButton.setImage(#imageLiteral(resourceName: "ShareSession.pdf"), for: .normal)
        
        backButton.layer.cornerRadius = backButton.frame.height/2
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.tintColor = UIColor.white
        let backImage = isModal() ?  #imageLiteral(resourceName: "Cancel.pdf") : #imageLiteral(resourceName: "BackArrow.pdf").flipIfNeeded
        backButton.setImage(backImage, for: .normal)
        
        seriesProgressDetailsView.layer.cornerRadius = 42
        seriesProgressDetailsView.backgroundColor = .cyprus.withAlphaComponent(0.44)
        
        seriesTitleLabel.font = .kohinoorSemiBold(ofSize: 20)
        seriesTitleLabel.textColor = .white
        seriesSubtitleLabel.layer.opacity = 0.6
        
        seriesSubtitleLabel.font = .kohinoorRegular(ofSize: 12)
        seriesSubtitleLabel.textColor = .white
        
        let seriesProgressText = NSMutableAttributedString()
        seriesProgressText.append(NSAttributedString(string: "1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]));
        seriesProgressText.append(NSAttributedString(string: "/4", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]))
        seriesProgressLabel.attributedText = seriesProgressText
        
        seriesSessionsTabel.backgroundColor = .clear
        seriesSessionsTabel.separatorStyle = .none
        
        seriesProgressView.withBase = true
    }
    
    private func fetchSeriesDetails(){
        if seriesId != ""{
            seriesVM.fetchSeries(id: seriesId){
                (error) in
                
                if error == nil{
                    self.seriesSessionsTabel.reloadData()
                    self.fillData()
                }
            }
        }
        
    }
    
    private func reloadData(){
        self.seriesSessionsTabel.reloadData()
        fillData()
    }
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSessionPlayerBar(_:)), name: NSNotification.Name.showSessionPlayerBar
            , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideSessionPlayerBar(_:)), name: NSNotification.Name.hideSessionPlayerBar
            , object: nil)
    }
    
    private func fillData(){
        seriesTitleLabel.text = seriesVM.details?.title
        seriesSubtitleLabel.text = seriesVM.details?.subtitle
        
        
        if let imageUrl = seriesVM.details?.image?.url {
            backgroundImageView.af.setImage(withURL: imageUrl)
        }
        
        
        let seriesProgressText = NSMutableAttributedString()
        seriesProgressText.append(NSAttributedString(string: "\(seriesVM.details?.completedItemsCount ?? 0)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]));
        seriesProgressText.append(NSAttributedString(string: "/\(seriesVM.details?.numberOfSessions ?? 1)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]))
        seriesProgressLabel.attributedText = seriesProgressText
        
        
        seriesProgressView.progress = CGFloat(seriesVM.details?.completedItemsCount ?? 0) / CGFloat(seriesVM.details!.numberOfSessions)
        
        footerTitleString = seriesVM.details?.footerTitle ?? footerTitleString
        footerSubtitleString = seriesVM.details?.footerSubtitle ?? footerSubtitleString
    
        setFavoriteButtonData()
    }
    
    private func setFavoriteButtonData() {
        favoriteButton.isFavorite = seriesVM?.details?.favorite ?? false
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if isPresented {
            self.dismiss(animated: true)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func favoriateButtonTapped(_ sender: SessionFavoriteButton) {
        sender.isFavorite = !sender.isFavorite
        if sender.isFavorite {
            sender.animate()
        }
        changeFavoriteStatus(favorite: sender.isFavorite)
    }
    
    private func  changeFavoriteStatus(favorite: Bool) {
        
        if favorite {
            seriesVM?.addToFavorite { [weak self] (error) in
                self?.setFavoriteButtonData()
            }
        } else {
            seriesVM?.removeFromFavorites { [weak self] (error) in
                self?.setFavoriteButtonData()
                
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        showShareSessionView()
    }
    
    private func showShareSessionView() {
        guard let session = seriesSessionModel else {
            return
        }
        
        let seriesSessionVM = SessionVM(service: SessionServiceFactory.service(), session: session)
        
        let shareViewController = SessionShareViewController.instantiate(session: seriesSessionVM)
        shareViewController.modalPresentationStyle = .custom
        shareViewController.transitioningDelegate = self
        self.present(shareViewController, animated: true, completion: nil)
    }
    
}


extension SeriesViewController {
    @objc func showSessionPlayerBar(_ notification: Notification) {
        showSessionPlayerBar()
    }
    
    @objc func hideSessionPlayerBar(_ notification: Notification) {
        let reloadView = notification.object as? Bool ?? true
        hideSessionPlayerBar()
        if let session = notification.object as? SessionVM {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
        if reloadView {
            reloadData()
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

extension SeriesViewController:  MainPlayerBarViewDelegate {
    
    func playerTapped() {
        guard let session = SessionPlayerMananger.shared.session else { return }
        openSessionPlayerViewController(session: session)
    }
    
    func openPremiumView(_ sender: MainPlayerBarView) {
        openPremiumViewController()
    }
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (seriesVM.sessions?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SeriesSessionHeaderTableViewCell.identifier) as! SeriesSessionHeaderTableViewCell
            cell.seriesDescriptionLabel.text = seriesVM.details?.content
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: SeriesSessionTableViewCell.identifier) as! SeriesSessionTableViewCell
        let session = seriesVM.sessions?[indexPath.row - 1]
        cell.session = session
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 144
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 144))
        
        let footerStack = UIStackView(frame: footer.frame)
        footerStack.axis = .vertical
        footerStack.alignment = .center
        footerStack.spacing = 3
        
        let separator = GradientView(frame: CGRect(x: 0, y: 0, width: 3, height: 60))
        separator.layer.cornerRadius = 1.5
        separator.applyGradientColor(colors: [UIColor.gulfBlue.withAlphaComponent(0).cgColor, UIColor.gulfBlue.cgColor], startPoint: .top, endPoint: .bottom)
        footerStack.addArrangedSubview(separator)
        
        let footerIcon = UIImageView()
        footerIcon.backgroundColor = .clear
        footerIcon.image = UIImage(named: "SeriesSessionTableFooterIcon")
        footerStack.addArrangedSubview(footerIcon)
        
        let footerTitle = UILabel()
        footerTitle.font = .kohinoorRegular(ofSize: 20)
        footerTitle.textColor = .white
        footerTitle.text = footerTitleString
        footerStack.addArrangedSubview(footerTitle)
        
        let footerSubtitle = UILabel()
        footerSubtitle.font = .kohinoorRegular(ofSize: 12)
        footerSubtitle.textColor = .white.withAlphaComponent(0.5)
        footerSubtitle.text = footerSubtitleString
        footerStack.addArrangedSubview(footerSubtitle)
        
        footer.addSubview(footerStack)
        return footer
    }
}

extension SeriesViewController: SeriesSessionDelegate{
    func setSessionDuration(session: SessionVM, duration: Int) {
        seriesVM.setCompletedSession(sessionId: session.id!, duration: duration ){
                (error) in
                if (error != nil) {
                    return
                }
            AudioPlayerManager.shared.stop(clearQueue: true)
            SessionPlayerMananger.shared.session = nil
            self.fetchSeriesDetails()
            }
    }
    
    func togglePlaySession(_ session: SessionVM) {
        SessionPlayerMananger.shared.session = session
        openSessionPlayerViewController(session: session)
    }
}
extension SeriesViewController{
    private func openSessionPlayerViewController(session: SessionVM ) {
    guard let sessionModel = session.session else { return }
    let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel), delegate: self)
    viewcontroller.modalPresentationStyle = .custom
    viewcontroller.transitioningDelegate = self
    self.present(viewcontroller, animated: true, completion: nil)
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

extension SeriesViewController: SessionPlayerDelegate {
func sessionStoped(_ session: SessionVM) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
        SessionRateViewController.show(session: session, from: self, force: false)
    }
}
}
extension SeriesViewController{
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if !AudioPlayerManager.shared.isPlaying() {
            reloadData()
        }
        
        return nil
    }
}

extension SeriesViewController {
    //TODO: add series to instantiate func parameters
    class func instantiate(seriesId: String, seriesSession: SessionModel) -> SeriesViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SeriesViewController.identifier) as! SeriesViewController
        viewController.seriesId = seriesId
        viewController.seriesSessionModel = seriesSession
        return viewController
    }
}
