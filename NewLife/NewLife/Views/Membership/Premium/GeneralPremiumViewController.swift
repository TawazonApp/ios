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
    
//    var fromBanner: Bool = false

    enum FromView {
        case list
        case session
        case section
        case profile
        case banner
    }

    var fromView: FromView = .session
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadParsedView()
    }
    private func loadParsedView(){
        var viewNameString = RemoteConfigManager.shared.string(forKey: .premuimPageViewName)
        
        switch fromView{
        case .list:
            viewNameString = RemoteConfigManager.shared.string(forKey: .premuimPageViewName)
        case .profile:
            viewNameString = RemoteConfigManager.shared.string(forKey: .profilePremuimPageViewName)
        case .session:
            viewNameString = RemoteConfigManager.shared.string(forKey: .homeFeedPremuimPageViewName)
        case .section:
            viewNameString = RemoteConfigManager.shared.string(forKey: .sectionPremuimPageViewName)
        case .banner:
            viewNameString = RemoteConfigManager.shared.string(forKey: .premuimOfBannerViewName)
        }
        
        let viewName = premuimPageViewNameValues.init(rawValue: viewNameString)
        switch viewName{
         case .defaultView:
             loadDefaultView()
         case .premiumOne:
             loadPremium1ViewController()
         case .premiumFour:
             loadPremium4ViewController()
         case .premiumFive:
             loadPremium5ViewController()
         case .premiumSix:
             loadPaywallViewController()
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
            let viewcontroller = Premium1ViewController.instantiate(nextView: .dimiss)
            self.navigationController!.setViewControllers([viewcontroller], animated: false)
        }
        
        
    }
    
    private func loadPremium4ViewController() {
        if UserInfoManager.shared.getUserInfo()?.isPremium() ?? false {
            loadPremiumPlanDetailsViewController()
        }else{
            let viewcontroller = PaywallViewController.instantiate(nextView: .dimiss)
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

    private func loadPaywallViewController() {
        if UserInfoManager.shared.getUserInfo()?.isPremium() ?? false {
            loadPremiumPlanDetailsViewController()
        }else{
            let viewcontroller = PaywallViewController.instantiate(nextView: .dimiss)
            self.navigationController!.setViewControllers([viewcontroller], animated: false)
        }
    }
    
    private func loadPremiumPlanDetailsViewController() {
        let viewcontroller = PremiumPlanDetailsViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
    }
    
}
extension GeneralPremiumViewController {
    
    class func instantiate(nextView: NextView, fromView: FromView) -> GeneralPremiumViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: GeneralPremiumViewController.identifier) as! GeneralPremiumViewController
        viewController.nextView = nextView
        viewController.fromView = fromView
        return viewController
    }
}
