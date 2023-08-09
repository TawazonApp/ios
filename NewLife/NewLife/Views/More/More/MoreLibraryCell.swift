//
//  MoreLibraryCell.swift
//  Tawazon
//
//  Created by mac on 17/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

protocol LibraryCollectionCellDelegate: class{
    func openLibrary(type: MoreLibraryCellVM.MoreLibraryCellType)
}

import UIKit

class MoreLibraryCell: UITableViewCell {

    @IBOutlet weak var libraryCollection: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var libraryCellContentView: UIView!
    
    private var collectionCellSpace: CGFloat = 16
    private var collectionCellWidth: CGFloat = 155
    private var collectionCellHeight: CGFloat = 116
    
    weak var delegate : LibraryCollectionCellDelegate?
    
    var moreLibraryData: MoreLibraryVM! {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        moreLibraryData = MoreLibraryVM()
        initialize()
    }

    private func initialize(){
        backgroundColor = .clear
        
        contentView.backgroundColor = .clear
       
        libraryCollection.backgroundColor = .clear
    }
    private func reloadData() {
        calculateCollectionDimensions()
        DispatchQueue.main.async { [weak self] in
            self?.libraryCollection.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadData()
    }
    
    private func calculateCollectionDimensions() {
        let availableWidth = UIScreen.main.bounds.size.width - 48
        collectionCellWidth = (availableWidth - collectionCellSpace) / 2
        collectionCellHeight = collectionCellWidth / (155/116)
        collectionHeightConstraint.constant = collectionCellHeight
        libraryCollection.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MoreLibraryCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreLibraryData.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreLibraryCollectionCell.identifier, for: indexPath) as! MoreLibraryCollectionCell
        cell.data = moreLibraryData.items[indexPath.row]
        cell.layoutIfNeeded()
        cell.layoutSubviews()
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
        delegate?.openLibrary(type: moreLibraryData.items[indexPath.row].type)
    }
    
}
