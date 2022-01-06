//
//  HandleErrorViewController.swift
//  NewLife
//
//  Created by Shadi on 13/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import SwiftMessages

class HandleErrorViewController: BaseViewController {

    var swiftMessages: SwiftMessages?
    var hideErrorDidDisappear: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if hideErrorDidDisappear {
            hideErrorMessage()
        }
    }

    func showErrorMessage(title: String? = nil, message: String) {
        
        if swiftMessages != nil {
            swiftMessages?.hide()
            swiftMessages = nil
        }
        
        swiftMessages = SwiftMessages()
        
        guard let swiftMessages = swiftMessages else { return }
        
        let errorView = MessageView.viewFromNib(layout: .messageView)
        addBlurView(toErrorView: errorView)
        errorView.configureTheme(backgroundColor: UIColor.black.withAlphaComponent(0.5), foregroundColor: UIColor.white, buttonBackgroundColor: UIColor.white.withAlphaComponent(0.3), iconImage: nil, iconText: nil, titleFont: UIFont.kacstPen(ofSize: 18), bodyFont: UIFont.kacstPen(ofSize: 16), buttonFont: UIFont.kacstPen(ofSize: 16))
       let hideImage = UIImage(named: "AlertDismiss")
        errorView.configureContent(title: title, body: message, iconImage: UIImage(named: "ErrorAlertIcon") , iconText: nil, buttonImage: hideImage, buttonTitle: nil) { (button) in
            swiftMessages.hide()
        }
        
        var config = swiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .view(self.view)
        config.duration = .seconds(seconds: 6)
        config.dimMode = .none
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
        errorView.button?.isHidden = false

        if let hideImage = hideImage {
            errorView.button?.contentEdgeInsets = UIEdgeInsets.zero
            errorView.button?.layer.cornerRadius = hideImage.size.height/2
        }
        
        swiftMessages.show(config: config, view: errorView)
    }
    
    func hideErrorMessage() {
        if swiftMessages != nil {
            swiftMessages?.hide()
            swiftMessages = nil
        }
    }
    
    private func addBlurView(toErrorView errorView: UIView) {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        errorView.insertSubview(blurView, at: 0)
        blurView.leadingAnchor.constraint(equalTo: errorView.leadingAnchor).isActive = true
         blurView.topAnchor.constraint(equalTo: errorView.topAnchor).isActive = true
         blurView.trailingAnchor.constraint(equalTo: errorView.trailingAnchor).isActive = true
         blurView.bottomAnchor.constraint(equalTo: errorView.bottomAnchor).isActive = true
    }

}

extension MessageView {
    public func configureTheme(backgroundColor: UIColor, foregroundColor: UIColor, buttonBackgroundColor: UIColor, iconImage: UIImage?, iconText: String?, titleFont: UIFont, bodyFont: UIFont, buttonFont: UIFont) {
        configureTheme(backgroundColor: backgroundColor, foregroundColor: foregroundColor, buttonBackgroundColor: buttonBackgroundColor, iconImage: iconImage, iconText: iconText)
        titleLabel?.font = titleFont
        bodyLabel?.font = bodyFont
        button?.titleLabel?.font = buttonFont
    }
}
