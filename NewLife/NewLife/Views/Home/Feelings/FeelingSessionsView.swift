//
//  FeelingSessionsView.swift
//  Tawazon
//
//  Created by Shadi on 12/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol FeelingSessionsViewDelegate: class {
    func playSession(_ sender: FeelingSessionsView, session: HomeSessionVM)
    
    func changeFeelingTapped(_ sender: FeelingSessionsView)
}

class FeelingSessionsView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    weak var delegate: FeelingSessionsViewDelegate?
    var sessionsSection: HomeSectionVM? {
        didSet {
            if sessionsSection?.sessions.map({ $0.session?.id }) != oldValue?.sessions.map({ $0.session?.id }) {
                reloadData()
            }
          
        }
    }
    
    private var collectionCellSpace: CGFloat = 16
    private var collectionCellWidth: CGFloat = 10
    private var collectionCellHeight: CGFloat = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize()  {
        iconImageView.image = UIImage(named: "SelectFeelingsIcon")
        titleLabel.font = UIFont.kohinoorRegular(ofSize: 15)
        titleLabel.textColor = UIColor.white
        changeButton.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        changeButton.tintColor = UIColor.white
        changeButton.layer.cornerRadius = changeButton.frame.height / 2
        changeButton.setTitle("changeFeelingButtonTitle".localized, for: .normal)
        changeButton.titleLabel?.font = UIFont.kohinoorSemiBold(ofSize: 15)
         
    }
    
    private func reloadData() {
        titleLabel.text = sessionsSection?.title
        let availableWidth = frame.width - (2 * collectionCellSpace)
        collectionCellWidth = availableWidth / 1.1
        collectionCellHeight = collectionCellWidth / 1.2
        self.collectionView.reloadData()
        
        DispatchQueue.main.async {
            if self.collectionView.numberOfItems(inSection: 0) > 0, self.collectionView.contentSize.width > self.collectionView.frame.width {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
            self.isHidden = (self.sessionsSection?.sessions.count ?? 0) == 0
        }
    }
    
    @IBAction func changeButtonTapped(_ sender: UIButton) {
        delegate?.changeFeelingTapped(self)
    }
}

extension FeelingSessionsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessionsSection?.sessions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTableSessionCollectionCell.identifier, for: indexPath) as! HomeTableSessionCollectionCell
        cell.session = sessionsSection?.sessions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionCellWidth, height: collectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionCellSpace
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let seesion = sessionsSection?.sessions[safe: indexPath.item] else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        cell?.pulsate()
        delegate?.playSession(self, session: seesion)
    }
}
