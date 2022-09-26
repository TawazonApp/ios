//
//  CommentTableViewCell.swift
//  Tawazon
//
//  Created by mac on 19/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol CommentCellDelegate: class{
    func seeMoreTapped(comment: CommentModel)
    func editCommentTapped(comment: CommentModel)
}
class CommentTableViewCell: UITableViewCell {

    enum CommentStatus:String {
        case active = "active"
        case pending = "pending"
        case rejected = "rejected"
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    @IBOutlet weak var commentStatusLabel: PaddingLabel!
    @IBOutlet weak var editCommentButton: UIButton!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    
    var comment : CommentModel?{
        didSet{
            fillData()
        }
    }
    
    var delegate: CommentCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Initialize()
    }

    override func layoutSubviews() {
          super.layoutSubviews()
          //set the values for top,left,bottom,right margins
          let margins = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
          contentView.frame = contentView.frame.inset(by: margins)
          contentView.layer.cornerRadius = 16
    }
    
    private func Initialize(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .elephant
        contentView.layer.cornerRadius = 16
        
        ratingView.backgroundColor = .clear
        ratingView.maximumValue = 5
        ratingView.minimumValue = 0
        ratingView.value = 5
        ratingView.filledStarImage = #imageLiteral(resourceName: "FillRateStar.pdf")
        ratingView.emptyStarImage = #imageLiteral(resourceName: "EmptyRateStar.pdf")
        ratingView.isUserInteractionEnabled = false
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.image = UIImage(named: "CommentProfilePicture")
        profileImageView.contentMode = .scaleAspectFill
        
        screenNameLabel.font = .munaFont(ofSize: 15)
        screenNameLabel.textColor = .white.withAlphaComponent(0.72)
        
        commentDateLabel.font = .munaFont(ofSize: 12)
        commentDateLabel.textColor = .white.withAlphaComponent(0.56)
        
        commentBodyLabel.font = .munaFont(ofSize: 18)
        commentBodyLabel.textColor = .white
        commentBodyLabel.numberOfLines = 100
        commentBodyLabel.lineBreakMode = .byWordWrapping
        
        commentStatusLabel.layer.cornerRadius = 12
        commentStatusLabel.font = .munaFont(ofSize: 15)
        commentStatusLabel.isHidden = true
        commentStatusLabel.textAlignment = .center
        commentStatusLabel.topInset = 10
        commentStatusLabel.bottomInset = 10
        commentStatusLabel.leftInset = 10
        commentStatusLabel.rightInset = 10
        commentStatusLabel.layer.cornerRadius = 12
        commentStatusLabel.layer.masksToBounds = true
        
        seeMoreButton.setTitle("seeMoreCommentText".localized, for: .normal)
        seeMoreButton.titleLabel?.font = .munaBoldFont(ofSize: 15)
        seeMoreButton.tintColor = .white
        seeMoreButton.addTarget(self, action: #selector(seeMoreTapped), for: .touchUpInside)
        seeMoreButton.isHidden = true
        
        editCommentButton.setTitle("seeMoreCommentText".localized, for: .normal)
        editCommentButton.titleLabel?.font = .munaBoldFont(ofSize: 15)
        editCommentButton.tintColor = .white.withAlphaComponent(0.5)
        if #available(iOS 13.0, *) {
            editCommentButton.setImage(UIImage(systemName: "pencil")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        editCommentButton.addTarget(self, action: #selector(editCommentTapped), for: .touchUpInside)
        editCommentButton.isHidden = true
    }
    
    private func fillData(){
        if comment?.rating == 0{
            ratingView.isHidden = true
        }
        ratingView.value = CGFloat(comment?.rating ?? 0)
        
        if(!(comment?.user.image?.isEmptyWithTrim ?? true)){
            profileImageView.af.setImage(withURL: comment!.user.image!.url!)
        }
        
        
        screenNameLabel.text = comment?.user.name
        
        commentDateLabel.text = comment?.createdAtDiffForHumans
        
        commentBodyLabel.text = comment?.content
        
        if(comment?.user.id == UserDefaults.userId()){
            commentStatusLabel.isHidden = false
            commentStatusLabel.text = comment?.status
            switch comment?.status{
            case CommentStatus.active.rawValue:
                commentStatusLabel.textColor = .screaminGreen
                commentStatusLabel.backgroundColor = .aquamarine.withAlphaComponent(0.2)
                break
            case CommentStatus.pending.rawValue:
                commentStatusLabel.textColor = .babyBlue
                commentStatusLabel.backgroundColor = .mayaBlueTwo.withAlphaComponent(0.2)
//                editCommentButton.isHidden = false
                break
            case CommentStatus.rejected.rawValue:
                commentStatusLabel.textColor = .bittersweet
                commentStatusLabel.backgroundColor = .burntSienna.withAlphaComponent(0.2)
                seeMoreButton.isHidden = false
                break
            default:
                commentStatusLabel.textColor = .white
                commentStatusLabel.backgroundColor = .white.withAlphaComponent(0.2)
                break
            }
        }
    }
    
    @objc @IBAction func seeMoreTapped(_ sender: Any) {
        delegate.seeMoreTapped(comment: comment!)
    }
    
    @objc @IBAction func editCommentTapped(_ sender: Any) {
        delegate.editCommentTapped(comment: comment!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
