//
//  CategorySessionsViewController.swift
//  Tawazon
//
//  Created by mac on 21/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol CategorySessionsViewDelegate: class{
    func playSession(_ session: CategorySessionVM)
    func updateHeader(offset: CGPoint)
    func openSeriesView(seriesId: String)
}
class CategorySessionsView: UIView {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CategorySessionsViewDelegate?
    var sessions : [CategorySessionVM]?{
        didSet{
            collectionView.reloadData()
            if selectedSubCategory != nil {
                //TODO: sendTapSubCategoryEvent
            }
        }
    }
    var selectedSubCategory: SubCategoryVM? {
        didSet {
            collectionView.reloadData()
            if selectedSubCategory != nil {
                //TODO: sendTapSubCategoryEvent
            }
        }
    }
}
extension CategorySessionsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySessionCollectionCell.identifier, for: indexPath) as! CategorySessionCollectionCell
        cell.session = sessions?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (2*20), height: 164)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let session = sessions?[indexPath.item] else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
//            if session.session?.type == "series" {
//                self?.delegate?.openSeriesView(seriesId: session.session?.id ?? "")
//                return
//            }

            self?.delegate?.playSession(session)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let selectedSubCategory = selectedSubCategory, indexPath.item >= (selectedSubCategory.sessions.count - 4) {
            
            selectedSubCategory.fetchMore { (error) in
                if error == nil {
                    collectionView.reloadData()
                }
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.updateHeader(offset: scrollView.contentOffset)
    }
}
