//
//  TodayActivityFeelingSessionsTableViewCell.swift
//  Tawazon
//
//  Created by mac on 21/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol TodaySessionsCellDelegate: class {
    func playSession(_ sender: TodayActivityFeelingSessionsTableViewCell, session: HomeSessionVM)
    func openSeriesView(seriesId: String, session: SessionModel)
}

class TodayActivityFeelingSessionsTableViewCell: UITableViewCell {

    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var trackingLineView: GradientView!
    @IBOutlet weak var trackingIndicatorImageView: UIImageView!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var sessionsView: UIView!
    @IBOutlet weak var sessionsCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: TodaySessionsCellDelegate?
    
    var sectionVM: TodaySectionVM?{
        didSet{
            print("didSet")
            reloadData()
        }
    }
    private var collectionCellSpace: CGFloat = 16
    private var collectionCellWidth: CGFloat = 10
    private var collectionCellHeight: CGFloat = 10
    
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
        
        arrowImageView.image = UIImage(named: "TodayActivityLookAbove")
        arrowImageView.backgroundColor = .clear
        
        subtitleLabel.font = .munaBoldFont(ofSize: 20)
        subtitleLabel.textColor = .white
        
        noteLabel.font = .munaFont(ofSize: 15)
        noteLabel.textColor = .mauve
        noteLabel.numberOfLines = 0
        noteLabel.lineBreakMode = .byWordWrapping
        
        cellImageView.backgroundColor = .clear
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        
        //sessionView
        sessionsView.backgroundColor = .clear
        sessionsView.isHidden = true
        
        sessionsCollectionView.backgroundColor = .clear
        
        // trackingView
        trackingView.backgroundColor = .clear
        trackingLineView.applyGradientColor(colors: [UIColor.paleCornflowerBlue.cgColor, UIColor.paleCornflowerBlue.cgColor, UIColor.columbiaBlue.cgColor, UIColor.paleCornflowerBlue.withAlphaComponent(0.0).cgColor], startPoint: .top, endPoint: .center)
        trackingLineView.createDashedLine(from: CGPoint(x: 0, y: trackingLineView.bounds.height / 2.0), to: CGPoint(x: 0, y: trackingLineView.bounds.height), color: UIColor.columbiaBlue, strokeLength: 3, gapLength: 6, width: 1)
        trackingLineView.backgroundColor = .clear
        
        trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
        trackingIndicatorImageView.backgroundColor = .clear
        trackingIndicatorImageView.contentMode = .scaleAspectFill
    }
    
    private func reloadData(){
        if sectionVM?.sessions.count ?? 0 > 0{
            if sectionVM?.completed ?? false{
                trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
            }else{
                trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageCurrent")
            }
            
            calculateCollectionHeight()
            sessionsView.isHidden = false
            
            cellView.isHidden = true
            cellView.backgroundColor = .gulfBlue.withAlphaComponent(0.4)
            cellView.roundCorners(corners: .allCorners, radius: 24)
            cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .left, endPoint: .right, andRoundCornersWithRadius: 24.0)
            
            DispatchQueue.main.async { [weak self] in
                self?.sessionsCollectionView.reloadData()
                self?.sessionsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
            return
        }
        
        sessionsView.isHidden = true
        cellView.isHidden = false
        cellTitleLabel.text = sectionVM?.title
        subtitleLabel.text = sectionVM?.subTitle
        noteLabel.text = sectionVM?.content
        
        if let imageUrlString = sectionVM?.imageUrl, let imageUrl = imageUrlString.url{
            cellImageView.af.setImage(withURL: imageUrl)
        }
        
        if sectionVM?.completed ?? false{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageDone")
        }else{
            trackingIndicatorImageView.image = UIImage(named: "TodayActivityStageCurrent")
        }
    }

    private func calculateCollectionHeight() {
        let availableWidth = sessionsView.frame.width - (2 * collectionCellSpace)
        collectionCellWidth = availableWidth / 1.1
        collectionCellHeight = cellView.frame.height
        if (sectionVM?.sessions.count ?? 0) <= 1 {
            collectionCellWidth = availableWidth - 5
        }
        
        collectionHeightConstraint.constant = collectionCellHeight
        sessionsCollectionView.layoutIfNeeded()
        sessionsCollectionView.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension TodayActivityFeelingSessionsTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionVM?.sessions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodaySessionCollectionViewCell.identifier, for: indexPath) as! TodaySessionCollectionViewCell
        cell.session = sectionVM?.sessions[safe: indexPath.item]
        cell.cellView.roundCorners(corners: .allCorners, radius: 24)
        cell.cellView.layer.cornerRadius = 24.0
        cell.cellView.layer.masksToBounds = false
        cell.cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .topRight, endPoint: .bottom, andRoundCornersWithRadius: 24.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: collectionCellWidth, height: 164.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionCellSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionCellSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let session = sectionVM?.sessions[safe: indexPath.item] else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        cell?.pulsate()
        if session.session?.type == "series" {
            delegate?.openSeriesView(seriesId: session.session?.id ?? "", session: session.session!)
            return
        }
        delegate?.playSession(self, session: session)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let rtlHidden = scrollView.contentOffset.x > scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
//
//        let ltlHidden = scrollView.contentOffset.x < scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
//        
////        moreButton.isHidden = UIApplication.isRTL() ? rtlHidden : ltlHidden
//    }
}
