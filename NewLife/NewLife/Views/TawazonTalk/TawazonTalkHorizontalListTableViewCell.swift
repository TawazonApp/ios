//
//  TawazonTalkHorizontalListTableViewCell.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
protocol TawazonTalkTableHorizontalSectionCellDelegate: class {
    func playSession(_ sender: TawazonTalkHorizontalListTableViewCell, session: HomeSessionVM)
    func sectionTapped(_ sender: TawazonTalkHorizontalListTableViewCell, section: HomeSectionVM?)
    func openSeriesView(seriesId: String, session: SessionModel)
    func updateCollectionHieght()
}
class TawazonTalkHorizontalListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sessionsCollection: SelfSizingCollectionView!
    @IBOutlet weak var deviderView: UIView!
    @IBOutlet weak var sessionsCollectionHeightConstraint: NSLayoutConstraint!
    var data: TawazonTalkSectionVM? {
        didSet {
            reloadData()
        }
    }
    var delegate: TawazonTalkTableHorizontalSectionCellDelegate?
    private var collectionCellSpace: CGFloat = 17
    private var collectionCellWidth: CGFloat = 160
    private var collectionCellHeight: CGFloat = 216
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func initialize(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        titleLabel.font = .munaBoldFont(ofSize: 24)
        titleLabel.textColor = .white
        
        sessionsCollection.backgroundColor = .clear
        
        deviderView.backgroundColor = .white.withAlphaComponent(0.28)
    }
    
    private func reloadData(){
        titleLabel.text = data?.title
        
        DispatchQueue.main.async { [weak self] in
            self?.sessionsCollection.reloadData()
            self?.delegate?.updateCollectionHieght()
        }
    }
    
}
extension TawazonTalkHorizontalListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.sessions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TawazonTalkSessionCollectionViewCell.identifier, for: indexPath) as! TawazonTalkSessionCollectionViewCell
        cell.session = data?.sessions[safe: indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size(for: indexPath)
        }

        private func size(for indexPath: IndexPath) -> CGSize {
            // load cell from Xib
            let cell = sessionsCollection.dequeueReusableCell(withReuseIdentifier: TawazonTalkSessionCollectionViewCell.identifier, for: indexPath) as! TawazonTalkSessionCollectionViewCell

            // configure cell with data in it
            cell.session = data?.sessions[safe: indexPath.item]

            cell.setNeedsLayout()
            cell.layoutIfNeeded()

            // width that you want
            let width = collectionCellWidth
            let height: CGFloat = 0

            let targetSize = CGSize(width: width, height: height)

            // get size with width that you want and automatic height
            let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
            return size
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionCellSpace
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionCellSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let session = data?.sessions[safe: indexPath.item] else {
            return
        }
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.tawazonTalkScreenPlayItem, payload: ["sessionId" : session.session?.id ?? "", "sessionName" : session.name ?? "", "sessionType" : session.session?.type ?? ""])
        if session.session?.type == SessionType.series.rawValue {
            delegate?.openSeriesView(seriesId: session.session?.id ?? "", session: session.session!)
            return
        }
        if !(session.session?.locked ?? false){
            delegate?.playSession(self, session: session)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rtlHidden = scrollView.contentOffset.x > scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
        let ltlHidden = scrollView.contentOffset.x < scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
//        moreButton.isHidden = UIApplication.isRTL() ? rtlHidden : ltlHidden
    }
}
