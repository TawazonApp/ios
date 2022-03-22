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
    
    var plans: [(title: String, price: String, trial: String, isSelected: Bool , color: UIColor)] = [] {
        didSet {
            reloadData()
        }
    }
    
    var selectedPlan: Int = NSNotFound
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    private func initialize() {
        
    }
    
    private func reloadData() {
        print("plans.count: \(plans.count)")
        plansCollectionView.reloadData()
        
    }
}
extension PlansView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PremiumPlanCollectionViewCell.identifier, for: indexPath) as! PremiumPlanCollectionViewCell
        cell.plan = plans[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize = (collectionView.frame.size.width / CGFloat(plans.count)) - 6
        return CGSize(width: collectionViewSize , height: 104 )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PremiumPlanCollectionViewCell
        
        if selectedPlan >= 0 && selectedPlan < collectionView.numberOfItems(inSection: 0) {
            let oldSelectedCell = collectionView.cellForItem(at: IndexPath(item: selectedPlan, section: 0)) as! PremiumPlanCollectionViewCell
            oldSelectedCell.setIsSelected(selected: false)
        }
        selectedPlan = indexPath.item
        selectedCell.setIsSelected(selected: true)
        
    }
}
