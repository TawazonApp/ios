//
//  TodayActivityTawazonTalkTableViewCell.swift
//  Tawazon
//
//  Created by mac on 28/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TodayActivityTawazonTalkTableViewCell: UITableViewCell {

    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var trackingLineView: GradientView!
    @IBOutlet weak var trackingIndicatorImageView: UIImageView!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellPlayImageView: UIImageView!
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overlayView: GradientView!
    
    
    
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
        
        overlayView.applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.56).cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        overlayView.backgroundColor = .clear
        
        // cellView
        cellView.backgroundColor = .gulfBlue.withAlphaComponent(0.4)
        cellView.roundCorners(corners: .allCorners, radius: 24)
        cellView.layer.cornerRadius = 24
        cellView.clipsToBounds = true
        cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .left, endPoint: .right, andRoundCornersWithRadius: 24.0)
        
        cellTitleLabel.font = .munaFont(ofSize: 15)
        cellTitleLabel.textColor = .white
        cellTitleLabel.text = "TawazonTalkTodaySectionTitle".localized
        
        itemNameLabel.font = .munaBoldFont(ofSize: 24)
        itemNameLabel.textColor = .white
        itemNameLabel.numberOfLines = 0
        itemNameLabel.lineBreakMode = .byWordWrapping
        
        durationLabel.font = .munaFont(ofSize: 20)
        durationLabel.textColor = .mauve
        durationLabel.isHidden = true
        
        cellImageView.backgroundColor = .clear
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        
        cellPlayImageView.contentMode = .scaleAspectFill
        cellPlayImageView.image = UIImage(named: "TodayActivityTawazonTalkPlayImage")
        
        languageImageView.contentMode = .center
        languageImageView.clipsToBounds = false
        
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
        
        cellImageView.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: cellImageView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor).isActive = true
        loadingIndicator.center = cellImageView.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = section?.items?.first?.thumbnail?.url {
            cellImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
        
        if section?.completed ?? false{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
        }else{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageCurrent")
        }
        
        itemNameLabel.text = section?.items?.first?.title
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
