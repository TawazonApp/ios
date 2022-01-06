//
//  SessionInfoViewController.swift
//  Tawazon
//
//  Created by Shadi on 23/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//


import UIKit

class SessionInfoViewController: HandleErrorViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: CircularButton!
    @IBOutlet weak var sessionImageView: UIImageView!
    @IBOutlet weak var sessionImageViewContainer: UIView!
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionAuthorLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
   
    var session: SessionVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        populateData()
    }
    
    private func initialize() {
        titleLabel.font = UIFont.kacstPen(ofSize: 24, language: .arabic)
        titleLabel.textColor = UIColor.white
        
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        sessionImageView.contentMode = .center
        sessionImageView.layer.cornerRadius = 40
        sessionImageView.layer.masksToBounds = true
        
        sessionImageViewContainer.layer.masksToBounds = false
        sessionImageViewContainer.layer.applySketchShadow(color: UIColor.black, alpha: 0.29, x: 0, y: 42, blur: 74, spread: 0)
        
        sessionTitleLabel.font = UIFont.lbcBold(ofSize: 24, language: .arabic)
        sessionTitleLabel.textColor = UIColor.white
        
        sessionAuthorLabel.font = UIFont.kacstPen(ofSize: 16, language: .arabic)
        sessionAuthorLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    private func populateData() {
        sessionTitleLabel.text = session.name
        sessionAuthorLabel.text = session.author
        if let localiImageUrl = session?.localImageUrl {
            let image = UIImage(contentsOfFile: localiImageUrl.path)
            backgroundImageView.image = image
            sessionImageView.image = image
        } else if let imageUrl = session?.imageUrl {
            backgroundImageView.af.setImage(withURL: imageUrl)
            sessionImageView.af.setImage(withURL: imageUrl)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
