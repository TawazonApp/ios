//
//  TodayActivityViewController.swift
//  Tawazon
//
//  Created by mac on 20/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TodayActivityViewController: SoundEffectsPresenterViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var dailyTitleLabel: UILabel!
    @IBOutlet weak var tableGradientHeader: GradientView!
    @IBOutlet weak var dailyActivitySectionsTable: UITableView!
    
    lazy var todayVM: TodayVM = TodayVM(service: TodayServiceCache.shared)
    
    var sections : [[String:Any]] = [
        [
            "type" : "prepSession",
            "title" : "الجلسة التحضيرية اليومية",
            "name":"التنفس وتأمل الضوء",
            "duration" : "2:00",
            "image" : "https://tawazonapp.com/assets/tawazon-icons/pngs/preSession.png"
        ],
        [
            "type" : "feelings",
            "title" : "أخبرنا كيف تشعر اليوم؟",
            "name": "سجّل مزاجك",
            "duration" : "",
            "image" : "https://tawazonapp.com/assets/tawazon-icons/pngs/mood.png"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        todayVM = TodayVM(service: TodayServiceCache.shared)
        fetchTodaySections()
    }
    


    private func initialize(){
        self.view.backgroundColor = .darkIndigoTwo
        
        headerView.backgroundColor = .clear
        
        headerImageView.backgroundColor = .clear
        headerImageView.image = UIImage(named: "todayActivityHeader")
        headerImageView.contentMode = .scaleAspectFill
        
        moreButton.setImage(#imageLiteral(resourceName: "More.pdf"), for: .normal)
        moreButton.tintColor = UIColor.white
        moreButton.layer.cornerRadius = moreButton.frame.height/2
        moreButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        greetingsLabel.font = .munaFont(ofSize: 18)
        greetingsLabel.textColor = .white
        let greetingsText = NSMutableAttributedString()
        greetingsText.append(NSAttributedString(string: getGreetingsText().localized, attributes: [NSAttributedString.Key.font: UIFont.munaFont(ofSize: 18)]));
        greetingsText.append(NSAttributedString(string: todayVM.userName, attributes: [NSAttributedString.Key.font: UIFont.munaBoldFont(ofSize: 18)]))
        greetingsLabel.attributedText = greetingsText
        
        dailyTitleLabel.font = .munaBoldFont(ofSize: 28)
        dailyTitleLabel.textColor = .white
        dailyTitleLabel.text = "dailyTitleLabel".localized
        
        tableGradientHeader.applyGradientColor(colors: [UIColor.darkIndigoTwo.cgColor, UIColor.darkIndigoTwo.withAlphaComponent(0.0).cgColor], startPoint: .top, endPoint: .bottom)
        
        dailyActivitySectionsTable.backgroundColor = .clear
        dailyActivitySectionsTable.separatorStyle = .none
        dailyActivitySectionsTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 128, right: 0)
    }
    
    private func getGreetingsText() -> String{
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12 : return "morning"
        case 12 : return "noon"
        case 13..<17 : return "afternoon"
        case 17..<22 : return "evening"
        default: return "hello"
        }
    }
    
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fetchTodaySections()
        return nil
    }
    
    private func fetchTodaySections() {
        todayVM.getTodaySections { [weak self] (error) in
            self?.reloadData()
            if let error = error {
                self?.showErrorMessage(message: error.localizedDescription)
            }
            print("TODAYVM: \(self?.todayVM.sections?[2].completed)")
        }
    }
    
    private func openMoreViewController() {
        let viewcontroller = MoreViewController.instantiate()
        let navigationController = NavigationController.init(rootViewController: viewcontroller)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        openMoreViewController()
    }
    
    private func reloadData() {
        dailyActivitySectionsTable.reloadData()
    }
}

extension TodayActivityViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayVM.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if todayVM.sections?[indexPath.row].style == .prepSession || todayVM.sections?[indexPath.row].style == .feelingSelection{
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: TodayActivityGeneralTableViewCell.identifier) as! TodayActivityGeneralTableViewCell
            sectionCell.section = todayVM.sections?[indexPath.row]
            cell = sectionCell
        }else if todayVM.sections?[indexPath.row].style == .userFeelingSessions{
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: TodayActivityFeelingSessionsTableViewCell.identifier) as! TodayActivityFeelingSessionsTableViewCell
            sectionCell.sectionVM = todayVM.sections?[indexPath.row]
            sectionCell.delegate = self
            cell = sectionCell
        }else if todayVM.sections?[indexPath.row].style == .singleQuote{
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: TodayActivityQuoteTableViewCell.identifier) as! TodayActivityQuoteTableViewCell
            sectionCell.section = todayVM.sections?[indexPath.row]
            cell = sectionCell
        }else{
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: TodayActivityGeneralTableViewCell.identifier) as! TodayActivityGeneralTableViewCell
            sectionCell.section = todayVM.sections?[indexPath.row]
            cell = sectionCell
        }
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if RemoteConfigManager.shared.bool(forKey: .dailyActivityLockNextStep){
            if indexPath.row != 0{
                let prevSection = todayVM.sections?[indexPath.row - 1]
                if !(prevSection?.completed ?? true){
                    showCompletePreviousStepAlert(for: indexPath)
                    return
                }
            }
        }
        
        let section = todayVM.sections?[indexPath.row]
        switch section?.style {
        case .prepSession:
            if let sessionModel = section?.sessions.first?.session{
                openPrepSessionPlayerVC(session: sessionModel)
            }
        case .feelingSelection:
            openFeelingsVC()
        case .userFeelingSessions:
            print("sessionsList")
        case .singleQuote:
            quoteTapped(quoteId: section?.items?.first?.id ?? "")
        case .none:
            print("none")
        }
    }
    
    private func showCompletePreviousStepAlert(for indexPath: IndexPath) {
        
        PermissionAlert.shared.show(type: PermissionAlertView.AlertType.completeTodayActivityStep, animated: true, actionHandler: nil, cancelHandler: {
            PermissionAlert.shared.hide(animated: true)
        })
    }
    
    private func openPrepSessionPlayerVC(session: SessionModel){
        SessionPlayerMananger.shared.session = SessionVM(service: SessionServiceFactory.service(), session: session)
        let viewController = PreparationSessionPlayerViewController.instantiate(from: .todayActivity)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func openFeelingsVC(){
        let viewController = LandingFeelingsViewController.instantiate(skipped: false, from: .todayActivity)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func quoteTapped(quoteId: String){
        todayVM.setTodayQuoteViewed(quoteId: quoteId){ error in
            self.reloadData()
        }
    }
}
extension TodayActivityViewController: TodaySessionsCellDelegate{
    func playSession(_ sender: TodayActivityFeelingSessionsTableViewCell, session: HomeSessionVM) {
        playSession(session)
    }
    
    func openSeriesView(seriesId: String, session: SessionModel) {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SeriesViewController.identifier) as! SeriesViewController
        viewController.seriesId = seriesId
        viewController.seriesSessionModel = session
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func playSession(_ session: HomeSessionVM) {
        guard let sessionModel = session.session else { return }
        let viewcontroller = DetailedSessionPlayerViewController.instantiate(session: SessionVM(service: SessionServiceFactory.service(), session: sessionModel), delegate: self)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
}
extension TodayActivityViewController: SessionPlayerDelegate {
    func sessionStoped(_ session: SessionVM) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            SessionRateViewController.show(session: session, from: self, force: false)
        }
    }
}
