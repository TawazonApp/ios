//
//  SessionCommentsViewController.swift
//  Tawazon
//
//  Created by mac on 19/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class SessionCommentsViewController: UIViewController {

    @IBOutlet weak var headerBackgroundImage: UIImageView!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var horizontalDividerLabel: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
    
    var session: SessionVM!
    var commentsVM : CommentsVM!
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        commentsVM = CommentsVM(service: SessionServiceFactory.service())
        fetchData()
        TrackerManager.shared.sendOpenCommentsView(sessionId: session.id!, sessionName: session.name!)
    }
    
    private func initialize(){
        self.view.backgroundColor = .cyprus
        
        headerBackgroundImage.image = UIImage(named: "SessionCommentsHeaderView.pdf")
        headerBackgroundImage.contentMode = .scaleAspectFill
        
        viewTitleLabel.font = .munaBoldFont(ofSize: 24)
        viewTitleLabel.textColor = .white
        viewTitleLabel.text = "commentsViewTitle".localized
        
        dismissButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        dismissButton.tintColor = .white
        
        horizontalDividerLabel.backgroundColor = .white.withAlphaComponent(0.2)
        horizontalDividerLabel.text = ""
        
        commentsTable.backgroundColor = .clear
    }
    
    private func fetchData(){
        commentsVM.fetchComments(session: session.session!, completion: { (error) in
            
            if error == nil{
                self.fillData()
            }
        })
    }
    
    private func fillData(){
        commentsTable.reloadData()
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension SessionCommentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentsVM.comments?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as! CommentTableViewCell
        cell.comment = commentsVM.comments?.list[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.commentsTable.frame.width, height: 70))
        header.backgroundColor = self.view.backgroundColor
        
        let writeCommentButton = UIButton(type: .system)
        writeCommentButton.setTitle("writeCommentButtonTitle".localized, for: .normal)
        writeCommentButton.setImage(UIImage(named: "CommentsWriteAReview"), for: .normal)
        writeCommentButton.tintColor = .lightSlateBlueTwo
        writeCommentButton.titleLabel?.font = .munaBoldFont(ofSize: 18)
        writeCommentButton.addTarget(self, action: #selector(writeCommentButtonTapped), for: .touchUpInside)
        header.addSubview(writeCommentButton)
        
        writeCommentButton.translatesAutoresizingMaskIntoConstraints = false
        writeCommentButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20).isActive = true
        writeCommentButton.topAnchor.constraint(equalTo: header.topAnchor, constant: 0).isActive = true
        
        let writeCommentLabel = UILabel()
        writeCommentLabel.text = "writeCommentLabelText".localized
        writeCommentLabel.textColor = .white.withAlphaComponent(0.5)
        writeCommentLabel.font = .munaFont(ofSize: 15)
        header.addSubview(writeCommentLabel)
        
        writeCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        header.trailingAnchor.constraint(equalTo: writeCommentLabel.trailingAnchor, constant: 20).isActive = true
        writeCommentLabel.centerYAnchor.constraint(equalTo: writeCommentButton.centerYAnchor).isActive = true
        
        return header
    }
    
    @objc @IBAction func writeCommentButtonTapped(){
        UserDefaults.isAnonymousUser() ? showLoginPermissionAlert() : (session.isLock ? (UserDefaults.isPremium() ? showWriteCommentViewController() : showPremiumConfirmationAlert()) : showWriteCommentViewController())
    }
    
    private func showWriteCommentViewController(comment: CommentModel? = nil){
        let writeCommentViewController = WriteCommentViewController.instantiate(session: session, comment: comment)
        writeCommentViewController.delegate = self
        self.present(writeCommentViewController, animated: true, completion: nil)
    }
    
    private func showPremiumConfirmationAlert() {
        
        PermissionAlert.shared.show(type: PermissionAlertView.AlertType.premium, animated: true, actionHandler: {
            PermissionAlert.shared.hide(animated: true, completion: { [weak self] in
                self?.openPremiumViewController()
            })
        }, cancelHandler: {
            PermissionAlert.shared.hide(animated: true)
        })
//        PermissionAlert.
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

extension SessionCommentsViewController: CommentCellDelegate{
    func seeMoreTapped(comment: CommentModel) {
        let alert = UIAlertController(title: "commentRejectionReason".localized, message:comment.rejectionNote , preferredStyle: .alert, blurStyle: .dark)
         
        let okAction = UIAlertAction(title: "logoutConfirmAlertCancelButton".localized, style: .cancel) {_ in
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func editCommentTapped(comment: CommentModel) {
        showWriteCommentViewController(comment: comment)
    }
    
    
}

extension SessionCommentsViewController: WriteCommentDelegate{
    func commentSubmitted() {
        fetchData()
    }
    
    
}

extension SessionCommentsViewController {
    
    class func instantiate(session: SessionVM) -> SessionCommentsViewController {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SessionCommentsViewController.identifier) as! SessionCommentsViewController
        SessionPlayerMananger.shared.session = session
        viewController.session = session
        return viewController
    }
    
}
