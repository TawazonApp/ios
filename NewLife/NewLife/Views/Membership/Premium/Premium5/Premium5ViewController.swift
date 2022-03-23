//
//  Premium5ViewController.swift
//  Tawazon
//
//  Created by mac on 22/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class Premium5ViewController: BasePremiumViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var headerTitlePart1: UILabel!
    @IBOutlet weak var headerTitlePart2: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTitle: UILabel!
    
    @IBOutlet weak var daysStack: UIStackView!
    @IBOutlet weak var day1Label: UILabel!
    @IBOutlet weak var day5Label: UILabel!
    @IBOutlet weak var day7Label: UILabel!
    
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var daysImagesStack: UIStackView!
    @IBOutlet weak var day1Image: UIImageView!
    @IBOutlet weak var day5Image: UIImageView!
    @IBOutlet weak var day7Image: UIImageView!
    
    @IBOutlet weak var daysDescriptionStack: UIStackView!
    @IBOutlet weak var day1DescriptionLabel: UILabel!
    @IBOutlet weak var day5DescriptionLabel: UILabel!
    @IBOutlet weak var day7DescriptionLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var purchaseButton: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }
    
    private func initialize(){
        (view as? GradientView)?.applyGradientColor(colors: [UIColor.regalBlue.cgColor, UIColor.mariner.cgColor], startPoint: .bottom, endPoint: .top)
        headerView.backgroundColor = .regalBlue
        headerImage.image = UIImage(named: "Premium5Header")
        
        headerTitlePart1.font = .munaFont(ofSize: 18.0)
        headerTitlePart1.textColor = .white
        headerTitlePart1.text = "premium5TitlePart1".localized
        
        let attributedString = NSMutableAttributedString(string: "premium5TitlePart2".localized, attributes: [
            .font: UIFont.lbc(ofSize: 20.0),
          .foregroundColor: UIColor.white,
          .kern: 0.0
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "LBC-Bold", size: 20.0)!, range: Language.language == .arabic ?  NSRange(location: 25, length: 6) : NSRange(location: 8, length: 5))
        headerTitlePart2.attributedText = attributedString
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        contentTitle.font = .munaBoldFont(ofSize: 22.0)
        contentTitle.textColor = .white
        contentTitle.text = "premium5ContentTitle".localized
        
        day1Label.font = .munaBoldFont(ofSize: 20.0)
        day1Label.textColor = UIColor.columbiaBlue
        day1Label.text = "premium5Day1Title".localized
        
        day5Label.font = .munaBoldFont(ofSize: 20.0)
        day5Label.textColor = UIColor.macaroniAndCheese
        day5Label.text = "premium5Day5Title".localized
        
        day7Label.font = .munaBoldFont(ofSize: 20.0)
        day7Label.textColor = UIColor.carnationPink
        day7Label.text = "premium5Day7Title".localized
        
        gradientView.applyGradientColor(colors: [UIColor.columbiaBlue.cgColor, UIColor.tacao.cgColor, UIColor.darkPink.cgColor, UIColor.regalBlue.withAlphaComponent(0.4).cgColor, UIColor.regalBlue.withAlphaComponent(0.0).cgColor], startPoint: .top, endPoint: .bottom)
        gradientView.layer.cornerRadius = 22.0
        day1Image.image = UIImage(named: "Premium5Day1")
        day5Image.image = UIImage(named: "Premium5Day5")
        day7Image.image = UIImage(named: "Premium5Day7")
        
        day1DescriptionLabel.font = .munaFont(ofSize: 17.0)
        day1DescriptionLabel.textColor = UIColor.white
        day1DescriptionLabel.text = "premium5Day1DescriptionTitle".localized
        
        day5DescriptionLabel.font = .munaFont(ofSize: 17.0)
        day5DescriptionLabel.textColor = UIColor.white
        day5DescriptionLabel.text = "premium5Day5DescriptionTitle".localized
        
        day7DescriptionLabel.font = .munaFont(ofSize: 17.0)
        day7DescriptionLabel.textColor = UIColor.white
        day7DescriptionLabel.text = "premium5Day7DescriptionTitle".localized
        
        noteLabel.font = UIFont.munaBoldFont(ofSize: 16.0)
        noteLabel.textColor = UIColor.white
        noteLabel.text = "defaultPurchaseDescriptionPremium5".localized
        
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
        purchaseButton.setTitle("purchaseButtonTitlePremium5".localized, for: .normal)
        purchaseButton.tintColor = .white
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
    }

    @IBAction func purchaseButtonTapped(_ sender: Any) {
        print("purchaseButtonTapped:")
//        purchaseAction(product: plansContainer.plans[safe: plansContainer.selectedPlan])
    }
}
extension Premium5ViewController {
    
    class func instantiate(nextView: NextView) -> Premium5ViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Premium5ViewController.identifier) as! Premium5ViewController
        viewController.nextView = nextView
        return viewController
    }
}
