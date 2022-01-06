//
//  SessionShareViewController.swift
//  Tawazon
//
//  Created by Shadi on 23/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit
import MessageUI

class SessionShareViewController: SessionInfoViewController {

    @IBOutlet weak var shareButton: ShareButtonView! {
        didSet {
            shareButton.delegate = self
        }
    }
    @IBOutlet weak var smsButton: ShareButtonView! {
        didSet {
            smsButton.delegate = self
        }
    }
    @IBOutlet weak var instagramButton: ShareButtonView! {
        didSet {
            instagramButton.delegate = self
        }
    }
    
    @IBOutlet weak var sessionInfoContainer: UIView! {
        didSet {
            instagramButton.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        titleLabel.text = "shareSessionViewTitle".localized
        shareButton.image = #imageLiteral(resourceName: "ShareByActivity.pdf")
        shareButton.title =   "shareByActivityButtonTitle".localized
        smsButton.image = #imageLiteral(resourceName: "ShareBySms.pdf")
        smsButton.title = "shareBySmsButtonTitle".localized
        
        instagramButton.image = #imageLiteral(resourceName: "ShareInstagramStory.pdf")
        instagramButton.title = "shareInstagramStoryButtonTitle".localized
    }
    
    func shareByActivity() {
        let shareText = getSessionShareBody()
        openActivityViewController(activityItems: [shareText])
    }
    
    func shareInstagramStory() {
        sessionImageViewContainer.layer.applySketchShadow(color: UIColor.black, alpha: 0.29, x: 0, y: 0, blur: 0, spread: 0)
        guard let image = sessionInfoContainer.viewToImage() else { return  }
        sessionImageViewContainer.layer.applySketchShadow(color: UIColor.black, alpha: 0.29, x: 0, y: 42, blur: 74, spread: 0)
        InstagramUtils.shareInstagramStory(image: image, link: session.shareUrl) { (_) in
            self.showErrorMessage(message: "instagramShareStoryErrorMessage".localized)
        }
    }
    
    func shareBySms() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.body = getSessionShareBody()
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func getSessionShareBody() -> String {
        return "shareSessionText".localized.appending(" \(session.name ?? "")\n\n\(session.shareUrl ?? "")")
    }
}

extension SessionShareViewController: ShareButtonViewDelegate {
    func shareButtonTapped(_ sender: ShareButtonView) {
        if sender == shareButton {
            shareByActivity()
        } else  if sender == smsButton {
            shareBySms()
        } else  if sender == instagramButton {
            shareInstagramStory()
        }
    }
}

extension SessionShareViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension SessionShareViewController {
    class func instantiate(session: SessionVM) -> SessionShareViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SessionShareViewController.identifier) as! SessionShareViewController
        viewController.session = session
        return viewController
    }
}
