//
//  PremiumPurchaseView.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox
import StoreKit

protocol PremiumPurchaseViewDelegate: class {
    func priacyPolicyTapped()
    func purchaseButtonTapped(product: SKProduct?)
    func termsAndConditionsTapped()
}

class PremiumPurchaseView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    //@IBOutlet weak var purchaseButton: UIButton!
    
    weak var delegate: PremiumPurchaseViewDelegate?
    
    let cellHeight: CGFloat = 80
    var selectedPurchase: Int = NSNotFound
    
    var purchase: PremiumPurchaseVM! {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
        
        descriptionLabel.font = UIFont.kacstPen(ofSize: 16)
        descriptionLabel.textColor = UIColor.darkSlateBlue
        
        privacyButton.titleLabel?.font = UIFont.kacstPen(ofSize: 12)
        privacyButton.tintColor = UIColor.darkSlateBlue
        
        termsButton.titleLabel?.font = UIFont.kacstPen(ofSize: 12)
        termsButton.tintColor = UIColor.darkSlateBlue
    }
    
    private func reloadData() {
        setDescriptionText()
        privacyButton.setAttributedTitle(purchase.privacyAttributeString, for: .normal)
        termsButton.setAttributedTitle(purchase.termsAttributeString, for: .normal)
        collectionHeightConstraint.constant = CGFloat(purchase.tableArray.count) * (cellHeight + 8)
        self.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    private func setDescriptionText() {
        descriptionLabel.text = (selectedPurchase == NSNotFound) ? purchase.defaultDescriptionString : purchase.tableArray[selectedPurchase].descriptionString
    }
    
    @IBAction func privacyButtonTapped(_ sender: UIButton) {
        delegate?.priacyPolicyTapped()
    }
    
    @IBAction func termsButtonTapped(_ sender: UIButton) {
        delegate?.termsAndConditionsTapped()
    }
}

extension PremiumPurchaseView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchase.tableArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PremiumPurchaseCollectionCell.identifier, for: indexPath) as! PremiumPurchaseCollectionCell
        cell.cellData = purchase.tableArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SystemSoundID.play(sound: .selectGoal)
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PremiumPurchaseCollectionCell
        
        if selectedPurchase >= 0 && selectedPurchase < collectionView.numberOfItems(inSection: 0) {
            let oldSelectedCell = collectionView.cellForItem(at: IndexPath(item: selectedPurchase, section: 0)) as! PremiumPurchaseCollectionCell
            oldSelectedCell.setSelectedStyle(selected: false)
        }
        selectedPurchase = indexPath.item
        selectedCell.setSelectedStyle(selected: true)
        
        setDescriptionText()
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.purchaseButtonTapped(product: self?.purchase.products[safe: self?.selectedPurchase ?? -1])
        }
    }
    
}
