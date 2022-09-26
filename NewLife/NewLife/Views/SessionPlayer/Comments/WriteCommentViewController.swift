//
//  WriteCommentViewController.swift
//  Tawazon
//
//  Created by mac on 25/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
protocol WriteCommentDelegate: class{
    func commentSubmitted()
}
class WriteCommentViewController: UIViewController {

    @IBOutlet weak var headerBackgroundImage: UIImageView!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var horizontalDividerLabel: UILabel!
    @IBOutlet weak var commentText: UITextView!
    var ratingView: SwiftyStarRatingView!
    
    var session: SessionVM!
    var commentsVM : CommentsVM!
    var commentModel: CommentModel!
    var delegate: WriteCommentDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        commentsVM = CommentsVM(service: SessionServiceFactory.service())
        if commentModel != nil {
            fillData()
        }
        TrackerManager.shared.sendOpenWriteCommentView(sessionId: session.id!, sessionName: session.name!)
    }
    
    private func initialize(){
        self.view.backgroundColor = .cyprus
        
        headerBackgroundImage.image = UIImage(named: "SessionCommentsHeaderView.pdf")
        headerBackgroundImage.contentMode = .scaleAspectFill
        
        viewTitleLabel.font = .munaBoldFont(ofSize: 24)
        viewTitleLabel.textColor = .white
        viewTitleLabel.text = "writeCommentViewTitle".localized
        
        dismissButton.setTitle("dismissWriteCommentButtonTitle".localized, for: .normal)
        dismissButton.tintColor = .lightSlateBlueTwo
        
        addCommentButton.setTitle("addCommentButtonTitle".localized, for: .normal)
        addCommentButton.tintColor = .lightSlateBlueTwo
        
        horizontalDividerLabel.backgroundColor = .white.withAlphaComponent(0.2)
        horizontalDividerLabel.text = ""
        
        commentText.backgroundColor = .clear
        commentText.text = "commentPlaceholder".localized
        commentText.textColor = .white.withAlphaComponent(0.5)
        commentText.font = .munaBoldFont(ofSize: 20)
        let ratingKeyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 62))
        ratingKeyboardView.backgroundColor = self.view.backgroundColor
        let divider = UILabel(frame: CGRect(x: 0, y: 0, width: ratingKeyboardView.frame.width, height: 1))
        divider.backgroundColor = .white.withAlphaComponent(0.2)
        divider.text = ""
        ratingKeyboardView.addSubview(divider)
        let ratingTitleLabel = UILabel()
        ratingTitleLabel.text = "ratingTitleLabelText".localized
        ratingTitleLabel.font = .munaFont(ofSize: 18)
        ratingTitleLabel.textColor = .white
        ratingKeyboardView.addSubview(ratingTitleLabel)
        ratingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingTitleLabel.centerYAnchor.constraint(equalTo: ratingKeyboardView.centerYAnchor).isActive = true
        ratingTitleLabel.leadingAnchor.constraint(equalTo: ratingKeyboardView.leadingAnchor, constant: 20).isActive = true
        ratingView =  SwiftyStarRatingView()
        ratingView.backgroundColor = .clear
        ratingView.maximumValue = 5
        ratingView.minimumValue = 0
        ratingView.value = 5
        ratingView.filledStarImage = #imageLiteral(resourceName: "FillRateStar.pdf")
        ratingView.emptyStarImage = #imageLiteral(resourceName: "EmptyRateStar.pdf")
        ratingKeyboardView.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingKeyboardView.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: 20).isActive = true
        ratingView.centerYAnchor.constraint(equalTo: ratingKeyboardView.centerYAnchor).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        commentText.inputAccessoryView = ratingKeyboardView
        
    }
    private func fillData(){
        commentText.text = commentModel.content
        ratingView.value = CGFloat(commentModel.rating ?? 0)
        addCommentButton.setTitle("updateCommentButtonTitle".localized, for: .normal)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        TrackerManager.shared.sendCancelSubmitWriteComment(sessionId: session.id!, sessionName: session.name!)
        self.dismiss(animated: true)
    }
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        TrackerManager.shared.sendSubmitWriteComment(sessionId: session.id!, sessionName: session.name!)
        if let comment = commentModel{
            commentsVM.updateComment(comment: comment, content: commentText.text, rating: Int(ratingView.value), completion: {
                (error) in
                self.delegate.commentSubmitted()
                self.dismiss(animated: true)
            })
            return
        }
        if !commentText.text!.isEmpty && commentText.text! != "commentPlaceholder".localized{
            commentsVM.addComment(session: session.session!, content: commentText.text, rating: Int(ratingView.value), completion: {
                (error) in
                self.delegate.commentSubmitted()
                self.dismiss(animated: true)
            })
        }
    }
}

extension WriteCommentViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if !commentText.text!.isEmpty && commentText.text! == "commentPlaceholder".localized {
            commentText.text = ""
            commentText.textColor = UIColor.white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
    
        if commentText.text.isEmpty {
            commentText.text = "commentPlaceholder".localized
            commentText.textColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
}

extension WriteCommentViewController {
    
    class func instantiate(session: SessionVM, comment: CommentModel? = nil) -> WriteCommentViewController {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: WriteCommentViewController.identifier) as! WriteCommentViewController
        viewController.session = session
        viewController.commentModel = comment
        return viewController
    }
    
}
