//
//  Premium1ViewController.swift
//  Tawazon
//
//  Created by mac on 23/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class Premium1ViewController: BasePremiumViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gradientHeader: GradientView!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var contentGradientView: GradientView!
    @IBOutlet weak var titlePart1Label: UILabel!
    @IBOutlet weak var titlePart2Label: UILabel!
    @IBOutlet weak var Premium1FeaturesTableView: UITableView!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var purchaseButton: GradientButton!
    
    var features: [FeatureItem]? {
        didSet {
            reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        
        data.getPremiumPageDetails(premiumId: premiumPageIds.premium1.rawValue, service: MembershipServiceFactory.service(), completion: { (error) in
            self.features = self.data.premiumDetails?.premiumPage.featureItems
        })
        
        print("Premium1ViewController: \(self.data.premiumDetails?.premiumPage.featureItems.first?.title)")
    }
    
    private func initialize(){
        
        view.backgroundColor = UIColor.cyprus
        
        gradientHeader.applyGradientColor(colors: [UIColor.cyprus.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.withAlphaComponent(0.48).cgColor, UIColor.cyprus.withAlphaComponent(0.0).cgColor], startPoint: .top, endPoint: .bottom)
       
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        
        contentGradientView.applyGradientColor(colors: [UIColor.christalle.cgColor,  UIColor.christalle.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.cgColor, UIColor.cyprus.withAlphaComponent(0.82).cgColor, UIColor.cyprus.withAlphaComponent(0.51).cgColor, UIColor.cyprus.withAlphaComponent(0.0).cgColor], startPoint: .bottom, endPoint: .top)
        
        titlePart1Label.font = UIFont.munaFont(ofSize: 18.0)
        titlePart1Label.textColor = .lightSlateBlue
        
        
        titlePart2Label.font = UIFont.munaBoldFont(ofSize: 32.0)
        titlePart2Label.textColor = .white
        
        
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
        purchaseButton.tintColor = .white
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        
        
        noteLabel.font = UIFont.munaFont(ofSize: 16.0)
        noteLabel.textColor = UIColor.white
        
    }
    private func setData(){
        if let imagePath = data.premiumDetails?.premiumPage.image{
            backgroundImage.af.setImage(withURL: imagePath.url!)
        }else{
            backgroundImage.image = UIImage(named: "Premium1Background1")
        }
        
        titlePart1Label.text = data.premiumDetails?.premiumPage.subtitle ?? "premium1TitlePart11".localized
        titlePart2Label.text = data.premiumDetails?.premiumPage.title ?? "premium1TitlePart21".localized
        
        purchaseButton.setTitle( data.premiumDetails?.premiumPage.continueLabel ?? "premium1PurchaseButtonTitle1".localized, for: .normal)
        
        noteLabel.text = data.premiumDetails?.premiumPage.content ?? "premium1DefaultPurchaseDescription1".localized
    }

    private func reloadData() {
        setData()
        Premium1FeaturesTableView.reloadData()
    }
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        let selectedPlan = data.plansArray.filter({$0.isSelected}).first
        let selectedProduct = data.products.filter({$0.productIdentifier == selectedPlan?.id}).first
        
        purchaseAction(product: selectedProduct)
    }
}
extension Premium1ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Premium1FeaturesTableViewCell.identifier) as! Premium1FeaturesTableViewCell
        cell.itemLabel.text = features?[indexPath.row].title
        return cell
    }
}
extension Premium1ViewController {
    
    class func instantiate(nextView: NextView) -> Premium1ViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Premium1ViewController.identifier) as! Premium1ViewController
        viewController.nextView = nextView
        return viewController
    }
}