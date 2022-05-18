//
//  ImagesContainerView.swift
//  Tawazon
//
//  Created by mac on 20/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
protocol ImagesContainerDelegate : class{
    func updateHeaderTitle(item: Int)
}
class ImagesContainerView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate : ImagesContainerDelegate?
    var images: [FeatureItem]? {
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
        
        headerTitleLabel.font = UIFont.munaBoldFont(ofSize: 32.0)
        headerTitleLabel.textColor = UIColor.white
        headerTitleLabel.numberOfLines = 0
        headerTitleLabel.lineBreakMode = .byWordWrapping
        headerTitleLabel.text = "premium4TitleLabelPart3".localized
        headerTitleLabel.isHidden = true
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.decelerationRate = .fast
        
        collectionView.collectionViewLayout = ArabicCollectionFlow()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        pageControl.tintColor = UIColor.white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = UIColor.white
    }
    
    private func reloadData() {
        
        pageControl.numberOfPages = images?.count ?? 0
        collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            if let firstImage = self?.images?[0]{
                self?.headerTitleLabel.text = firstImage.title
            }
            
            self?.updatePageControl(page: 0)
        }
    }
    
    private func updatePageControl(page: Int = 0) {
        
        pageControl.currentPage = page
        centerItemIfNeeded(indexPath: IndexPath(item: page, section: 0))
        delegate?.updateHeaderTitle(item: page)
    }
    
    @IBAction func pageControlTapped(_ sender: Any) {
        centerItemIfNeeded(indexPath: IndexPath(item: pageControl.currentPage, section: 0))
    }
}

extension ImagesContainerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesContainerViewCollectionViewCell.identifier, for: indexPath) as! ImagesContainerViewCollectionViewCell
        cell.imageData = images?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

            visibleRect.origin = collectionView.contentOffset
            visibleRect.size = collectionView.bounds.size

            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

            guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

        updatePageControl(page: indexPath.item)
    }
    
    
    private func centerItemIfNeeded(indexPath: IndexPath) {
        
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
    }
}



class ArabicCollectionFlow: UICollectionViewFlowLayout {
  override var flipsHorizontallyInOppositeLayoutDirection: Bool {
      return Language.language == .arabic ? true : false
  }
}
