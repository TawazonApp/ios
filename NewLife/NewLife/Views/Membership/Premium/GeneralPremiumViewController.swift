//
//  GeneralPremiumViewController.swift
//  Tawazon
//
//  Created by mac on 22/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

enum premiumPageIds: Int, CaseIterable{
    case defaultPage = 0
    case premiumOne = 1
    case premiumFour = 3
    case premiumFive = 5
    case paywall = 9
    case paywallAllPlans = 11
    
    static func fromKey(_ keyString: String) -> premiumPageIds? {
            return self.allCases.first{ "\($0)" == keyString }
        }
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
        
//        switch fromView{
//        case .list:
//            viewNameString = RemoteConfigManager.shared.string(forKey: .premuimPageViewName)
//        case .profile:
//            viewNameString = RemoteConfigManager.shared.string(forKey: .profilePremuimPageViewName)
//        case .session:
//            viewNameString = RemoteConfigManager.shared.string(forKey: .homeFeedPremuimPageViewName)
//        case .section:
//            viewNameString = RemoteConfigManager.shared.string(forKey: .sectionPremuimPageViewName)
//        case .banner:
//            viewNameString = RemoteConfigManager.shared.string(forKey: .premuimOfBannerViewName)
//        }
        
        if UserInfoManager.shared.getUserInfo()?.isPremium() ?? false {
            loadPremiumPlanDetailsViewController()
        }else{
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
             case .paywall:
                 loadPaywallViewController()
            case .none:
                loadDefaultView()
            }
        }
    }
   
    private func loadDefaultView(){
        let viewcontroller = PremiumViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
    }
    
    private func loadPremium1ViewController() {
        let viewcontroller = Premium1ViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
    }
    
    private func loadPremium4ViewController() {
        let viewcontroller = Premium4ViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
    }
    
    private func loadPremium5ViewController() {
        let viewcontroller = Premium5ViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
    }

    private func loadPaywallViewController() {
        let viewcontroller = PaywallViewController.instantiate(nextView: .dimiss)
        self.navigationController!.setViewControllers([viewcontroller], animated: false)
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
