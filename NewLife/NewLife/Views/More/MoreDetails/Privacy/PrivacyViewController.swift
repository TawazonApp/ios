//
//  PrivacyViewController.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PrivacyViewController: MoreDetailsViewController {
    
    enum ViewType {
        case privacyPolicy
        case termsAndConditions
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var viewType: ViewType = .privacyPolicy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        sendOpenViewEvent()
    }
    
    private func sendOpenViewEvent() {
        switch viewType {
        case .privacyPolicy:
            sendOpenPrivacyPolicyEvent()
        case .termsAndConditions:
            sendOpenTermsOfUseEvent()
        }
    }
    private func initialize() {
        view.backgroundColor = UIColor.clear
        
        textView.textColor = UIColor.white
        backgroundImageName = nil
        title = getTitle()
        textView.attributedText = attributedText()
        textView.font = UIFont.kacstPen(ofSize: 14)
        textView.textColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [weak self] in
            self?.textView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
      
    }
    
    private func getTitle() -> String {
        switch viewType {
        case .privacyPolicy:
            return "privacyViewTitle".localized
        case .termsAndConditions:
            return "termsAndConditionsViewTitle".localized
        }
    }
    
    private func getFileName() -> String {
        switch viewType {
        case .privacyPolicy:
            return "PrivacyPolicy"
        case .termsAndConditions:
            return "TermsAndConditions"
        }
    }
    
    private func attributedText() -> NSAttributedString? {
        if let rtfPath = Bundle.main.url(forResource: getFileName(), withExtension: "rtf") {
           
                let attributedString = try? NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            return attributedString
        }
        return nil
    }
    
    private func sendOpenPrivacyPolicyEvent() {
        TrackerManager.shared.sendOpenPrivacyPolicyEvent()
    }
    
    private func sendOpenTermsOfUseEvent() {
        TrackerManager.shared.sendOpenTermsOfUseEvent()
    }
}

extension PrivacyViewController {
    
    class func instantiate(viewType: PrivacyViewController.ViewType) -> PrivacyViewController {
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PrivacyViewController.identifier) as! PrivacyViewController
        viewController.viewType = viewType
        return viewController
    }
}
