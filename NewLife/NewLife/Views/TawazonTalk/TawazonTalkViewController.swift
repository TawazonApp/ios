//
//  TawazonTalkViewController.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TawazonTalkViewController: HandleErrorViewController {

    
    @IBOutlet weak var talkBackgroundImage: UIImageView!
    @IBOutlet weak var backButton: CircularButton!
    @IBOutlet weak var shareButton: CircularButton!
    
    @IBOutlet weak var backgroundColorView: GradientView!
    
    @IBOutlet weak var talkLogoImageView: UIImageView!
    @IBOutlet weak var mainTalkSessionView: TawazonTalkMainSessionView!
    
    @IBOutlet weak var talkItemsTable: UITableView!
    
    var tawazonTalkVM: TawazonTalkVM = TawazonTalkVM(service: TodayServiceCache.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        fetchData()
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
        talkLogoImageView.backgroundColor = .clear
        talkLogoImageView.image = Language.language == .english ? UIImage(named: "TawazonTalkLogoEn") : UIImage(named: "TawazonTalkLogoAr")
        
        mainTalkSessionView.backgroundColor = .clear
        mainTalkSessionView.layer.cornerRadius = 32
        mainTalkSessionView.clipsToBounds = true
        
        
        talkItemsTable.backgroundColor = .clear
        talkItemsTable.contentInset = UIEdgeInsets(top: mainTalkSessionView.frame.height / 2, left: 0, bottom: 0, right: 0)
        
    }
    private func fetchData(){
        tawazonTalkVM.getTawazonTalkDetails(Id: "7600"){ error in
            if let error = error{
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            self.fillData()
        }
    }
    
    private func fillData(){
        talkBackgroundImage.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        talkBackgroundImage.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: talkBackgroundImage.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: talkBackgroundImage.centerYAnchor).isActive = true
        loadingIndicator.center = talkBackgroundImage.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = tawazonTalkVM.image?.url {
            talkBackgroundImage.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
        
        mainTalkSessionView.session = tawazonTalkVM.mainItem
        mainTalkSessionView.color = tawazonTalkVM.paletteColor
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
    
    @IBAction func PlayButtonTapped(_ sender: UIButton) {
        if let sessionModel = tawazonTalkVM.mainItem{
            let session = HomeSessionVM(session: sessionModel)
            openSessionPlayerViewController(session: session)
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TawazonTalkViewController: TawazonTalkTableHorizontalSectionCellDelegate{
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

extension TawazonTalkViewController {
    
    class func instantiate() -> TawazonTalkViewController {
        let storyboard = UIStoryboard(name: "TodayActivity", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: TawazonTalkViewController.identifier) as! TawazonTalkViewController
        return viewController
    }
}
