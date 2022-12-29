//
//  HomeTableTawazonTalkSectionCell.swift
//  Tawazon
//
//  Created by mac on 26/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeTableTawazonTalkSectionCellDelegate: class {
    func openTalkView(_ sender: HomeTableTawazonTalkSectionCell, item: ItemVM)
    func sectionTapped(_ sender: HomeTableTawazonTalkSectionCell, section: HomeSectionVM?)
}

class HomeTableTawazonTalkSectionCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionLogoImage: UIImageView!
    @IBOutlet weak var itemsCollection: UICollectionView!
    
    weak var delegate: HomeTableTawazonTalkSectionCellDelegate?
    
    private var collectionCellSpace: CGFloat = 16
    private var collectionCellWidth: CGFloat = 10
    private var collectionCellHeight: CGFloat = 10
    
    var data: HomeSectionVM? {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    private func initialize() {
        backgroundColor = .clear
        
        
        sectionTitleLabel.font = UIFont.munaFont(ofSize: 20)
        sectionTitleLabel.textColor = UIColor.white
        sectionTitleLabel.text = "TawazonTalkHomeSectionTitle".localized
        sectionTitleLabel.isUserInteractionEnabled = true
        let titleLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(moreButtonTapped(_:)))
        sectionTitleLabel.addGestureRecognizer(titleLabelTapGesture)
        
        sectionLogoImage.contentMode = .scaleAspectFit
        sectionLogoImage.image = Language.language == .english ? UIImage(named: "TawazonTalkLogoEn") : UIImage(named: "TawazonTalkLogoAr")
        sectionLogoImage.isUserInteractionEnabled = true
        sectionLogoImage.addGestureRecognizer(titleLabelTapGesture)
        
        itemsCollection.backgroundColor = .clear
        
    }
    
    private func reloadData() {
        calculateCollectionHeight()
        DispatchQueue.main.async { [weak self] in
            self?.itemsCollection.reloadData()
        }
    }
    
    private func calculateCollectionHeight() {
        collectionCellWidth = 280
        collectionCellHeight = 256
        
        if (data?.items.count ?? 0) <= 1 {
            let availableWidth = UIScreen.main.bounds.size.width - (2 * collectionCellSpace)
            collectionCellWidth = availableWidth - 5
        }
        itemsCollection.layoutIfNeeded()
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        print("SECTION: \(data?.id)")
        delegate?.sectionTapped(self, section: data)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HomeTableTawazonTalkSectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTableTawazonTalkItemCollectionCell.identifier, for: indexPath) as! HomeTableTawazonTalkItemCollectionCell
        cell.item = data?.items[safe: indexPath.item]
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
        guard let item = data?.items[safe: indexPath.item] else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        cell?.pulsate()
        
        delegate?.openTalkView(self, item: item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rtlHidden = scrollView.contentOffset.x > scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
        let ltlHidden = scrollView.contentOffset.x < scrollView.frame.width || scrollView.contentSize.width < (scrollView.frame.width * 1.5)
        
//        moreButton.isHidden = UIApplication.isRTL() ? rtlHidden : ltlHidden
    }
}
