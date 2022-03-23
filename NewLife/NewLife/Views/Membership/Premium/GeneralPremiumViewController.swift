//
//  GeneralPremiumViewController.swift
//  Tawazon
//
//  Created by mac on 22/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class GeneralPremiumViewController: UIViewController {

    enum NextView {
        case dimiss
        case mainViewController
    }
    var nextView: NextView = .dimiss
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewNameString = RemoteConfigManager.shared.string(forKey: .premuimPageViewName)
        let viewName = premuimPageViewNameValues.init(rawValue: viewNameString)
        switch viewName{
            case .defaultView:
                loadDefaultView()
            
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
        addChild(viewcontroller)
        viewcontroller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewcontroller.view)

        NSLayoutConstraint.activate([
            viewcontroller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            viewcontroller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            viewcontroller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            viewcontroller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])

        viewcontroller.didMove(toParent: self)
    }
    private func loadPremium4ViewController() {
        let viewcontroller = Premium4ViewController.instantiate(nextView: .dimiss)
        addChild(viewcontroller)
        viewcontroller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewcontroller.view)

        NSLayoutConstraint.activate([
            viewcontroller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            viewcontroller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            viewcontroller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            viewcontroller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])

        viewcontroller.didMove(toParent: self)
    }
    
    private func loadPremium5ViewController() {
        let viewcontroller = Premium5ViewController.instantiate(nextView: .dimiss)
        addChild(viewcontroller)
        viewcontroller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewcontroller.view)

        NSLayoutConstraint.activate([
            viewcontroller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            viewcontroller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            viewcontroller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            viewcontroller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])

        viewcontroller.didMove(toParent: self)
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
