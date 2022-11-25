//
//  TodayActivityGeneralTableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TodayActivityGeneralTableViewCell: UITableViewCell {

    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var trackingLineView: GradientView!
    @IBOutlet weak var trackingIndicatorImageView: UIImageView!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    var section: TodaySectionVM?{
        didSet{
            reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }

    private func initialize(){
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        // cellView
        cellView.backgroundColor = .gulfBlue.withAlphaComponent(0.4)
        cellView.roundCorners(corners: .allCorners, radius: 24)
        cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .left, endPoint: .right, andRoundCornersWithRadius: 24.0)
        
        cellTitleLabel.font = .munaFont(ofSize: 15)
        cellTitleLabel.textColor = .white.withAlphaComponent(0.6)
        
        nameLabel.font = .munaBoldFont(ofSize: 20)
        nameLabel.textColor = .white
        
        durationLabel.font = .munaBoldFont(ofSize: 14)
        durationLabel.textColor = .mauve
        
        
        cellImageView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .bottomLeft, endPoint: .topRight, andRoundCornersWithRadius: 18)
        cellImageView.backgroundColor = .moodyBlue.withAlphaComponent(0.4)
        cellImageView.roundCorners(corners: .allCorners, radius: 18.0)
        cellImageView.contentMode = .center
        cellImageView.clipsToBounds = true
        
        // trackingView
        trackingView.backgroundColor = .clear
        trackingLineView.applyGradientColor(colors: [UIColor.paleCornflowerBlue.cgColor, UIColor.columbiaBlue.cgColor, UIColor.paleCornflowerBlue.cgColor], startPoint: .top, endPoint: .bottom)
        
        trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
        trackingIndicatorImageView.backgroundColor = .clear
        trackingIndicatorImageView.contentMode = .scaleAspectFill
    }
    
    private func reloadData(){
        cellTitleLabel.text = section?.title
        durationLabel.text = section?.sessions.first?.durationString
        if let imageUrlString = section?.iconUrl, let imageUrl = imageUrlString.url{
            cellImageView.af.setImage(withURL: imageUrl)
        }
        if section?.completed ?? false{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
        }else{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageCurrent")
        }
        if section?.style == .prepSession{
            nameLabel.text = section?.sessions.first?.name
            
        }else if section?.style == .feelingSelection{
            if !(section?.completed ?? true){
                nameLabel.text = section?.subTitle
            }else{
                cellTitleLabel.text = section?.titleCompletedState
                nameLabel.text = section?.items?.first?.title
                durationLabel.text = "update".localized
            }
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
