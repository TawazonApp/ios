//
//  TodayActivityQuoteTableViewCell.swift
//  Tawazon
//
//  Created by mac on 21/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TodayActivityQuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var trackingLineView: GradientView!
    @IBOutlet weak var trackingIndicatorImageView: UIImageView!
    
    @IBOutlet weak var cellView: GradientView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var autherLabel: UILabel!
    @IBOutlet weak var startQuoteImageView: UIImageView!
    @IBOutlet weak var endQuoteImageView: UIImageView!
    
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
        cellView.backgroundColor = .clear
        cellView.applyGradientColor(colors: [UIColor.hanPurple.withAlphaComponent(0.4).cgColor, UIColor.lightSlateBlue.withAlphaComponent(0.4).cgColor, UIColor.columbiaBlue.withAlphaComponent(0.4).cgColor], startPoint: .topRight, endPoint: .bottomLeft)
        cellView.roundCorners(corners: .allCorners, radius: 24)
        cellView.layer.cornerRadius = 24
        cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .left, endPoint: .right, andRoundCornersWithRadius: 24.0)
        
        quoteLabel.font = .munaBoldFont(ofSize: 20)
        quoteLabel.textColor = .white
        quoteLabel.textAlignment = .center
        quoteLabel.numberOfLines = 0
        quoteLabel.lineBreakMode = .byWordWrapping
        
        autherLabel.font = .munaFont(ofSize: 15)
        autherLabel.textColor = .white
        
        startQuoteImageView.contentMode = .scaleAspectFill
        startQuoteImageView.clipsToBounds = true
        startQuoteImageView.backgroundColor = .clear
        startQuoteImageView.image = UIImage(named:"DailyActivityQuoteStart")?.flipIfNeeded
        
        endQuoteImageView.contentMode = .scaleAspectFill
        endQuoteImageView.clipsToBounds = true
        endQuoteImageView.backgroundColor = .clear
        endQuoteImageView.image = UIImage(named:"DailyActivityQuoteEnd")?.flipIfNeeded
        
        // trackingView
        trackingView.backgroundColor = .clear
        trackingLineView.createDashedLine(from: CGPoint(x: 0, y: 6), to: CGPoint(x: 0, y: trackingLineView.bounds.height/2), color: UIColor.columbiaBlue, strokeLength: 3, gapLength: 6, width: 1)
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
        if let quote = section?.items?.first{
            quoteLabel.text = quote.content
            autherLabel.text = quote.authorName
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
