//
//  PlansView.swift
//  Tawazon
//
//  Created by mac on 22/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class PlansView: UIView {

    @IBOutlet weak var plansCollectionView: UICollectionView!
    @IBOutlet weak var mostPopularLabel: UILabel!
    
    var plans: [PremiumPurchaseCellVM]? {
        didSet {
            if let plansCount = plans?.count, plansCount > 0{
                plans!.sort(by: { $0.priority < $1.priority })
            }
            reloadData()
        }
    }
    
    var selectedPlan: Int = NSNotFound
    
    private var collectionCellSpace: CGFloat = 12
    private var collectionCellWidth: CGFloat = 101
    private var collectionCellHeight: CGFloat = 104
    private var collectionCellSelectedHeight: CGFloat = 120
    private var collectionCellSelectedWidth: CGFloat = 109
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setData() {
        mostPopularLabel.font = UIFont.munaBoldFont(ofSize: 13.0)
        mostPopularLabel.textColor = UIColor.lightSlateBlue
        mostPopularLabel.text = "premium4mostPopularLabel".localized
    }
    
    private func reloadData() {
        setData()
        print("reloadData")
        plansCollectionView.reloadData()
        plansCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        selectedPlan = 1
        plans?[selectedPlan].isSelected = true
    }
}
extension PlansView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PremiumPlanCollectionViewCell.identifier, for: indexPath) as! PremiumPlanCollectionViewCell
        cell.plan = plans?[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        collectionView.decelerationRate = .fast
        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            return CGSize(width: collectionCellSelectedWidth , height: collectionCellSelectedHeight )
        default:
            return CGSize(width: collectionCellWidth , height: collectionCellHeight )
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        collectionView.performBatchUpdates(nil, completion: nil)
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PremiumPlanCollectionViewCell
        
        if selectedPlan >= 0 && selectedPlan < collectionView.numberOfItems(inSection: 0) {
            let oldSelectedCell = collectionView.cellForItem(at: IndexPath(item: selectedPlan, section: 0)) as! PremiumPlanCollectionViewCell
            oldSelectedCell.setIsSelected(selected: false)
        }
        selectedPlan = indexPath.item
        selectedCell.setIsSelected(selected: true)
        
        if let plan  = plans?[indexPath.item]{
            TrackerManager.shared.sendTapProductEvent(productId: plan.id, name: plan.title, price: (plan.discountPrice! as NSString).doubleValue)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalCellWidth = Int(collectionCellWidth) * (plans?.count ?? 0)
        let totalSpacingWidth = Int(collectionCellSpace) * ((plans?.count ?? 1) - 1)

        let leftInset = (frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = 101 * (plans?.count ?? 0) + Int(collectionCellWidth - collectionCellSelectedWidth)
        let totalSpacingWidth = 12 * (plans?.count ?? 1 - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
