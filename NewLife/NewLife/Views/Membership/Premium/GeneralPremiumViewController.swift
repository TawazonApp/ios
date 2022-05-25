//
//  GeneralPremiumViewController.swift
//  Tawazon
//
//  Created by mac on 22/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

enum premiumPageIds: Int{
    case defaultPage = 0
    case premium1 = 1
    case premium4 = 3
    case premium5 = 5
}
class GeneralPremiumViewController: BasePremiumViewController {
    
    var fromBanner: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadParsedView()
    }
    private func loadParsedView(){
        let viewNameString = premuimPageViewNameValues.premiumFour.rawValue
        let bannerNameString = RemoteConfigManager.shared.string(forKey: .premuimOfBannerViewName)
        let viewName = fromBanner == false ? premuimPageViewNameValues.init(rawValue: viewNameString): premuimPageViewNameValues.init(rawValue: bannerNameString)
        switch viewName{
            case .defaultView:
                loadDefaultView()
            
        case .premiumOne:
        loadPremium1ViewController()
            
            case .premiumFour:
            loadPremium4ViewController()
            
            case .premiumFive:
                loadPremium5ViewController()
            
            case .none:
            loadDefaultView()
        }
    }
   
    private func loadDefaultView(){
        let viewcontroller = PremiumViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
    }
    
    private func loadPremium1ViewController() {
        if UserInfoManager.shared.getUserInfo()?.isPremium() ?? false {
            loadPremiumPlanDetailsViewController()
        }else{
//            let viewcontroller = Premium1ViewController.instantiate(nextView: .dimiss)
//            addChild(viewcontroller)
//            viewcontroller.view.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(viewcontroller.view)
//
//            NSLayoutConstraint.activate([
//                viewcontroller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//                viewcontroller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//                viewcontroller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//                viewcontroller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//            ])
//
//            viewcontroller.didMove(toParent: self)
            
            let viewcontroller = Premium1ViewController.instantiate(nextView: .dimiss)
            self.navigationController!.setViewControllers([viewcontroller], animated: false)
        }
        
        
    }
    
    private func loadPremium4ViewController() {
        if UserInfoManager.shared.getUserInfo()?.isPremium() ?? false {
            loadPremiumPlanDetailsViewController()
        }else{
            let viewcontroller = Premium4ViewController.instantiate(nextView: .dimiss)
            self.navigationController!.setViewControllers([viewcontroller], animated: false)
        }
    }
    
    private func loadPremium5ViewController() {
        if UserInfoManager.shared.getUserInfo()?.isPremium() ?? false {
            loadPremiumPlanDetailsViewController()
        }else{
            let viewcontroller = Premium5ViewController.instantiate(nextView: .dimiss)
            self.navigationController!.setViewControllers([viewcontroller], animated: false)
        }
    }

    private func loadPremiumPlanDetailsViewController() {
        let viewcontroller = PremiumPlanDetailsViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
    }
    
}
extension GeneralPremiumViewController {
    
    class func instantiate(nextView: NextView) -> GeneralPremiumViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: GeneralPremiumViewController.identifier) as! GeneralPremiumViewController
        viewController.nextView = nextView
        return viewController
    }
}
