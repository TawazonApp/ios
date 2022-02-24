//
//  SessionRateViewController.swift
//  Tawazon
//
//  Created by Shadi on 23/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class SessionRateViewController: SessionInfoViewController {
    @IBOutlet weak var rateView: SwiftyStarRatingView!
    @IBOutlet weak var rateButton: UIButton!

    lazy var viewModel = SessionRateVM(service: SessionServiceFactory.service())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        titleLabel.text = "rateSessionViewTitle".localized
        rateView.maximumValue = 5
        rateView.minimumValue = 0
        rateView.value = 5
        rateView.filledStarImage = #imageLiteral(resourceName: "FillRateStar.pdf")
        rateView.emptyStarImage = #imageLiteral(resourceName: "EmptyRateStar.pdf")
        
        rateButton.setTitle("rateSessionButtonTitle".localized, for: .normal)
        rateButton.tintColor = UIColor.white
        rateButton.layer.cornerRadius = rateButton.frame.height/2.5
        rateButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    @IBAction func rateButtonTapped(_ sender: UIButton) {
        guard let sessionId = session.id else {
            return
        }
        viewModel.rateSession(sessionId: sessionId , rate: Int(rateView.value)) { (_ error) in
            if error == nil {
                UserDefaults.sessionRated(sessionId: sessionId)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SessionRateViewController {
    class func instantiate(session: SessionVM) -> SessionRateViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SessionRateViewController.identifier) as! SessionRateViewController
        viewController.session = session
        return viewController
    }
    
    class func show(session: SessionVM, from: UIViewController, force: Bool) {
        guard let seesionId = session.id else {
            return
        }
        if !force {
            if UserDefaults.isSessionRated(sessionId: seesionId) || Int.random(in: 0 ... 10) % 3 != 0 {
                return
            }
        }
        if session.session?.isLock ?? false {
            return
        }
        let rateViewController = SessionRateViewController.instantiate(session: session)
        rateViewController.modalPresentationStyle = .custom
        rateViewController.transitioningDelegate = from
        from.present(rateViewController, animated: true)
    }
}
