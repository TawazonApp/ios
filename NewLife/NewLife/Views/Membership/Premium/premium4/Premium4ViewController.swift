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
    
    
    var plans: [(title: String, price: String, trial: String, isSelected: Bool , color: UIColor)] = [] {
        didSet {
            plansContainer.plans = plans
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        
        var images : [(imageName: String, caption: String)] = []
        for i in 1..<5  {
            images.append((imageName: "File 1\(i).jpeg", caption: "ابدأ بتعلّم اليقظة والاستماع للموسيقى الهادئة واستمتع بالاقتباسات اليومية."))
        }
        imagesContainer.images = images
        
        var plansArray: [(title: String, price: String, trial: String, isSelected: Bool , color: UIColor)] = []
        plansArray.append((title: "شهري", price:"31.90 ₪ / شهر",trial: "7 أيام مجاناً", isSelected: false, color: .columbiaBlue))
        plansArray.append((title: "سنوي", price: "219.90 ₪ / شهر",trial: "7 أيام مجاناً", isSelected: false, color: .lightSlateBlue))
        plans = plansArray
    }

    private func initialize() {
        view.backgroundColor = UIColor.veniceBlue
        
        headerView.applyGradientColor(colors: [UIColor.veniceBlue.withAlphaComponent(0.0).cgColor, UIColor.veniceBlue.withAlphaComponent(0.71).cgColor, UIColor.veniceBlue.cgColor], startPoint: .bottom, endPoint: .top)
        
        headerTitlePart1Label.font = UIFont.munaFont(ofSize: 18.0)
        headerTitlePart1Label.text = "titleLabelPart1Premium4".localized
        headerTitlePart1Label.textColor = .white
        
        headerTitlePart2Label.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.freeSpeechBlue.cgColor], startPoint: .top, endPoint: .bottom)
        headerTitlePart2Label.text = "PLUS"
        headerTitlePart2Label.textColor = .white
        headerTitlePart2Label.layer.cornerRadius = 5
        
        headerTitlePart3Label.font = UIFont.munaBoldFont(ofSize: 32.0)
        headerTitlePart3Label.textColor = UIColor.white
        headerTitlePart3Label.text = "titleLabelPart3Premium4".localized
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
        purchaseButton.setTitle("purchaseButtonTitlePremium4".localized, for: .normal)
        purchaseButton.tintColor = .white
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        
        
        noteLabel.font = UIFont.munaFont(ofSize: 12.0)
        noteLabel.textColor = UIColor.white
        noteLabel.layer.opacity = 0.71
        noteLabel.text = "defaultPurchaseDescriptionPremium4".localized
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        print("purchaseButtonTapped: \(plansContainer.selectedPlan )")
//        purchaseAction(product: plansContainer.plans[safe: plansContainer.selectedPlan])
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
