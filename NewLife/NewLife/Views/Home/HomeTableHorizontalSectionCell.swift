//
//  HomeTableHorizontalSectionCell.swift
//  Tawazon
//
//  Created by Shadi on 14/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeTableHorizontalSectionCellDelegate: class {
    func playSession(_ sender: HomeTableHorizontalSectionCell, session: HomeSessionVM)
    func sectionTapped(_ sender: HomeTableHorizontalSectionCell, section: HomeSectionVM?)
}

class HomeTableHorizontalSectionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionheightConstraint: NSLayoutConstraint!
    weak var delegate: HomeTableHorizontalSectionCellDelegate?
    
    var data: HomeSectionVM? {
        didSet {
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
    
    private func initialize() {
        backgroundColor = UIColor.clear
        titleLabel.font = UIFont.kacstPen(ofSize: 20)
        titleLabel.textColor = UIColor.white
        iconImageView.contentMode = .scaleAspectFit
        collectionView.backgroundColor = UIColor.clear
        
        moreButton.isHidden = true
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        moreButton.tintColor = UIColor.white
        moreButton.setTitle("homeMoreSessionsButtonTitle".localized, for: .normal)
    }
    
    private func reloadData() {
        titleLabel.text = data?.title
        iconImageView.image = nil
        if let imageUrl = data?.iconUrl?.url {
            iconImageView.af.setImage(withURL: imageUrl)
        }
        self.calculateCollectionHeight()
        setTitleLabelPosition()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    private func setTitleLabelPosition(){
        if (data?.iconUrl?.isEmptyWithTrim ?? false) || data?.iconUrl == nil{
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor).isActive = true
        }else{
            titleLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: 8).isActive = true
        }
        self.contentView.layoutIfNeeded()
    }
    private func calculateCollectionHeight() {
        let style =  data?.style ?? .largeList
        let availableWidth = frame.width - (2 * collectionCellSpace)
        if style == .largeList {
            collectionCellWidth = availableWidth / 1.1
            collectionCellHeight = collectionCellWidth * 1.1
            
        } else {
            collectionCellWidth = availableWidth / 1.4
            collectionCellHeight = collectionCellWidth * 1.25
        }
        if (data?.sessions.count ?? 0) <= 1 {
            collectionCellWidth = availableWidth - 5
        }
        collectionheightConstraint.constant = collectionCellHeight + (collectionView.contentInset.top + collectionView.contentInset.bottom + 10) + (2 * collectionCellSpace)
        collectionView.layoutIfNeeded()
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        delegate?.sectionTapped(self, section: data)
    }
}

extension HomeTableHorizontalSectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.sessions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTableSessionCollectionCell.identifier, for: indexPath) as! HomeTableSessionCollectionCell
        cell.session = data?.sessions[safe: indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionCellHeight < collectionView.frame.size.height {
            return CGSize(width: collectionCellWidth, height: collectionCellHeight)
        }
        return CGSize(width: collectionCellWidth, height: 116)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        cell?.pulsate()
        delegate?.playSession(self, session: session)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rtlHidden = scrollView.contentOffset.x > scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
        let ltlHidden = scrollView.contentOffset.x < scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
        moreButton.isHidden = UIApplication.isRTL() ? rtlHidden : ltlHidden
    }
}
