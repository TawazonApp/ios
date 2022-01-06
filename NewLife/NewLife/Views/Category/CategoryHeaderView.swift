//
//  CategoryHeaderView.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol CategoryHeaderViewDelegate: class {
    func subCategoryTapped(subCategory: SubCategoryVM)
}

class CategoryHeaderView: UIView {
    
    @IBOutlet weak var nameLabel: PaddingLabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subCategoriesCollection: UICollectionView!
    @IBOutlet weak var separatorView: GradientView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    weak var delegate: CategoryHeaderViewDelegate?
    
    let maxFontSize: CGFloat = 32
    let minFontSize: CGFloat = 20
    let scaleFactor: CGFloat = 0.15
    
    var selectedSubCategoryIndex: Int = 0 {
        didSet {
            updateSubCategorySelectStyle(index: oldValue, isSelected: false)
            updateSubCategorySelectStyle(index: selectedSubCategoryIndex, isSelected: true)
        }
    }
    
    var sizeRatio: CGFloat = 1.0 {
        didSet {
            if oldValue != sizeRatio {
                  updateSizeStyle(ratio: sizeRatio)
            }
        }
    }
    
    var category: CategoryVM! {
        didSet {
            subCategories = category.subCategories
            if UIApplication.isRTL() {
                subCategories.reverse()
            }
            fillData()
        }
    }
    
    var subCategories = [SubCategoryVM]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        nameLabel.font = UIFont.lbc(ofSize: maxFontSize)
        nameLabel.textColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        subCategoriesCollection.backgroundColor = UIColor.clear
        nameLabel.bottomInset = 10
    }
    
    private func fillData() {
        backgroundColor = category.backgroundColor
        nameLabel.text = category.name
        nameLabel.textColor = category.titleColor
        imageView.image = UIImage(named: category.imageName)
        
        if let backgroundColor = category.backgroundColor {
            separatorView.applyGradientColor(colors: [backgroundColor.withAlphaComponent(0.0).cgColor, backgroundColor.cgColor], startPoint: .top, endPoint: .bottom)
        }
       
        collectionReloadData()
    }
    
    private func collectionReloadData() {
        selectedSubCategoryIndex = UIApplication.isRTL() ? subCategories.count - 1 : 0
        subCategoriesCollection.reloadData()
        DispatchQueue.main.async {
            if UIApplication.isRTL() {
                self.subCategoriesCollection.contentOffset = CGPoint(x: self.subCategoriesCollection.contentSize.width -   self.subCategoriesCollection.frame.width, y: 0)
            }
        }
        
    }
    
    private func updateSizeStyle(ratio: CGFloat) {
        let scale = scaleFactor * (1 - ratio)
        topConstraint.constant = -(scale * self.frame.height)

        UIView.animate(withDuration: 0.1) {
            self.imageView.transform = CGAffineTransform(scaleX: 1 - scale, y: 1 - scale )
            self.nameLabel.transform = CGAffineTransform(scaleX: 1 - scale, y: 1 - scale )
            self.superview?.layoutIfNeeded()
        }
        
    }
    
    
    private func updateSubCategorySelectStyle(index: Int, isSelected: Bool) {
        guard let cell = subCategoriesCollection.cellForItem(at: IndexPath(item: index, section: 0)) as? SubCategoryCollectionCell else {
            return
        }
        cell.isSelected = isSelected
    }
}

extension CategoryHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCollectionCell.identifier, for: indexPath) as! SubCategoryCollectionCell
        cell.category = subCategories[indexPath.item]
        cell.isSelected = (indexPath.item == selectedSubCategoryIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 32
        let subCategory = subCategories[indexPath.item]
        
        let width = subCategory.name.width(withConstrainedHeight: height, font: UIFont.kacstPen(ofSize: 18)) + 20
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedSubCategoryIndex != indexPath.item {
            selectedSubCategoryIndex = indexPath.item
            
            delegate?.subCategoryTapped(subCategory: subCategories[indexPath.item])
    
            centerItemIfNeeded(indexPath: indexPath)
           
        }
       
    }
    
    private func centerItemIfNeeded(indexPath: IndexPath) {
        if subCategoriesCollection.contentSize.width > subCategoriesCollection.frame.width {
            subCategoriesCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}
