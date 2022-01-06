//
//  HomeVideosContainerView.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class HomeVideosContainerView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var videos: [HomeVideoCellVM] = [] {
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
        
        pageControl.tintColor = UIColor.white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = UIColor.white
    }
    
    private func reloadData() {
        pageControl.numberOfPages = videos.count
        collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            self?.updatePageControl()
        }
        
    }
    
    private func updatePageControl() {
        
        let pageWidth = collectionView.frame.size.width
        var page = Int(floor((collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        page = (videos.count - 1) - page
        
        pageControl.isHidden = true// (videos.count < 2)
        pageControl.currentPage = page
    }
    
}

extension HomeVideosContainerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVideoCollectionCell.identifier, for: indexPath) as! HomeVideoCollectionCell
        cell.data = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVideoCollectionCell.identifier, for: indexPath) as! HomeVideoCollectionCell
        cell.pause()
        cell.videoBackground = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl()
    }
    
    
}
