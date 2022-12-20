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
}
class TawazonTalkHorizontalListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sessionsCollection: UICollectionView!
    @IBOutlet weak var deviderView: UIView!
    @IBOutlet weak var sessionsCollectionHeightConstraint: NSLayoutConstraint!
    var data: TawazonTalkSectionVM? {
        didSet {
            reloadData()
        }
    }
    var delegate: TawazonTalkTableHorizontalSectionCellDelegate?
    private var collectionCellSpace: CGFloat = 17
    private var collectionCellWidth: CGFloat = 10
    private var collectionCellHeight: CGFloat = 216
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        calculateCollectionHeight()
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
        self.calculateCollectionHeight()
        
        DispatchQueue.main.async { [weak self] in
            self?.sessionsCollection.reloadData()
            self?.sessionsCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
        
    }
    
    private func calculateCollectionHeight() {
        let availableWidth = UIScreen.main.bounds.size.width - (2 * collectionCellSpace)
        
        collectionCellWidth = 160
        
        if (data?.sessions.count ?? 0) <= 1 {
            collectionCellWidth = availableWidth - 20
            collectionCellHeight = 210
        }
        sessionsCollectionHeightConstraint.constant = collectionCellHeight + (sessionsCollection.contentInset.top + sessionsCollection.contentInset.bottom + 10) + (2 * collectionCellSpace)
        sessionsCollection.layoutIfNeeded()
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
            return CGSize(width: collectionCellWidth, height: collectionCellHeight)
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
        let cell = collectionView.cellForItem(at: indexPath)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
//        cell?.pulsate()
        
        if session.session?.type == SessionType.series.rawValue {
            delegate?.openSeriesView(seriesId: session.session?.id ?? "", session: session.session!)
            return
        }
        delegate?.playSession(self, session: session)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rtlHidden = scrollView.contentOffset.x > scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
        let ltlHidden = scrollView.contentOffset.x < scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
//        moreButton.isHidden = UIApplication.isRTL() ? rtlHidden : ltlHidden
    }
}
