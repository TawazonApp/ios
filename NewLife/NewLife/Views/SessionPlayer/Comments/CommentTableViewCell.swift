//
//  CommentTableViewCell.swift
//  Tawazon
//
//  Created by mac on 19/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    @IBOutlet weak var commentStatusLabel: UILabel!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    
    var comment : CommentModel?{
        didSet{
            fillData()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Initialize()
    }

    override func layoutSubviews() {
          super.layoutSubviews()
          //set the values for top,left,bottom,right margins
          let margins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        screenNameLabel.font = .munaFont(ofSize: 15)
        screenNameLabel.textColor = .white.withAlphaComponent(0.72)
        
        commentDateLabel.font = .munaFont(ofSize: 12)
        commentDateLabel.textColor = .white.withAlphaComponent(0.56)
        
        commentBodyLabel.font = .munaFont(ofSize: 18)
        commentBodyLabel.textColor = .white
        commentBodyLabel.numberOfLines = 0
        commentBodyLabel.lineBreakMode = .byWordWrapping
        commentBodyLabel.textAlignment = .justified
        
        commentStatusLabel.layer.cornerRadius = 12
        commentStatusLabel.font = .munaFont(ofSize: 15)
        
    }
    
    private func fillData(){
        ratingView.value = CGFloat(comment?.rating ?? 0)
        
        profileImageView.image = UIImage(named: "")
        
        screenNameLabel.text = comment?.user.name
        
        commentDateLabel.text = comment?.createdAtDiffForHumans
        
        commentBodyLabel.text = comment?.content
        
        commentStatusLabel.text = comment?.status
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
