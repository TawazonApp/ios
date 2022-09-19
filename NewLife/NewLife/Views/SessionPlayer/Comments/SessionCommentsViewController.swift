//
//  SessionCommentsViewController.swift
//  Tawazon
//
//  Created by mac on 19/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

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
                print("COUNTING: \(self.commentsVM.comments?.list.count)")
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
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
