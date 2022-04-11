//
//  Premium4ViewController.swift
//  Tawazon
//
//  Created by mac on 16/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class Premium4ViewController: BasePremiumViewController {

    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var headerTitlePart1Label: UILabel!
    @IBOutlet weak var headerTitlePart2Label: GradientLabel!
    @IBOutlet weak var headerTitlePart3Label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imagesContainer: ImagesContainerView!
    @IBOutlet weak var plansContainer: PlansView!
    @IBOutlet weak var purchaseButton: GradientButton!
    @IBOutlet weak var noteLabel: UILabel!
    
    var features: [FeatureItem]? {
        didSet {
            imagesContainer.images = features
            fetchPlans()
        }
    }
    
    var plans: [PremiumPurchaseCellVM]? {
        didSet {
            print("HIDE")
            plansContainer.plans = plans
            LoadingHud.shared.hide(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.fetchData()
        }
    }
    
    private func fetchData(){
        LoadingHud.shared.show(animated: true)
        
        data.getPremiumPageDetails(premiumId: premiumPageIds.premium4.rawValue, service: MembershipServiceFactory.service(), completion: { (error) in
            
            self.features = self.data.premiumDetails?.premiumPage.featureItems
        })
    }

    private func fetchPlans(){
        data.fetchPremiumPurchaseProducts(completion: { (error) in
            self.plans = self.data.plansArray
        })
    }
    private func initialize() {
        view.clearLabels()
        
        view.backgroundColor = UIColor.veniceBlue
        
        headerView.applyGradientColor(colors: [UIColor.veniceBlue.withAlphaComponent(0.0).cgColor, UIColor.veniceBlue.withAlphaComponent(0.71).cgColor, UIColor.veniceBlue.cgColor], startPoint: .bottom, endPoint: .top)
        
        headerTitlePart1Label.font = UIFont.munaFont(ofSize: 18.0)
        headerTitlePart1Label.text = "premium4TitleLabelPart1".localized
        headerTitlePart1Label.textColor = .white
        
        headerTitlePart2Label.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.freeSpeechBlue.cgColor], startPoint: .top, endPoint: .bottom)
        headerTitlePart2Label.text = "PLUS"
        headerTitlePart2Label.textColor = .white
        headerTitlePart2Label.layer.cornerRadius = 5
        
        headerTitlePart3Label.font = UIFont.munaBoldFont(ofSize: 32.0)
        headerTitlePart3Label.textColor = UIColor.white
        headerTitlePart3Label.text = "premium4TitleLabelPart3".localized
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
        purchaseButton.setTitle("premium4PurchaseButtonTitle".localized, for: .normal)
        purchaseButton.tintColor = .white
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        
        
        noteLabel.font = UIFont.munaFont(ofSize: 12.0)
        noteLabel.textColor = UIColor.white
        noteLabel.layer.opacity = 0.71
        noteLabel.text = "premium4DefaultPurchaseDescription".localized
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        print("purchaseButtonTapped: \(plansContainer.selectedPlan )")
        purchaseAction(product: data.products[plansContainer.selectedPlan])
    }
}
extension Premium4ViewController {
    
    class func instantiate(nextView: NextView) -> Premium4ViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Premium4ViewController.identifier) as! Premium4ViewController
        viewController.nextView = nextView
        return viewController
    }
}
