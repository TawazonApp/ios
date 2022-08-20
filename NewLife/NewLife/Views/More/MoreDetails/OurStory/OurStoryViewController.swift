//
//  OurStoryViewController.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class OurStoryViewController: MoreDetailsViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionsView: OurStoryActionsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        fillData()
        sendOpenOurStoryEvent()
    }
    
    private func initialize() {
        logoImageView.image = #imageLiteral(resourceName: "Logo.pdf")
        sloganLabel.font = UIFont.lbc(ofSize: 24)
        sloganLabel.textColor = UIColor.white
        
        textView.textColor = UIColor.white
        textView.font = UIFont.kacstPen(ofSize: 17)
        
        actionsView.delegate = self
        
        backgroundImageName = "OurStoryBackground"
        title = "ourStoryViewTitle".localized
        textView.text = "ourStoryText".localized
        if Language.language == .arabic {
            textView.textAlignment = .right
        }else{
            textView.textAlignment = .left
        }
        sloganLabel.text = "launchSlogan".localized
        
    }
    
    private func fillData() {
        actionsView.fillData()
        DispatchQueue.main.async { [weak self] in
              self?.scrollView.setContentOffset(CGPoint(x: 0, y: -20), animated: false)
        }
    }
    
    private func sendOpenOurStoryEvent() {
        TrackerManager.shared.sendOpenOurStoryEvent()
    }
    
    private func sendRateAppEvent() {
        TrackerManager.shared.sendRateAppEvent()
    }
    
    private func sendShareAppEvent() {
        TrackerManager.shared.sendShareAppEvent()
    }
}

extension OurStoryViewController: OurStoryActionsViewDelegate {
    
    func rateAppTapped() {
        openRateAppView()
        sendRateAppEvent()
    }
    
    func shareAppTapped() {
        shareApp()
        sendShareAppEvent()
    }
    
    func openRateAppView() {
        UIApplication.tryURL(urls: [APPInfo.appRateUrl])
    }
    
    func shareApp() {
        let shareText = "shareAppText".localized.appending("\n\n\(APPInfo.appShareUrl)")
        self.openActivityViewController(activityItems: [shareText])
    }
}

extension OurStoryViewController {
    
    class func instantiate() -> OurStoryViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: OurStoryViewController.identifier) as! OurStoryViewController
        return viewController
    }
}
