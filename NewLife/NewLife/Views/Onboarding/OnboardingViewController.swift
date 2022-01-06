//
//  OnboardingViewController.swift
//  Tawazon
//
//  Created by Shadi on 12/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var continueButton: UIButton!
    
    var data = [OnboardingCollectionCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        reloadData()
    }
    
    private func initialize() {
        (view as? GradientView)?.applyGradientColor(colors: [UIColor.paleGreyTwo.cgColor, UIColor.veryLightPink.cgColor], startPoint: .top, endPoint: .bottom)
        collectionView.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.kohinoorSemiBold(ofSize: 36)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "onboardingViewTitle".localized
            
        continueButton.layer.cornerRadius = 16
        continueButton.backgroundColor = UIColor.irisTwo
        continueButton.tintColor = UIColor.white
        continueButton.titleLabel?.font = UIFont.kohinoorSemiBold(ofSize: 16)
        continueButton.setTitle("continueButtonTitle".localized, for: .normal)
    }
    
    private func reloadData() {
        let childrenMeditation = OnboardingCollectionCellData(iconName: "OnboardingChildrenMeditation", title: "onboardingChildrenMeditationTitle".localized, subTitle: "onboardingChildrenMeditationSubtitle".localized)
        let liberation = OnboardingCollectionCellData(iconName: "OnboardingLiberation", title: "onboardingLiberationTitle".localized, subTitle: "onboardingLiberationSubtitle".localized)
        let newMeditation = OnboardingCollectionCellData(iconName: "OnboardingNewMeditation", title: "onboardingNewMeditationTitle".localized, subTitle: "onboardingNewMeditationSubtitle".localized)
        data = [newMeditation, childrenMeditation, liberation]
        collectionView.reloadData()
        
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension OnboardingViewController {
    
    class func instantiate() -> OnboardingViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
        return viewController
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionCell.identifier, for: indexPath) as? OnboardingCollectionCell
        
        cell?.data = data[indexPath.item]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth(), height: cellHeight(forIndex: indexPath.item))
    }
    
    func cellWidth() -> CGFloat {
        return collectionView.frame.width - (2 * 24)
    }
    func cellHeight(forIndex index: Int) -> CGFloat {
        let subTitleHeight = data[index].subTitle.height(withConstrainedWidth: cellWidth() - 20, font: UIFont.kohinoorRegular(ofSize: 15 * 1.33))
        return 40 + subTitleHeight
    }
}
