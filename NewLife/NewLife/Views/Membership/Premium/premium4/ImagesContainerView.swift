//
//  ImagesContainerView.swift
//  Tawazon
//
//  Created by mac on 20/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class ImagesContainerView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images: [(imageName: String, caption: String)] = [] {
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
        pageControl.numberOfPages = images.count
        collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            self?.updatePageControl()
        }
    }
    
    private func updatePageControl() {
        let pageWidth = collectionView.frame.size.width
        var page = Int(floor(collectionView.contentOffset.x / pageWidth ))
        page = (images.count - 1) - page
        pageControl.currentPage = page
    }
    
    @IBAction func pageControlTapped(_ sender: Any) {
        let pageWidth = collectionView.frame.size.width
        collectionView.contentOffset.x =  (CGFloat((images.count - 1))  - CGFloat(pageControl.currentPage)) * pageWidth
    }
}

extension ImagesContainerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesContainerViewCollectionViewCell.identifier, for: indexPath) as! ImagesContainerViewCollectionViewCell
        cell.imageData = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl()
    }
    
    
}
