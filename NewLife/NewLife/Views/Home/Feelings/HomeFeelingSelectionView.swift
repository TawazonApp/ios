//
//  HomeFeelingSelectionView.swift
//  Tawazon
//
//  Created by Shadi on 15/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeFeelingSelectionViewDelegate: class {
    func feelingDidChange(_ sender: HomeFeelingSelectionView, feelingIds: [String])
}

class HomeFeelingSelectionView: GradientView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: HomeFeelingSelectionViewDelegate?
    
    var dayTime: DayTime = .morning {
        didSet {
            updateDayColors()
        }
    }

    var feelings: [FeelCellModel] = [] {
        didSet {
//            reloadData()
        }
    }
    
    var subFeelings: [SubfeelingCellModel] = []{
        didSet{
            reloadData()
        }
    }
    var selectedIndex: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 32
        layer.masksToBounds = true
        setTitle()
    }
    
    private func reloadData() {
        selectedIndex = -1
        collectionView.reloadData()
        if collectionView.numberOfItems(inSection: 0) > 0 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    private func updateDayColors() {
        applyGradientColor(colors: dayTime.dradientColors.map({ $0.cgColor}), startPoint: .top, endPoint: .bottom)
        titleLabel.textColor = dayTime.textColor
    }
    
    private func setTitle() {
        let normalString = "homeFeelingTitlePart1".localized
        let boldString = "homeFeelingTitlePart2".localized
        let text = "\(normalString) \(boldString)"
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)])
        let boldRange = NSString(string: text).range(of: boldString)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold)], range: boldRange)
        titleLabel.attributedText = attributedString
    }
    
    @objc private func feelingsDidChange() {
        //FIXME after return feeling reponde
        if let selectedSubfeeling = self.subFeelings.filter({ $0.isSelected }).first{
            delegate?.feelingDidChange(self, feelingIds: [selectedSubfeeling.id])
        }
        
    }
}


extension HomeFeelingSelectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subFeelings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeelCollectionCell.identifier, for: indexPath) as! HomeFeelCollectionCell
        cell.data = subFeelings[safe: indexPath.item]
        cell.isSelected = (cell.data?.isSelected ?? false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aviabileWidth = (collectionView.frame.width - 40)
        var cellNumber = aviabileWidth / (68.0 + 5.0)
        cellNumber += 0.5
        var cellWidth = aviabileWidth / cellNumber
        if cellWidth < 60 {
            cellNumber -= 0.5
            cellWidth = aviabileWidth / cellNumber
        }
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell =  (collectionView.cellForItem(at: indexPath) as? HomeFeelCollectionCell) else {
            return
        }
        if selectedIndex != indexPath.item {
            let previousIndex = selectedIndex
            let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? HomeFeelCollectionCell
            subFeelings[safe: previousIndex]?.isSelected = false
            previousCell?.updateStyle()
        }
        
        if selectedIndex == indexPath.item {
            return
        }
        selectedIndex = indexPath.item
        cell.data?.isSelected = true
        cell.updateStyle()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        cell.pulsate()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(feelingsDidChange), with: nil, afterDelay: 0.1)
    }
}
