//
//  SessionInfoDetailesViewController.swift
//  Tawazon
//
//  Created by mac on 23/10/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SessionInfoDetailesViewController: HandleErrorViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: CircularButton!
    @IBOutlet weak var shareButton: CircularButton!
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var sessionDescription: UITextView!
    @IBOutlet weak var largeDivider: UIImageView!
    @IBOutlet weak var largeSecondDivider: UIImageView!
    @IBOutlet weak var smallDivider: UIImageView!
    @IBOutlet weak var contributorsView: UIView!
    @IBOutlet weak var contributorsStackView: UIStackView!
    @IBOutlet weak var contributorsViewTitle: UILabel!
    
    @IBOutlet weak var authorView: UIView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorTitle: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorDescription: UILabel!
    
    @IBOutlet weak var narratorView: UIView!
    @IBOutlet weak var narratorImageView: UIImageView!
    @IBOutlet weak var narratorTitle: UILabel!
    @IBOutlet weak var narratorNameLabel: UILabel!
    @IBOutlet weak var narratorDescription: UILabel!
    
    @IBOutlet weak var sessionImageInfoView: UIView!
    @IBOutlet weak var imageInfoViewTitle: UILabel!
    @IBOutlet weak var sessionImageView: UIImageView!
    @IBOutlet weak var photogragherImageView: UIImageView!
    @IBOutlet weak var photogragherName: UILabel!
    @IBOutlet weak var photogragherDescription: UILabel!
    
    @IBOutlet weak var copyRightsLabel: UILabel!
    
    var session: SessionVM? {
        return SessionPlayerMananger.shared.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
//        fetchData()
        fillData()
    }
    
    private func initialize() {
        backgroundImageView.contentMode = .scaleToFill
        if let imageUrl = session?.imageUrl {
            backgroundImageView.af.setImage(withURL: imageUrl)
        }
        
        titleLabel.font = UIFont.lbc(ofSize: 28, language: .arabic)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        
        shareButton.setImage(#imageLiteral(resourceName: "ShareSession.pdf"), for: .normal)
        
        largeDivider.image = UIImage(named: "SessionInfoDividerLarge")
        largeDivider.contentMode = .scaleAspectFit
        
        largeSecondDivider.image = UIImage(named: "SessionInfoDividerLarge")
        largeSecondDivider.contentMode = .scaleAspectFit
        
        smallDivider.image = UIImage(named: "SessionInfoDividerSmall")
        smallDivider.contentMode = .scaleAspectFit
        
        sessionDescription.font = .munaFont(ofSize: 16)
        sessionDescription.textColor = .white.withAlphaComponent(0.86)
        
        contributorsViewTitle.font = .munaBoldFont(ofSize: 24)
        contributorsViewTitle.textColor = .white
        contributorsViewTitle.text = "contributorsViewTitle".localized
        
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.layer.cornerRadius = 20
        
        authorTitle.font = .munaFont(ofSize: 12)
        authorTitle.textColor = .white.withAlphaComponent(0.86)
        authorTitle.text = "authorTitle".localized
        
        authorNameLabel.font = .munaBoldFont(ofSize: 20)
        authorNameLabel.textColor = .white
        authorNameLabel.text = ""
        
        authorDescription.font = .munaFont(ofSize: 16)
        authorDescription.textColor = .white.withAlphaComponent(0.86)
        
        narratorImageView.contentMode = .scaleAspectFill
        narratorImageView.layer.cornerRadius = 20
        
        narratorTitle.font = .munaFont(ofSize: 12)
        narratorTitle.textColor = .white.withAlphaComponent(0.86)
        narratorTitle.text = "narratorTitle".localized
        
        narratorNameLabel.font = .munaBoldFont(ofSize: 20)
        narratorNameLabel.textColor = .white
        narratorNameLabel.text = ""
        
        narratorDescription.font = .munaFont(ofSize: 16)
        narratorDescription.textColor = .white.withAlphaComponent(0.86)
        
        imageInfoViewTitle.font = .munaBoldFont(ofSize: 24)
        imageInfoViewTitle.textColor = .white
        imageInfoViewTitle.text = "imageInfoViewTitle".localized
        
        sessionImageView.contentMode = .scaleAspectFill
        sessionImageView.layer.cornerRadius = 20
        
        photogragherImageView.contentMode = .scaleAspectFill
        photogragherImageView.layer.cornerRadius = 24
        
        photogragherName.font = .munaBoldFont(ofSize: 17)
        photogragherName.textColor = .white
        
        photogragherDescription.font = .munaFont(ofSize: 16)
        photogragherDescription.textColor = .white
        
        copyRightsLabel.font = .munaFont(ofSize:  12)
        copyRightsLabel.textColor = .white.withAlphaComponent(0.86)
        copyRightsLabel.numberOfLines = 0
        copyRightsLabel.lineBreakMode = .byWordWrapping
        copyRightsLabel.textAlignment = .center
        copyRightsLabel.text = "copyRightsLabel".localized
        
    }
    
    private func fetchData(){
        LoadingHud.shared.show(animated: true)
        session?.service.fetchSessionInfoDetails(sessionId: (session?.id)!){ (sessionModel, error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error{
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            if let sessionModel = sessionModel {
                SessionPlayerMananger.shared.session = SessionVM(service: SessionServiceFactory.service(), session: sessionModel)
                self.fillData()
            }
        }
    }
    
    private func fillData(){
        titleLabel.text = session?.name
        
        if let localImageUrl = session?.localImageUrl {
            let image = UIImage(contentsOfFile: localImageUrl.path)
            backgroundImageView.image = image
            sessionImageView.image = image
        } else if let imageUrl = session?.imageUrl {
            backgroundImageView.af.setImage(withURL: imageUrl)
            sessionImageView.af.setImage(withURL: imageUrl)
        }
        
        sessionDescription.text = session?.session?.descriptionString
        if let description = session?.session?.descriptionString, description.isEmptyWithTrim {
            contentStackView.removeArrangedSubview(sessionDescription)
            sessionDescription.removeFromSuperview()
            
            contentStackView.removeArrangedSubview(largeDivider)
            largeDivider.removeFromSuperview()
        }
        if session?.session?.artist == nil{
            contentStackView.removeArrangedSubview(photogragherName)
            photogragherName.removeFromSuperview()
            contentStackView.removeArrangedSubview(photogragherImageView)
            photogragherImageView.removeFromSuperview()
            contentStackView.removeArrangedSubview(photogragherDescription)
            photogragherDescription.removeFromSuperview()
            sessionImageInfoView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        }
        if let imageUrl = session?.session?.artist?.image?.url {
            photogragherImageView.af.setImage(withURL: imageUrl)
        }
        photogragherName.text = session?.session?.artist?.name
        photogragherDescription.text = (session?.session?.artist?.jobTitle != "" && session?.session?.artist?.country?.title != "") ? "\(session?.session?.artist?.jobTitle ?? "") . \(session?.session?.artist?.country?.title ?? "")" : "\(session?.session?.artist?.jobTitle ?? "")\(session?.session?.artist?.country?.title ?? "")"
        let test = session?.getSessionPreferredVoiceAndDialect().dialect
        
        if let dialect = session?.getSessionPreferredVoiceAndDialect().dialect{
            
            if dialect.author == nil && dialect.narrator == nil{
                contentStackView.removeArrangedSubview(contributorsView)
                contributorsView.removeFromSuperview()
                contentStackView.removeArrangedSubview(largeSecondDivider)
                largeSecondDivider.removeFromSuperview()
                return
            }
            
            if dialect.author == nil{
                contributorsStackView.removeArrangedSubview(authorView)
                authorView.removeFromSuperview()
            }
            if let imageUrl = dialect.author?.image?.url {
                authorImageView.af.setImage(withURL: imageUrl)
            }
            authorNameLabel.text = dialect.author?.name
            authorDescription.text = (dialect.author?.jobTitle != "" && dialect.author?.country?.title != "") ? "\(dialect.author?.jobTitle ?? "") . \(dialect.author?.country?.title ?? "")" : "\(dialect.author?.jobTitle ?? "")\(dialect.author?.country?.title ?? "")"
            
            if dialect.narrator == nil{
                contributorsStackView.removeArrangedSubview(narratorView)
                narratorView.removeFromSuperview()
            }
            
            if let imageUrl = dialect.narrator?.image?.url {
                narratorImageView.af.setImage(withURL: imageUrl)
            }
            narratorNameLabel.text = dialect.narrator?.name
            narratorDescription.text = (dialect.narrator?.jobTitle != "" && dialect.narrator?.country?.title != "") ? "\(dialect.narrator?.jobTitle ?? "") . \(dialect.narrator?.country?.title ?? "")" : "\(dialect.narrator?.jobTitle ?? "")\(dialect.narrator?.country?.title ?? "")"
            
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        showShareSessionView()
    }
    
    private func showShareSessionView() {
        guard let session = session else {
            return
        }
        
        let shareViewController = SessionShareViewController.instantiate(session: session)
        shareViewController.modalPresentationStyle = .custom
        shareViewController.transitioningDelegate = self
     
        self.present(shareViewController, animated: true, completion: nil)
    }
}

extension SessionInfoDetailesViewController {
    
    class func instantiate(session: SessionVM) -> SessionInfoDetailesViewController {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: SessionInfoDetailesViewController.identifier) as! SessionInfoDetailesViewController
        
        SessionPlayerMananger.shared.session = session
        return viewController
    }
    
}
