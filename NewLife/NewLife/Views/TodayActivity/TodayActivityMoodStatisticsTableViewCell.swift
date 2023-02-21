//
//  TodayActivityMoodStatisticsTableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/02/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class TodayActivityMoodStatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var trackingLineView: GradientView!
    @IBOutlet weak var trackingIndicatorImageView: UIImageView!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellSubtitleLabel: UILabel!
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViewsBorders()
    }

    private func initialize(){
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        // cellView
        cellView.backgroundColor = .gulfBlue.withAlphaComponent(0.4)
        cellView.roundCorners(corners: .allCorners, radius: 24)
        cellView.layer.cornerRadius = 24
        cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .left, endPoint: .right, andRoundCornersWithRadius: 24.0)
        
        cellTitleLabel.font = .munaFont(ofSize: 15)
        cellTitleLabel.textColor = .white.withAlphaComponent(0.6)
        
        cellSubtitleLabel.font = .munaBoldFont(ofSize: 20)
        cellSubtitleLabel.textColor = .white
        
        cellImageView.backgroundColor = .clear
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = false
        cellImageView.image = UIImage(named: "TodayActivityMoodStats")
        
        // trackingView
        trackingView.backgroundColor = .clear
        trackingLineView.createDashedLine(from: CGPoint(x: 0, y: 6), to: CGPoint(x: 0, y: trackingLineView.bounds.height), color: UIColor.columbiaBlue, strokeLength: 3, gapLength: 6, width: 1)
        trackingLineView.backgroundColor = .clear
        
        trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
        trackingIndicatorImageView.backgroundColor = .clear
        trackingIndicatorImageView.contentMode = .scaleAspectFill
    }
    
    private func updateViewsBorders(){
        cellView.layoutIfNeeded()
        cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .left, endPoint: .right, andRoundCornersWithRadius: 24.0)
    }
    
    private func reloadData(){
        cellTitleLabel.text = section?.title
        cellSubtitleLabel.text = section?.subTitle
        if let imageUrlString = section?.iconUrl, let imageUrl = imageUrlString.url{
            cellImageView.af.setImage(withURL: imageUrl)
        }
        if section?.completed ?? false{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
        }else{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageCurrent")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
