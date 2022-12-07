//
//  LandingFeelingsViewController.swift
//  Tawazon
//
//  Created by mac on 02/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class LandingFeelingsViewController: HandleErrorViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var feelingsView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var feelingsCollection: UICollectionView!
    
    @IBOutlet weak var subFeelingsView: UIView!
    @IBOutlet weak var subFeelingLabel: UILabel!
    @IBOutlet weak var subFeelingsSlider: FeelingSlider!
    
    @IBOutlet weak var selectedSubFeelingLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    private  var viewModel = HomeTableFeelingCellVM(homeService: HomeServiceCache.shared)
    
    var cameFromSkip: Bool = false
    var feelings: [FeelCellModel] = [] {
        didSet {
            reloadData()
        }
    }
    var lastSelectedFeelingIndex : Int = -1
    var fromVC: fromViewController? = .landing
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        fetchAndReloadData()
    }
    
    private func initialize(){
        view.backgroundColor = .midnight
        
        backgroundImageView.backgroundColor = .clear
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "PreparationSessionHeader")
        
        closeButton.roundCorners(corners: .allCorners, radius: 24)
        closeButton.backgroundColor = .black.withAlphaComponent(0.62)
        closeButton.setImage(UIImage(named: "Cancel"), for: .normal)
        closeButton.tintColor = .white
        
        titleImageView.backgroundColor = .clear
        titleImageView.contentMode = .scaleToFill
        titleImageView.image = UIImage(named: "PreparationSessionDone")
        
        titleLabel.font = .munaBoldFont(ofSize: 36)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = fromVC == .landing ? (cameFromSkip ?  "landingFeelingViewTitleSkipped".localized : "landingFeelingViewTitle".localized) : "dailyActivityFeelingViewTitle".localized
        
        subtitleLabel.font = .munaFont(ofSize: 14)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = fromVC == .landing ? (cameFromSkip ? "landingFeelingViewSubtitleSkipped".localized : "landingFeelingViewSubtitle".localized) : "dailyActivityFeelingViewSubtitle".localized
        
        questionLabel.font = .munaBoldFont(ofSize: 22)
        questionLabel.textColor = .white
        questionLabel.textAlignment = .center
        questionLabel.text = "landingFeelingViewQuestion".localized
        
        feelingsCollection.backgroundColor = .clear
        feelingsCollection.allowsMultipleSelection = false
        
        subFeelingsView.isHidden = true
        
        subFeelingLabel.font = .munaBoldFont(ofSize: 22)
        subFeelingLabel.textColor = .white
        subFeelingLabel.textAlignment = .center
        subFeelingLabel.text = "landingFeelingViewSubFeelingLabelTitle".localized
        
        selectedSubFeelingLabel.font = .munaFont(ofSize: 18)
        selectedSubFeelingLabel.textColor = .white.withAlphaComponent(0.8)
        selectedSubFeelingLabel.textAlignment = .center
        
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 20
        submitButton.backgroundColor = .white
        submitButton.tintColor = UIColor.mariner
        submitButton.setTitle("landingFeelingViewSubmitButtonTitle".localized, for: .normal)
        submitButton.isHidden = true
        submitButton.titleLabel?.font = UIFont.munaBoldFont(ofSize: 26)
        
    }
    
    func fetchAndReloadData() {
       viewModel.getFeelings { [weak self] (error) in
           guard let self = self else { return }
           if let error = error {
               self.showErrorMessage(message: error.localizedDescription)
               return
           }
           self.feelings = self.viewModel.feelings
       }
   }
    
    private func reloadData() {
        feelingsCollection.reloadData()
    }
    
    
    
    @IBAction func subFeelingValueChanged(_ sender: Any) {
        let feelingSlider = sender as! FeelingSlider
        
        let step: Float = 1
        let roundedValue = round(feelingSlider.value / step) * step
        feelingSlider.value = roundedValue
        
        if lastSelectedFeelingIndex >= 0{
            selectedSubFeelingLabel.text = feelings[lastSelectedFeelingIndex ].subFeelings?[Int(roundedValue - 1)].title
            if fromVC == .todayActivity{
                let values = ["subfeelingId": feelings[lastSelectedFeelingIndex ].subFeelings?[Int(roundedValue - 1)].id ?? "subfeeling_id", "subfeelingName": feelings[lastSelectedFeelingIndex ].subFeelings?[Int(roundedValue - 1)].title ?? "subfeeling_title"]
                TrackerManager.shared.sendEvent(name: GeneralCustomEvents.dailyActivityFeelingsIntencitySelcted, payload: values)
            }else{
                TrackerManager.shared.sendFeelingsIntencitySelcted(subfeelingId: feelings[lastSelectedFeelingIndex ].subFeelings?[Int(roundedValue - 1)].id ?? "subfeeling_id", subfeelingName: feelings[lastSelectedFeelingIndex ].subFeelings?[Int(roundedValue - 1)].title ?? "subfeeling_title")
            }
            
        }
        
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if let selectedSubFeeling = feelings[lastSelectedFeelingIndex].subFeelings?[Int(subFeelingsSlider.value - 1)]{
            viewModel.updateFeelings(feelingIds: [selectedSubFeeling.id], completion: {(error) in
                if let error = error{
                    self.showErrorMessage(message: error.message ?? "")
                    return
                }
               
                if self.fromVC == .todayActivity{
                    let values = ["feelingId": self.feelings[self.lastSelectedFeelingIndex].id, "feelingName": self.feelings[self.lastSelectedFeelingIndex].name, "subfeelingId": selectedSubFeeling.id, "subfeelingName": selectedSubFeeling.title]
                    TrackerManager.shared.sendEvent(name: GeneralCustomEvents.dailyActivityFeelingsLogged, payload: values)
                    self.dismiss(animated: true)
                }else{
                    TrackerManager.shared.sendFeelingsLogged(feelingId: self.feelings[self.lastSelectedFeelingIndex].id, feelingName: self.feelings[self.lastSelectedFeelingIndex].name, subfeelingId: selectedSubFeeling.id, subfeelingName: selectedSubFeeling.title)
                    self.openLandingReminderViewController()
                }
                
            })
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        if fromVC == .todayActivity{
            TrackerManager.shared.sendEvent(name: GeneralCustomEvents.dailyActivityFeelingsClosed, payload: nil)
            self.dismiss(animated: true)
            return
        }
        TrackerManager.shared.sendFeelingsSkipped()
        openLandingReminderViewController()
    }
    
    private func openLandingReminderViewController(){
        let viewController = LandingReminderViewController.instantiate()
        viewController.modalPresentationStyle = .currentContext
        self.show(viewController, sender: self)
    }
}

extension LandingFeelingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feelings.count > 5 ? 6 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandingFeelingCollectionViewCell.identifier, for: indexPath) as! LandingFeelingCollectionViewCell
        cell.feeling = feelings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20.0) / 2, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LandingFeelingCollectionViewCell
        cell.setSelectedStyle(true)
        if lastSelectedFeelingIndex >= 0{
            feelings[lastSelectedFeelingIndex].isSelected = false
        }else{
            submitButton.isHidden = false
        }
        
        feelings[indexPath.item].isSelected = true
        lastSelectedFeelingIndex = indexPath.item
        collectionView.reloadData()
        
        initFeelingSlider()
        if fromVC == .todayActivity{
            let values = ["feelingId": feelings[indexPath.item].id, "feelingName": feelings[indexPath.item].name]
            TrackerManager.shared.sendEvent(name: GeneralCustomEvents.dailyActivityFeelingsMainSelected, payload: values)
        }else{
            TrackerManager.shared.sendFeelingsMainSelected(feelingId: feelings[indexPath.item].id, feelingName: feelings[indexPath.item].name)
        }
        
    }
    private func initFeelingSlider(){
        let selectedFeeling = feelings[lastSelectedFeelingIndex]
        subFeelingsView.isHidden = false
        subFeelingLabel.text = String(format: "landingFeelingViewSubFeelingLabelTitle".localized, selectedFeeling.name)
        subFeelingsSlider.maximumValue = Float(selectedFeeling.subFeelings?.count ?? 1)
        subFeelingsSlider.minimumValue = 1.0
        
        subFeelingsSlider.setValue((selectedFeeling.subFeelings?.count ?? 0) % 2 == 0 ? round(Float((selectedFeeling.subFeelings?.count ?? 0) / 2)) : round(Float(((selectedFeeling.subFeelings?.count ?? 0) + 1) / 2)), animated: false)
        subFeelingsSlider.sendActions(for: .valueChanged)
        
        selectedSubFeelingLabel.text = selectedFeeling.subFeelings?[Int(subFeelingsSlider.value - 1)].title
    }
}

extension LandingFeelingsViewController{
    class func instantiate(skipped: Bool, from:  fromViewController = .landing) -> LandingFeelingsViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: LandingFeelingsViewController.identifier) as! LandingFeelingsViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.cameFromSkip = skipped
        viewController.fromVC = from
        return viewController
    }
}
