//
//  DetailedSessionPlayerViewController.swift
//  Tawazon
//
//  Created by mac on 04/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import MediaPlayer
import NVActivityIndicatorView
import SwiftMessages





class DetailedSessionPlayerViewController: SuperSessionPlayerViewController {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var progressSlider: ProgressSlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var fullDurationLabel: UILabel!
    @IBOutlet weak var footerControlsStack: UIStackView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var contributorsStack: UIStackView!
    @IBOutlet      var authorInfoStack: UIStackView!
    @IBOutlet      var authorLabel: UILabel!
    @IBOutlet      var authorNameLabel: UILabel!
    @IBOutlet      var authorNameLabelCollapse: UIImageView!
    @IBOutlet      var narratorInfoStack: UIStackView!
    @IBOutlet      var narratorLabel: UILabel!
    @IBOutlet      var narratorNameLabel: UILabel!
    @IBOutlet      var narratorNameLabelCollapse: UIImageView!
    @IBOutlet weak var photographerInfoStack: UIStackView!
    @IBOutlet weak var photographerLabel: UILabel!
    @IBOutlet weak var photographerNameLabel: UILabel!
    @IBOutlet weak var photographerNameLabelCollapse: UIImageView!
    @IBOutlet      var separatorImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Language.language == .arabic{
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        initialize()
        fetchData()
        startPlayerLoadingIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPlayerLoadingIfNeeded()
        startGuidedTapping()
    }
    
    private func initialize() {
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
        favoriteButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        if session?.audioSources?.count ?? 0 == 1 && session?.audioSources?.first?.dialects.count == 1{
            voiceAndDialectsButton.isHidden = true
            footerControlsStack.removeArrangedSubview(voiceAndDialectsButton)
        }
        
        fullDurationLabel.font = UIFont.munaFont(ofSize: 14.0)
        fullDurationLabel.textColor = .white
        
        durationLabel.font = UIFont.munaFont(ofSize: 14.0)
        durationLabel.textColor = .white
        
        voiceAndDialectsButton.setTitle("voiceAndDialectsTitle".localized, for: .normal)
        voiceAndDialectsButton.tintColor = .white
        voiceAndDialectsButton.roundCorners(corners: .allCorners, radius: 12.0)
        voiceAndDialectsButton.titleLabel?.font = UIFont.munaFont(ofSize: 18)
        voiceAndDialectsButton.setImage(#imageLiteral(resourceName: "VoiceAndDialect"), for: .normal)
        voiceAndDialectsButton.backgroundColor = .darkGray.withAlphaComponent(0.16)
        if #available(iOS 13.0, *) {
            voiceAndDialectsButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            voiceAndDialectsButton.addBlurEffect(style: .dark)
        }

        progressSlider.tintColor = .white
        progressSlider.value = 0
        
        separatorImage.image = UIImage(named: "PremiumPurchaseIcon")
        separatorImage.contentMode = .scaleAspectFit
        separatorImage.backgroundColor = .clear
        separatorImage.isHidden = true
        
//        authorInfoStack.isHidden = true
        
        
        authorLabel.font = .munaFont(ofSize: 12)
        authorLabel.textAlignment = .center
        authorLabel.textColor = .white
        
        authorNameLabel.font = .munaBoldFont(ofSize: 18)
        authorNameLabel.textAlignment = .center
        authorNameLabel.textColor = .white
        
//        narratorInfoStack.isHidden = true
        
        narratorLabel.font = .munaFont(ofSize: 12)
        narratorLabel.textAlignment = .center
        narratorLabel.textColor = .white
        
        narratorNameLabel.font = .munaBoldFont(ofSize: 18)
        narratorNameLabel.textAlignment = .center
        narratorNameLabel.textColor = .white
        
//        photographerInfoStack.isHidden = true
        
        photographerLabel.font = .munaFont(ofSize: 12)
        photographerLabel.textAlignment = .center
        photographerLabel.textColor = .white
        
        photographerNameLabel.font = .munaBoldFont(ofSize: 18)
        photographerNameLabel.textAlignment = .center
        photographerNameLabel.textColor = .white
        
        let infoViewTappedGesture = UITapGestureRecognizer(target: self, action: #selector(infoViewTapped))
        infoView.addGestureRecognizer(infoViewTappedGesture)
        
        initializeBottomStackButtons()
    }
    @objc func infoViewTapped(){
        print("infoViewTapped")
        guard let session = session else { return }
        openSessionInfoDetailsViewController(session: session)
    }
    
    private func initializeBottomStackButtons() {
        let leftCorners : UIRectCorner = [[.bottomLeft, .topLeft]]
        let rightCorners : UIRectCorner = [.bottomRight, .topRight]
        shareButton.setImage(#imageLiteral(resourceName: "ShareSession.pdf"), for: .normal)
        shareButton.roundCorners(corners: Language.language == .english ? rightCorners : leftCorners, radius: 12.0)
        shareButton.backgroundColor = .darkGray.withAlphaComponent(0.26)
        shareButton.tintColor = .white
        if #available(iOS 13.0, *) {
            shareButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            shareButton.addBlurEffect(style: .dark)
        }
        
        rateButton.setImage(#imageLiteral(resourceName: "EmptyRateStar.pdf"), for: .normal)
        rateButton.roundCorners(corners: .allCorners, radius: 0.0)
        rateButton.backgroundColor = .darkGray.withAlphaComponent(0.16)
        rateButton.tintColor = .white
        if #available(iOS 13.0, *) {
            rateButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            rateButton.addBlurEffect(style: .dark)
        }
        
        commentsButton.setImage(#imageLiteral(resourceName: "Comments.pdf"), for: .normal)
        commentsButton.roundCorners(corners: Language.language == .english ? leftCorners : rightCorners, radius: 12.0)
        commentsButton.backgroundColor = .darkGray.withAlphaComponent(0.16)
        commentsButton.tintColor = .white
        if #available(iOS 13.0, *) {
            commentsButton.addBlurEffect(style: .systemUltraThinMaterialDark)
        } else {
            // Fallback on earlier versions
            commentsButton.addBlurEffect(style: .dark)
        }
    }
    private func fetchData(){
        session?.service.fetchSessionInfoDetails(sessionId: (session?.id)!){ (sessionModel, error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error{
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            if let sessionModel = sessionModel {
                SessionPlayerMananger.shared.session = SessionVM(service: SessionServiceFactory.service(), session: sessionModel)
                self.fillData()
                if self.separatorImage != nil{
                    self.separatorImage.isHidden = false
                }
                if self.session?.getSessionPreferredVoiceAndDialect().dialect?.author == nil{
                    if self.authorInfoStack != nil && self.separatorImage != nil{
                        self.authorInfoStack.removeFromSuperview()
                        self.separatorImage.removeFromSuperview()
                    }
                }else{
                    if !(self.contributorsStack.arrangedSubviews.first?.isEqual(self.authorInfoStack) ?? true){
                        self.contributorsStack.addArrangedSubview(self.authorInfoStack)
                        self.contributorsStack.addSubview(self.authorInfoStack)
                        self.contributorsStack.addArrangedSubview(self.separatorImage)
                        self.contributorsStack.addSubview(self.separatorImage)
                    }
                }
                if self.session?.getSessionPreferredVoiceAndDialect().dialect?.narrator == nil{
                    if self.narratorInfoStack != nil && self.separatorImage != nil{
                        self.narratorInfoStack.removeFromSuperview()
                        self.separatorImage.removeFromSuperview()
                    }
                }else{
                    if !(self.contributorsStack.arrangedSubviews.last?.isEqual(self.narratorInfoStack) ?? true) {
                        
                        self.contributorsStack.addArrangedSubview(self.separatorImage)
                        self.contributorsStack.addSubview(self.separatorImage)
                        
                        self.contributorsStack.addArrangedSubview(self.narratorInfoStack)
                        self.contributorsStack.addSubview(self.narratorInfoStack)
                        
                        self.contributorsStack.spacing = 10
                        self.contributorsStack.alignment = .fill
                        self.contributorsStack.distribution = .fillProportionally
                        self.contributorsStack.layoutSubviews()
                    }
                }
            }
        }
    }
    
    override func fillData() {
        super.fillData()
        fullDurationLabel.text = session?.durationString
        if let author = session?.getSessionPreferredVoiceAndDialect().dialect?.author{
            authorNameLabel.text = author.name
            authorNameLabelCollapse.image = UIImage(named: "SessionDetailsCollapse")?.flipIfNeeded
            authorLabel.text = "sessionAuthorLabel".localized
        }
        if let narrator = session?.getSessionPreferredVoiceAndDialect().dialect?.narrator{
            narratorNameLabel.text = narrator.name
            narratorNameLabelCollapse.image = UIImage(named: "SessionDetailsCollapse")?.flipIfNeeded
            narratorLabel.text = "sessionNarratorLabel".localized
        }
        if let photographer = session?.session?.artist{
            photographerNameLabel.text = photographer.name
            photographerNameLabelCollapse.image = UIImage(named: "SessionDetailsCollapse")?.flipIfNeeded
            photographerLabel.text = "sessionPhotographerLabel".localized
        }else{
            photographerInfoStack.isHidden = true
        }
        if session?.getSessionPreferredVoiceAndDialect().dialect?.author == nil && session?.getSessionPreferredVoiceAndDialect().dialect?.narrator == nil && photographerInfoStack.isHidden && (session?.session?.descriptionString == "" || session?.session?.descriptionString == nil){
            infoView.isUserInteractionEnabled = false
        }else{
            infoView.isUserInteractionEnabled = true
        }
    }
    
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fetchData()
        return nil
    }
    
    private func openSessionInfoDetailsViewController(session: SessionVM) {
        let viewcontroller = SessionInfoDetailesViewController.instantiate(session: session)
        viewcontroller.modalPresentationStyle = .custom
        viewcontroller.transitioningDelegate = self
        self.present(viewcontroller, animated: true, completion: nil)
    }
    
    private func startGuidedTapping(){
        let tourView = GuidedTourView(frame: self.view.frame)
        tourView.backgroundColor = .darkBlueGrey.withAlphaComponent(0.62)
        tourView.screenName = "Session"
                        
        var sessionPlayerGuidedTourSteps : [StepInfo] = []
        if UserDefaults.isFirstGuidedSession(){
            self.view.addSubview(tourView)
            
            sessionPlayerGuidedTourSteps.append(StepInfo(view: self.soundsButton!,position: self.rateButton.respectLanguageFrame(), textInfo: ("sound_effects","helpTextSoundsButton".localized), isBelow: true, isSameHierarchy: true))
            sessionPlayerGuidedTourSteps.append(StepInfo(view: self.downloadButton!,position: self.downloadButton.respectLanguageFrame(), textInfo: ("download","helpTextDownloadButton".localized), isBelow: true, isSameHierarchy: true))
            sessionPlayerGuidedTourSteps.append(StepInfo(view: self.favoriteButton!,position: self.favoriteButton.respectLanguageFrame(), textInfo: ("favorite","helpTextFavoriteButton".localized), isBelow: true, isSameHierarchy: true))
            if !self.voiceAndDialectsButton.isHidden{
                sessionPlayerGuidedTourSteps.append(StepInfo(view: self.voiceAndDialectsButton!,position: self.footerControlsStack.frame, textInfo: ("voices_dialects","helpTextVoiceAndDialectsButton".localized), isBelow: false, isSameHierarchy: true))
                UserDefaults.appSessionDialectButtonGuided()
            }
            
            sessionPlayerGuidedTourSteps.append(StepInfo(view: self.rateButton!,position: self.footerControlsStack.frame, textInfo: ("rate","helpTextRateButton".localized), isBelow: false, isSameHierarchy: true))
            sessionPlayerGuidedTourSteps.append(StepInfo(view: self.commentsButton!,position: self.footerControlsStack.frame, textInfo: ("rate","helpTextCommentsButton".localized), isBelow: false, isSameHierarchy: true))
            sessionPlayerGuidedTourSteps.append(StepInfo(view: self.shareButton!,position: self.footerControlsStack.frame, textInfo: ("share","helpTextShareButton".localized), isBelow: false, isSameHierarchy: true))
            
            UserDefaults.appSessionGuided()
        }else if UserDefaults.isFirstGuidedSessionDialectButton() && !self.voiceAndDialectsButton.isHidden{
            self.view.addSubview(tourView)
            sessionPlayerGuidedTourSteps.append(StepInfo(view: self.voiceAndDialectsButton!,position: self.footerControlsStack.frame, textInfo: ("voices_dialects","helpTextVoiceAndDialectsButton".localized), isBelow: false, isSameHierarchy: true))
            UserDefaults.appSessionDialectButtonGuided()
        }
        
        if sessionPlayerGuidedTourSteps.count > 0 {
            tourView.steps = sessionPlayerGuidedTourSteps
            TrackerManager.shared.sendGuidedTourStarted(viewName: "Session")
            tourView.showSteps()
        }
    }
    
    @IBAction func progressSliderTapped(_ sender: UISlider) {
        if isPlaying {
            isPlaying = !AudioPlayerManager.shared.isPlaying()
            AudioPlayerManager.shared.togglePlayPause()
        }
    }
    @IBAction func progressSliderValueChanged(_ sender: UISlider) {
       
        let newTime = sender.value * (AudioPlayerManager.shared.currentTrack?.durationInSeconds() ?? 0)
        let seekTime = CMTimeMake(value: Int64(newTime), timescale: 1)
        AudioPlayerManager.shared.seek(toTime: seekTime)
        updateSongInformation(with: AudioPlayerManager.shared.currentTrack)
        if !isPlaying {
            isPlaying = !AudioPlayerManager.shared.isPlaying()
            AudioPlayerManager.shared.togglePlayPause()
        }
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        showCommentsViewController()
    }
    
    private func showCommentsViewController(){
        guard let session = session else {
            return
        }
        let CommentsViewController = SessionCommentsViewController.instantiate(session: session)
        self.present(CommentsViewController, animated: true, completion: nil)
    }
}


extension DetailedSessionPlayerViewController {
    
    private func initPlaybackTimeViews() {
        progressSlider.value = 0
    }
    
    override func updatePlaybackTime(_ track: AudioTrack?) {
        super.updatePlaybackTime(track)
        progressSlider.value = Float(CGFloat(track?.currentProgress() ?? 0))
        durationLabel.text = track?.displayablePlaybackTimeString()
    }
    
    override func startPlayerLoadingIfNeeded() {
        if playingLoading == nil {
            playingLoading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: view.frame.height/3), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.white, padding: nil)

            view.addSubview(playingLoading!)
            playingLoading?.translatesAutoresizingMaskIntoConstraints = false
            playingLoading?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            playingLoading?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            playingLoading?.startAnimating()
        }
        playButton.alpha = 0.5
        playButton.isEnabled = false
        controlsView.alpha = 0.5
        controlsView.isUserInteractionEnabled = false
    }
    
    private func stopPlayerLoading() {
        if playingLoading != nil {
            playingLoading?.stopAnimating()
            playingLoading = nil
        }
        playButton.alpha = 1.0
        playButton.isEnabled = true
        controlsView.alpha = 1.0
        controlsView.isUserInteractionEnabled = true
    }
    
}

extension DetailedSessionPlayerViewController {
    
    class func instantiate(session: SessionVM, delegate: SessionPlayerDelegate?) -> DetailedSessionPlayerViewController {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: DetailedSessionPlayerViewController.identifier) as! DetailedSessionPlayerViewController
        viewController.delegate = delegate
        SessionPlayerMananger.shared.session = session
        return viewController
    }
    
}


