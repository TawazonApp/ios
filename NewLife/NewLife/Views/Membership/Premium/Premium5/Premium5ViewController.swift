//
//  Premium5ViewController.swift
//  Tawazon
//
//  Created by mac on 22/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import StoreKit

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
    
    var features: [FeatureItem]? {
        didSet {
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("subviews: \(self.view.subviews.count)")
        view.clearLabels()
        initialize()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.fetchData()
        }
        
    }
    private func fetchData(){
        LoadingHud.shared.show(animated: true)
        data.getPremiumPageDetails(premiumId: premiumPageIds.premium5.rawValue, service: MembershipServiceFactory.service(), completion: { (error) in
            LoadingHud.shared.hide(animated: true)
            self.features = self.data.premiumDetails?.premiumPage.featureItems.sorted(by: {$0.id < $1.id})
        })
    }
    
    private func initialize(){
        view.clearLabels()
        
        (view as? GradientView)?.applyGradientColor(colors: [UIColor.regalBlue.cgColor, UIColor.mariner.cgColor], startPoint: .bottom, endPoint: .top)
        headerView.backgroundColor = .regalBlue
        headerImage.image = UIImage(named: "Premium5Header")
        
        headerTitlePart1.font = .munaFont(ofSize: 18.0)
        headerTitlePart1.textColor = .white
        headerTitlePart1.text = "premium5TitlePart1".localized
        
        
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        contentTitle.font = .munaBoldFont(ofSize: 22.0)
        contentTitle.textColor = .white
        
        
        day1Label.font = .munaBoldFont(ofSize: 20.0)
        day1Label.textColor = UIColor.columbiaBlue
        
        
        day5Label.font = .munaBoldFont(ofSize: 20.0)
        day5Label.textColor = UIColor.macaroniAndCheese
        
        
        day7Label.font = .munaBoldFont(ofSize: 20.0)
        day7Label.textColor = UIColor.carnationPink
        
        
        gradientView.applyGradientColor(colors: [UIColor.columbiaBlue.cgColor, UIColor.tacao.cgColor, UIColor.darkPink.cgColor, UIColor.regalBlue.withAlphaComponent(0.4).cgColor, UIColor.regalBlue.withAlphaComponent(0.0).cgColor], startPoint: .top, endPoint: .bottom)
        gradientView.layer.cornerRadius = 22.0
        
        
        day1DescriptionLabel.font = .munaFont(ofSize: 17.0)
        day1DescriptionLabel.textColor = UIColor.white
        
        
        day5DescriptionLabel.font = .munaFont(ofSize: 17.0)
        day5DescriptionLabel.textColor = UIColor.white
        
        
        day7DescriptionLabel.font = .munaFont(ofSize: 17.0)
        day7DescriptionLabel.textColor = UIColor.white
        
        
        noteLabel.font = UIFont.munaBoldFont(ofSize: 16.0)
        noteLabel.textColor = UIColor.white
        
        
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
        purchaseButton.tintColor = .white
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
    }

    private func setData(){
        let attributedString = NSMutableAttributedString(string: data.premiumDetails?.premiumPage.title ?? "", attributes: [
            .font: UIFont.lbc(ofSize: 20.0),
          .foregroundColor: UIColor.white,
          .kern: 0.0
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "LBC-Bold", size: 20.0)!, range: Language.language == .arabic ?  NSRange(location: 25, length: 6) : NSRange(location: 8, length: 5))
        headerTitlePart2.attributedText = attributedString
        
        contentTitle.text = data.premiumDetails?.premiumPage.subtitle
        
        if let imagePath = features?[0].image{
            day1Image.af.setImage(withURL: imagePath.url!)
        }
        if let imagePath = features?[1].image{
            day5Image.af.setImage(withURL: imagePath.url!)
        }
        if let imagePath = features?[2].image{
            day7Image.af.setImage(withURL: imagePath.url!)
        }
        
        day1Label.text = features?[0].title
        day5Label.text = features?[1].title
        day7Label.text = features?[2].title
        
        day1DescriptionLabel.text = features?[0].content
        day5DescriptionLabel.text = features?[1].content
        day7DescriptionLabel.text = features?[2].content
        
        noteLabel.text = data.premiumDetails?.premiumPage.content
        
        purchaseButton.setTitle(data.premiumDetails?.premiumPage.continueLabel, for: .normal)
    }
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        let selectedPlan = data.plansArray.filter({$0.isSelected}).first
        let selectedProduct = data.products.filter({$0.productIdentifier == selectedPlan?.id}).first
        
        purchaseAction(product: selectedProduct)
    }
    
    @IBAction func redeemButtonTapped(_ sender: Any) {
        let paymentQueue = SKPaymentQueue.default()
        if #available(iOS 14.0, *) {
            DispatchQueue.main.async {
                paymentQueue.presentCodeRedemptionSheet()
            }
        }
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
